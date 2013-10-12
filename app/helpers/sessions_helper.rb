module SessionsHelper

	 ### sign in the user
	  # create a new :remember_token and store it in a cookie
	  # set the session to store the signed-in user
	def sign_in (user)
		remember_token = User.new_remember_token
		
		cookies.permanent[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.encrypt(remember_token))
		
		self.current_user = user
	end
	 
	 ### sign out the user
	  # all you really need to do is delete the cookie!
	def sign_out
		@current_user = nil
		cookies.delete :remember_token
	end
	
	 ### methods to verify signed in
	def signed_in?
		!current_user.nil?
	end
	
	 ### methods to define the current_user var
	def current_user= (user)
		@current_user = user
	end
	
	def current_user
		remember_token = User.encrypt(cookies[:remember_token])
		@current_user ||= User.where(remember_token: remember_token).first
	end
	
	def current_user? (user)
		current_user == user
	end
	
	 ### friendly redirect methods
	def store_path
		session[:return_to] = request.url if request.get?
	end
	
	def redirect_back_or (default)
		redirect_to session[:return_to] || default
		session.delete :return_to
	end
end
