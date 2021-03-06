class Model < Pliable::Ply
  belongs_to :user

  attr_accessor :parent_id_keys, :parent_scopes, :child_id_keys, :child_scopes

  after_initialize :set_ply_attributes
  before_save :check_state

  has_paper_trail meta: { otype: :otype, diff: :changes, whodunnit_email: :whodunnit_email }

  has_many :versions, as: :item
  belongs_to :model_state

  # TODO fix pg search
  include PgSearch
  pg_search_scope :search_data,
    against: :data,
    using: [:tsearch]

  def self.model_names
    pluck(:otype).uniq
  end

  def self.data_keys(otype: nil, user_id: nil, not_otype: nil, parent_id: nil)
    if user_id.present? && otype.present?
      query = "select distinct json_object_keys(data) from plies where user_id = '#{user_id}' AND otype = '#{otype}'"
    elsif user_id.present?
      query = "select distinct json_object_keys(data) from plies where user_id = '#{user_id}'"
    elsif otype.present?
      query = "select distinct json_object_keys(data) from plies where otype = '#{otype}'"
    end

    if query.present?
      query += " AND otype != '#{not_otype}'" if not_otype.present?
      query += " AND (data->>'#{not_otype.downcase}_id')::int = #{parent_id}" if parent_id.present?
      results = ActiveRecord::Base.connection.execute(query)
      results.values.flatten
    end
  end

  def to_param
    id.to_s
  end

  def row(index_hash)
    index_hash.merge(data)
  end

  def parents_present?
    load_parent_id_keys.present?
  end

  def child_scope
    if respond_to?(:external_id)
      Model.where(user_id: user_id).where("(data->>'#{otype.downcase}_id')::int = #{external_id}")
    end
  end

  def child_models
    query = "select distinct otype from plies where user_id = #{user_id} AND ((data->>'#{otype.downcase}_id')::int = #{external_id})"
    results = ActiveRecord::Base.connection.execute(query).values.flatten
  end

  def child_scopes
    if respond_to?(:external_id)
      child_models.map { |m| ActiveSupport::Inflector.pluralize(m).downcase.to_sym }
    end
  end

  def model_data_keys
    Model.data_keys(otype: otype)
  end

  def changes
    changes_hash = ActiveSupport::HashWithIndifferentAccess[changed.map { |attr| [attr, attribute_change(attr)] }]
    if changes_hash.keys.include?("data")
      changes_hash.merge!(changes_hash["data"])
      changes_hash.delete("data")
    end
    changes_hash
  end

  def attribute_change(attr)
    if attr == "data"
      get_attr = diff(raw_data_hash, data)
    else
      [changed_attributes[attr], __send__(attr)] if attribute_changed?(attr)
    end
  end

  def update_attributes(attributes)
    # The following transaction covers any possible database side-effects of the
    # attributes assignment. For example, setting the IDs of a child collection.
    current_changes = if changes.present?
      changes
    else
      diff(@raw_attributes.select {|k,v| attributes.keys.map(&:to_s).include?(k)}, attributes)
    end

    attributes.merge!(last_version_changes: current_changes)
    with_transaction_returning_status do
      assign_attributes(attributes)
      save
    end
  end

  def whodunnit_email
    User.find(PaperTrail.whodunnit).email if PaperTrail.whodunnit.present?
  end


  private

  def check_state
    self.state = model_state.name if model_state.present?
  end

  def set_ply_attributes
    @data_attrs = []
    data.merge!(external_id: data["id"]).delete("id") if data.keys.any? { |k| k == "id" }
    if data.present?
      data.each do |key,value|
        define_singleton_method(key.to_s) { self.data[key] }
        define_singleton_method(key.to_s + "=") { |a| self.data[key] = a }
        @data_attrs << key
      end
    end
  end

  def set_blank_ply_attributes
    if model_data_keys = Model.data_keys(otype: otype)
      model_data_keys.each do |k|
        unless self.respond_to?(k.to_sym)
          instance_variable_set(('@' + k.to_s).to_sym, "")
          define_singleton_method(k) { instance_variable_get(('@' + k.to_s).to_sym) }
        end
      end
    end
  end

  def method_missing(name, *args)
    # TODO protect agains malicious attrs
    unless [:otype, :data].include?(name)
      set_blank_ply_attributes
      if self.respond_to?(name)
        self.send(name, *args)
      elsif parents_present? && self.parent_scopes.include?(name)
        set_parent_scopes
        self.send(name)
      elsif child_scope.present?
        set_children_scopes
        self.send(name)
      else
        super
      end
    else
      super
    end
  end

  def set_parent_scopes
    parent_id_keys.each do |k|
      model_type = ActiveSupport::Inflector.humanize(k.to_sym)
      scope_name = ActiveSupport::Inflector.pluralize(model_type).downcase
      define_singleton_method(scope_name) do
        Model.where("user_id = #{user_id} AND otype = '#{model_type}' AND (data->>'external_id')::int = #{self.send(k.to_sym)}")
      end
    end
  end

  def load_parent_id_keys
    self.parent_id_keys = Model.data_keys(user_id: user_id, otype: otype).select {|k| k.match(/_id$/) unless k == "external_id" }
    self.parent_scopes = parent_id_keys.map {|k| ActiveSupport::Inflector.humanize(k).pluralize.downcase.to_sym }
    parent_id_keys
  end

  def set_children_scopes
    child_models.each do |model_type|
      scope_name = ActiveSupport::Inflector.pluralize(model_type).downcase
      foreign_key = otype.foreign_key
      define_singleton_method(scope_name) do
        Model.where("user_id = #{user_id} AND otype = '#{model_type}' AND (data->>'#{foreign_key}')::int = #{external_id}")
      end
    end
  end

  def diff(hash1, hash2)
    hash1 = ActiveSupport::HashWithIndifferentAccess.new(hash1)
    hash2 = ActiveSupport::HashWithIndifferentAccess.new(hash2)
    hash1.keys.inject({}) do |memo, key|
      unless hash1[key] == hash2[key]
        memo[key] = [hash1[key], hash2[key]]
      end
      memo
    end
  end

   def raw_data_hash
    if @raw_attributes["data"].is_a? String
      JSON.parse(@raw_attributes["data"])
    elsif @raw_attributes.is_a? Hash
      @raw_attributes["data"]
    end
   end

end
