class StaticPagesController < ApplicationController
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  def contact; end

  def send_email
    if params[:email] =~ VALID_EMAIL_REGEX && verify_recaptcha
      ContactMailer.contact(params).deliver_now
      flash[:info] = 'メールが送信されました'
      redirect_to root_path
    else
      flash[:warning] = 'Emailが不正、もしくはチェックがされていません'
      redirect_to contact_path
    end
  end

  def help; end
end
