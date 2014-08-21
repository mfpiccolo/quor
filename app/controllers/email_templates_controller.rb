class EmailTemplatesController < ApplicationController

  def new
    @email_template = EmailTemplate.new
  end

  def create
    if @email_template = current_user.email_templates.create(email_template_params)
      redirect_to root_url
    else
      redirect_to root_url
    end
  end

  def show
    @email_template = current_user.email_templates.find(params[:id])
    render :layout => "email"
  end

  def index
    @email_templates = current_user.email_templates
  end


  private

  def email_template_params
    params.require(:email_template).permit(:logo_file, :banner_file, :subject,
                                                  :header1_large, :header1_small,
                                                  :banner_description, :header2_large,
                                                  :header2_small, :body, :call_to_action,
                                                  :facebook_url, :twitter_url, :google_url)
  end
end
