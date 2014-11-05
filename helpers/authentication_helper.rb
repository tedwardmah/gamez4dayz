module AuthenticationHelper
  def current_user
    if session[:current_user]
      @current_user ||= User.find(session[:current_user])
    else
      nil
    end
  end

  def authenticate!
    redirect '/' unless current_user
  end

  #use to block access to a route unless the current user matches the owner of that content
  def page_belongs_to_current_user?(id)
    redirect '/' unless current_user && current_user.id == id.to_i
    return current_user.id == id.to_i
  end
end