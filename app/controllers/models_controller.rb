class ModelsController < ApplicationController
  include ApplicationHelper

  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!
  before_action :find_model, only: [:show, :edit, :update, :destroy]

  def new
    @model = current_user.models.build
  end

  def index
    @model_names = Model.model_names
    @models = current_user.models.order(sort_column + " " + sort_direction)
  end

  def create
    @model = current_user.models.build(model_params)
    if @model.save
      # track_activity(@model)
      redirect_to model_path(@model)
    else
      render :new
    end
  end

  def show
    @models = current_user.models.where(otype: @model.otype).order(sort_column + " " + sort_direction)
    @model_data_keys = @models.model_data_keys
    @model_data_index = Hash[@model_data_keys.map.with_index.to_a]
  end

  def edit
  end

  def update
    new_model_data = @model.data

    new_model_data.merge!(model_params)
    @model.data = new_model_data

    if @model.valid?
      @model.update_columns(data: new_model_data)
      # track_activity(@model, :tecr)
    end

    respond_to do |format|
      format.html { redirect_to(models_path, :notice => 'Model was successfully updated.') }
      format.json { respond_with_bip(@model) }
    end
  end

  def destroy
  end


  private

  def model_params
    params.require(:model).permit(@model.data.keys)
  end

  def find_model
    @model = current_user.models.find(params[:id])
  end

  def sort_column
    Model.column_names.include?(params[:sort]) ? params[:sort] : "oid"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"
  end

end
