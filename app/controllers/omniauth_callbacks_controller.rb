class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def facebook
    user = User.find_for_oauth(request.env["omniauth.auth"], current_user)
    user_detail(user,"facebook")
  end

  def twitter
    user = User.find_for_oauth(request.env["omniauth.auth"], current_user)
    user_detail(user,"twitter")
  end

  def linkedin
    user = User.find_for_oauth(request.env["omniauth.auth"], current_user)
    user_detail(user,"linkedin")
  end

  def google_oauth2
    user = User.find_for_oauth(request.env["omniauth.auth"], current_user)
    user_detail(user,"google_oauth2")
  end

  def windowslive
    user = User.find_for_oauth(request.env["omniauth.auth"], current_user)
    user_detail(user,"windowslive")
  end

  private
  def user_detail user,type
  	# byebug
    if !user.nil?
      session[:access_token] = request.env["omniauth.auth"].credentials.token
      sign_in_and_redirect user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => type) if is_navigational_format?
    else
      flash[:alert] = "You have not a account on application. Please sign up or signin with existing account."
      session["devise.data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def sign_in_and_redirect(resource_or_scope, *args)
    # byebug
    options  = args.extract_options!
    scope    = Devise::Mapping.find_scope!(resource_or_scope)
    resource = args.last || resource_or_scope
    sign_in(scope, resource, options)
    if params[:action] == "twitter"
      redirect_to edit_user_registration_url
    else
      redirect_to after_sign_in_path_for(resource)
    end
  end
end