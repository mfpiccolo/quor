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

end
