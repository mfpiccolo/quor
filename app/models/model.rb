class Model < Ply
  has_many :users

  after_initialize :set_blank_ply_attributes

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

  def row(index_hash)
    index_hash.merge(data)
  end


  private

  def set_blank_ply_attributes
    Model.data_keys(otype).each do |k|
      begin
        self.send(k.to_sym)
      rescue NoMethodError
        instance_variable_set(('@' + k.to_s).to_sym, "")
        define_singleton_method(k) { instance_variable_get(('@' + k.to_s).to_sym) }
      end
    end
  end

end
