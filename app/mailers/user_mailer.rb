class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    # Create an instance of the user and set it to the "user" argument
    @user = user

    # Send an email to the user with the subject "Password Reset." The email's body template can be found in ../views/user_mailer-password_reset_text.erb
    mail to: user.email, subject: "Password Reset"
  end
end
