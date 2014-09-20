class ModelMappingsController < ApplicationController

  def index
    @mappings = current_user.model_mappings
  end

  def show
    @mapping = current_user.model_mappings.find(params[:id])
    @type_mappings = @mapping.type_mapping
  end
end
