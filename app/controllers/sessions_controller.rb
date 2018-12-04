class SessionsController < ApplicationController
  def new
    @session = Session.new
  end

  def create
    session = Session.new(session_params)

    @user = User.find_by(email: session.email.downcase)

    if @user && @user.authenticate(session.password)
      if @user.activated?
        log_in @user
	(session.remember_me == '1') ? remember(@user)
	                             : forget(@user)

	redirect_back_or @user
      else
	message = 'Account not activated.'
	message+= 'Check your email for the activation link.'
	flash[:warning] = message
	redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      new && render('new')
    end  
  end

  def destroy
    log_out if logged_in? 
    redirect_to root_path
  end

  private 
    def session_params
      params.require(:session).permit(:email, :password, :remember_me)
    end

end
