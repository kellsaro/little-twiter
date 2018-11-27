class SessionsController < ApplicationController
  def new
    @session = Session.new
  end

  def create
    @session = Session.new(session_params)

    user = User.find_by(email: @session.email.downcase)
    if user && user.authenticate(@session.password)
      log_in user
      redirect_to user 
    else
      @session.email = ''
      @session.password = ''      
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end  
  end

  def destroy
    log_out	  
    redirect_to root_path
  end

  private 
    def session_params
      params.require(:session).permit(:email, :password)
    end

end
