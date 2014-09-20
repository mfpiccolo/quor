require "csv"
class ImportsController < ApplicationController

  def new
    # @file_path = params[:file].path
    # @file = params[:file]
    # @file = Base64.encode64(params[:file].read)
    uploader = CsvUploader.new
    uploader.store!(params[:file])
    @file_path = uploader.file.path
    @model_name = params[:model_name]

    csv = ::CSV.read(@file_path)
    @headers = csv.first
    # Set variable of the index instead of mapping a large array or just store the row itself
    most_complete_row_index = csv[1..(csv.size - 1)].map.with_index {|x,i| x.reject(&:blank?); i}.max
    @most_complete_row = csv[most_complete_row_index]
    @model_name = params[:model_name]
    @type_options = ["Float", "Integer", "Date", "time", "String", "Text"]
  end

  def create
    type_mapping = [params[:header_mappings].values, params[:data_mappings].values].transpose.to_h
    current_user.model_mappings.create!(otype: params[:model_name], type_mapping: type_mapping)

    CsvImporter.import(
      user_id: current_user.id,
      model_name: params[:model_name],
      csv_file_path: params[:file_path],
      header_mapping: params[:header_mappings]
    )

    redirect_to model_types_models_path()
  end

end
