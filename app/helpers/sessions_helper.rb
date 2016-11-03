module SessionsHelper
	# Logs in the given user.
	def log_in(user)
		session[:user_id] = user.id
	end

	#Current page 
	def current_page(page)
		session[:page_id]= page.id
	end

	# Remembers a user in a persistent session.
	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	# Forgets a persistent session.
	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

	# Returns the user corresponding to the remember token cookie.
	def current_user
		if (user_id = session[:user_id])
			@current_user ||= User.find_by(id: user_id)
		elsif (user_id = cookies.signed[:user_id])
			user = User.find_by(id: user_id)
			if user && user.authenticated?(cookies[:remember_token])
				log_in user
				@current_user = user
			end
		end
	end

	def current_user_id
		return session[:user_id]
	end
	# Returns the page corresponding to the current position.
	def current_page_id
		return session[:page_id]
	end

	# Returns true if the given user is the current user.
	def current_user?(user)
		user == current_user
	end
	# Returns true if the user is logged in, false otherwise.
	def logged_in?
		!current_user.nil?
	end

	#Returns true if current user is admin.
	def admin?
		if (current_user == nil)
			return false
		end
		if (current_user.admin == true) 
			return true
		else
			return false
		end
	end

	# Logs out the current user.
	def log_out
		forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end

	#Inspects if user is loged in
	def logged_in_user
		unless logged_in?
			flash[:danger] = "Prijavite se da biste vidjeli sadržaj."
			redirect_to login_url
		end
	end

	# Confirms the correct user.
	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_url) unless @user == current_user
	end

	# Confirms an admin user.
	def admin_user
		redirect_to(root_url) unless admin?
	end
end
