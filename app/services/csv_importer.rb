require "csv"

class CsvImporter
    attr_reader :user_id, :model_name, :csv_file_path, :header_mapping

    def initialize(user_id:, model_name:, csv_file_path:, header_mapping:)
      @user_id = user_id
      @model_name = model_name
      @csv_file_path = csv_file_path
      @header_mapping = header_mapping
    end

    def import
      CSV.foreach(csv_file_path, :headers => true) do |row|
        Model.create!(user_id: user_id, otype: model_name, data: mapped_hash(row))
      end
    end

    def self.import(user_id:, model_name:, csv_file_path:, header_mapping:)
      new(user_id: user_id,
        model_name: model_name,
        csv_file_path: csv_file_path,
        header_mapping: header_mapping
      ).import
    end

    def mapped_hash(row)
      Hash[row.to_hash.map {|k, v| [header_mapping[k], v] }]
    end

  end
