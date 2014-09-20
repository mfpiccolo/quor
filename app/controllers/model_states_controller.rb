class ModelStatesController < ApplicationController

  def transition
    if model = Model.find(params["model_id"])
      # TODO Check that transition can happen or handle with state machine
      if model.update_attributes(model_state_id: params["transition_to_id"])
        flash[:notice] = "Model Updated"
      else
        flash[:error] = "Model Update Failed"
      end
    else
      flash[:error] = "Model Update Failed"
    end
    redirect_to :back
  end

  def new
    @model_state = current_user.model_states.new(otype: params[:model_name])
  end

  def create
    if current_user.model_states.create!(model_state_params)
      redirect_to models_path(otype: model_state_params[:otype])
    else
      render :new
    end
  end


  private

  def model_state_params
    params.require(:model_state).permit(:name, :otype, :transition_to, :transition_from)
  end

end
