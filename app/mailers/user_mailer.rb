class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: @user.email, subject: t("mail.acc_activation")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("account.reset_pass_subject")
  end
end
