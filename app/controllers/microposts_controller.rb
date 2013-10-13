class MicropostsController < ApplicationController
	before_filter :signed_in_user
	before_filter :correct_user, only: :destroy
	
	def create
		@micropost = current_user.microposts.build(params[:micropost])
		if @micropost.save
			flash[:success] = "Created Micropost"
			redirect_to root_url
		else
			render 'static_pages/home'
		end
	end
	
	def destroy
		@micropost.destroy
		flash[:success] = 'deleted post'
		redirect_to root_url
	end
	
	private
	
		def correct_user
			@micropost = current_user.microposts.where(id: params[:id]).first
			if @micropost.nil?
				flash[:error] = 'permissions error'
				redirect_to root_url
			end
		end
end
