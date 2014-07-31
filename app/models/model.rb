class Model < Pliable::Ply
  belongs_to :user

  after_initialize :set_ply_attributes

  include PgSearch
  pg_search_scope :search_data,
    against: :data,
    using: [:tsearch]

  def self.model_names
    pluck(:otype).uniq
  end

  def self.data_keys(model_otype)
    query = "select distinct json_object_keys(data) from plies where otype = '#{model_otype}';"
    results = ActiveRecord::Base.connection.execute(query)
    results.values.flatten
  end

  def to_param
    id.to_s
  end

  def row(index_hash)
    index_hash.merge(data)
  end


  private

  def set_ply_attributes
    data.merge!(external_id: data["id"]).delete("id") if data.keys.any? { |k| k == "id" }

    if data.present?
      data.each do |key,value|
        define_singleton_method(key.to_s) { self.data[key] }
        define_singleton_method(key.to_s + "=") {|a| self.data[key] = a}
      end
    end
  end

  def method_missing(name, *)
    set_blank_ply_attributes
    if self.respond_to?(name)
      self.send(name)
    elsif children.pluck("DISTINCT child_type").present? || parents.pluck("DISTINCT child_type").present?
      define_ply_scopes
      self.send(name)
    else
      super
    end
  end

  def set_blank_ply_attributes
    Model.data_keys(otype).each do |k|
      unless self.respond_to?(k.to_sym)
        instance_variable_set(('@' + k.to_s).to_sym, "")
        define_singleton_method(k) { instance_variable_get(('@' + k.to_s).to_sym) }
      end
    end
  end

end
