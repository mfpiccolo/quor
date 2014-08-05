class ModelsController < ApplicationController
  include ApplicationHelper

  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!
  before_action :find_model, only: [:show, :edit, :update, :destroy]

  def new
    @model = current_user.models.build
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

  def model_types
    @model_names = current_user.models.model_names
    @models = current_user.models.order(sort_column + " " + sort_direction)
  end

  def index
    @model_otype = params[:otype]
    @count = current_user.models.where(otype: @model_otype).count
    @models = current_user.models.where(otype: @model_otype).order(sort_column + " " + sort_direction).order(:updated_at).page params[:page]
    @data_keys = @models.data_keys(otype: @model_otype)
    @model_data_index = Hash[@data_keys.map.with_index.to_a]
    @filters = current_user.filters.where(model_type: @model_otype)
    @current_model_names = current_user.models.model_names
    @versions = Version.joins(:model).merge(Model.where(otype: @model_otype, user: current_user)).order('created_at DESC')
    @states = current_user.model_states.where("otype = '#{@model_otype}' or otype = 'all' AND name != 'initial'")
  end

  def show
    @current_model_names = current_user.models.model_names
    @versions = @model.versions
  end

  def edit
  end

  def update
    new_model_data = @model.data
    new_model_data.merge!(model_params)

    @model.update_attributes(data: new_model_data)

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
    redirect_to model_types_models_path
  end

  def search
    @model_otype = params[:otype]
    @current_model_names = current_user.models.model_names

    if params[:commit] == "Save Filter"
      Filter.create(user_id: current_user.id, model_type: @model_otype, query: params[:query], name: params[:name])
    end

    if (Searcher::Operators << ":").any? { |join| params[:query].include? join }
      searcher = Searcher.call(current_user, @model_otype, params[:query])
      model_search_scope = searcher.final_scope
      @count = model_search_scope.count
      @models = model_search_scope.order(sort_column + " " + sort_direction).order(:updated_at).page params[:page]
    else
      # TODO fix search_data pg method and pass scope to @versions
      model_search_scope = current_user.models.where(otype: @model_otype).search_data(params[:query])
      @count =  model_search_scope.count(:all)
      @models = model_search_scope.order(:updated_at).page params[:page]
    end

    # TODO use searcher scope to return only versions that are associated
    # to models in the search scope
    @versions = Version.joins(:model).merge(searcher.final_scope)

    @filters = current_user.filters.where(model_type: @model_otype)
    @data_keys = @models.data_keys(otype: @model_otype)
    @model_data_index = Hash[@data_keys.map.with_index.to_a]

    @term = params[:term]

    respond_to do |format|
      format.html { render :index }    # Initial page load.
      format.js   { render :index }  # Filtering & pagination.
    end
  end


  private

  def model_params
    params.require(:model).permit(current_user.models.data_keys(otype: @model.otype))
  end

  def find_model
    @model = current_user.models.find(params[:id])
  end

  def sort_column
    current_user.models.column_names.include?(params[:sort]) ? params[:sort] : "oid"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"
  end

end
