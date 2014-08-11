class WorkflowsController < ApplicationController

  before_action :find_workflow, only: [:edit, :update]

  def new
    @workflow = Workflow.new
  end

  def create
    if @workflow = current_user.workflows.create(workflow_params)
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
    if @workflow.update_attributes(workflow_params)
      redirect_to workflows_path
    else
      render :edit
    end
  end


  private

  def workflow_params
    params.require(:workflow).permit(:user_id, :model_otype, :trigger_text, :condition_text, :action_text)
  end

  def find_workflow
    @workflow = current_user.workflows.find(params[:id])
  end
end
