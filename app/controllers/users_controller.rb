class UsersController < ApplicationController

  def edit
  end

  def update
    if current_user.update_attributes(user_params)
      redirect_to models_path
    else
      render :edit
    end
  end


  private

  def user_params
    params.require(:user).permit(:ltv_1, :ltv_2)
  end

end
