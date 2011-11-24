class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:login], params[:password])
    if user
      session[:user_id] = user.id
      flash[:notice] = I18n.t "devise.sessions.signed_in"
      redirect_to_target_or_default("/")
    else
      flash.now[:error] = I18n.t "devise.failure.invalid"
      render :action => 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = I18n.t "devise.sessions.signed_out"
    redirect_to "/"
  end
end
