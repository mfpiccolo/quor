class ModelsController < ApplicationController
  include ApplicationHelper

  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!
  before_action :find_model, only: [:show, :edit, :update, :search, :destroy]

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
    @model_otype = @model.otype
    @count = current_user.models.where(otype: @model_otype).count
    @models = current_user.models.where(otype: @model_otype).order(sort_column + " " + sort_direction).order(:updated_at).page params[:page]
    @data_keys = @models.data_keys(@model_otype)
    @model_data_index = Hash[@data_keys.map.with_index.to_a]
    @filters = current_user.filters.where(model_type: @model_otype)
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
      format.html { redirect_to(model_path(@model), :notice => 'Model was successfully updated.') }
      format.json { respond_with_bip(@model) }
    end
  end

  def destroy
  end

  def import
    CsvImporter.import(
      user_id: current_user.id,
      model_name: params[:model_name],
      csv_file: params[:file]
    )
    redirect_to models_path
  end

  def search
    @model_otype = @model.otype

    if params[:commit] == "Save Filter"
      Filter.create(user_id: current_user.id, model_type: @model.otype, query: params[:query], name: params[:name])
    end

    if Searcher::Operators.any? { |join| params[:query].include? join }
      model_search_scope = Searcher.call(current_user, @model_otype, params[:query])
      @count = model_search_scope.count
      @models = model_search_scope.order(sort_column + " " + sort_direction).order(:updated_at).page params[:page]
    else
      @count = current_user.models.where(otype: @model.otype).search_data(params[:query]).count(:all)
      @models = current_user.models.where(otype: @model.otype).search_data(params[:query]).order(:updated_at).page params[:page]
    end

    @filters = current_user.filters.where(model_type: @model_otype)
    @data_keys = @models.data_keys(@model_otype)
    @model_data_index = Hash[@data_keys.map.with_index.to_a]

    @term = params[:term]

    respond_to do |format|
      format.html { render :show }    # Initial page load.
      format.js   { render :show }  # Filtering & pagination.
    end
  end


  private

  def model_params
    params.require(:model).permit(Model.data_keys(@model.otype))
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
