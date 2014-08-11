class WorkflowsController < ApplicationController

  def new
    @workflow = Workflow.new
  end

  def create
    if @workflow = Workflow.create(workflow_params)
      redirect_to workflows_path
    else
      render :new
    end
  end

  def index
    @workflows = current_user.workflows
  end

  def edit
  end

  def update
  end


  private

  def workflow_params
    params.require(:workflow).permit(:user_id, :model_otype, :trigger_text, :condition_text, :action_text)
  end

end
