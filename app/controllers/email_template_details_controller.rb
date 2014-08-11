class EmailTemplateDetailsController < ApplicationController

  def new
    @email_template_detail = EmailTemplateDetail.new
  end

  def create
    if @email_template_detail = EmailTemplateDetail.create(email_template__detail_params)
      redirect_to root_url
    else
      redirect_to root_url
    end
  end


  private

  def email_template__detail_params
    params.require(:email_template_detail).permit(:logo_file, :banner_file, :subject,
                                                  :header1_large, :header1_small,
                                                  :banner_description, :header2_large,
                                                  :header2_small, :body, :call_to_action,
                                                  :facebook_url, :twitter_url, :google_url)
  end
end
