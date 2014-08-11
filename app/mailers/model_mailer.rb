class ModelMailer < ActionMailer::Base
  default from: "from@example.com"

  def dynamic_email(email, template_details=nil)
    @email_template_detail = EmailTemplateDetail.find(3)
    mail(to: email, subject: 'Registration Confirmation')
  end
end
