class Model < Ply
  has_many :users

  def self.model_names
    pluck(:otype).uniq
  end

  def self.model_data_keys
    query = "select distinct json_object_keys(data) from plies;"
    results = ActiveRecord::Base.connection.execute(query)
    results.values.flatten
  end

  def row(index_hash)
    index_hash.merge(data)
  end

end
