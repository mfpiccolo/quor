require "csv"

class CsvImporter
    attr_reader :user_id, :model_name, :csv_file

    def initialize(user_id:, model_name:, csv_file:)
      @user_id = user_id
      @model_name = model_name
      @csv_file = csv_file
    end

    def import
      CSV.foreach(csv_file.path, :headers => true) do |row|
        Model.create!(user_id: user_id, otype: model_name, data: row.to_hash)
      end
      redirect_to models_path
    end

    def self.import(user_id:, model_name:, csv_file:)
      new(user_id: user_id,
        model_name: model_name,
        csv_file: csv_file,
      ).import
    end

  end
