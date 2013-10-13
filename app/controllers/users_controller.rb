class UsersController < ApplicationController
	before_filter :signed_in_user, only: [:edit, :update, :destroy]
	before_filter :correct_user, only: [:edit, :update]
	before_filter :skip_password_attribute, only: :update
	
	def index
		@users = User.paginate(page: params[:page], per_page: 3)
	end

	def show
		@user = User.find(params[:id])
		@microposts = @user.microposts.paginate(page: params[:page], per_page: 2)
	end
	
	 ### creating new users
	def new
		@user = User.new
	end
	
	def create
		@user = User.new(params[:user])
		if @user.save
			sign_in @user
			redirect_to @user, :notice => "successfully signed up!"
		else
			render 'new'
		end
	end
	
	 ### updating user details
	def edit
		# @user is defined in correct_user which is called in before_filter
	end
	
	def update
		 # @user is defined in correct_user which is called in before_filter
		if @user.update_attributes(params[:user])
			flash[:notice] = 'successfully edited #{@user.email}'
			redirect_to edit_user_path
		else
			render 'edit'
		end
	end
		### update does not work as it should.
			# each attr should be updated individually
			# maybe after pwd confirmation?
			# either way it currently updates the pwd which is BAD
	
	 ### destroy users
	def destroy
		User.find(params[:id]).destroy
		flash[:notice] = 'user destroyed'
		redirect_to users_url
	end
	
	private
		
		def correct_user
			@user = User.find(params[:id])
			redirect_to edit_user_path(current_user) unless current_user?(@user)
		end
		
		def skip_password_attribute
			if params[:password].blank? && params[:password_validation].blank?
				params.except!(:password, :password_validation)
			end
		end
		
		def admin_user
			redirect_to root_url unless ( !current_user.nil? && current_user.admin? )
		end
end
