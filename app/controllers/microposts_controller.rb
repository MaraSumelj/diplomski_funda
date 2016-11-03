class MicropostsController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]
	before_action :correct_user, only: :destroy
	def create
		@micropost = Micropost.new
		@micropost = current_user.microposts.build(micropost_params)
		@micropost.page_id = current_page_id
		if @micropost.save
			flash[:success] = "Objava uspješno kreirana!"
			redirect_to root_url
		else
			@page = Page.find_by(id: current_page_id)
			redirect_to @page
		end
	end

	def destroy
		Micropost.find(params[:id]).destroy
		flash[:success] = "Objava izbrisana!"
		redirect_to root_url
	end

	private
	def micropost_params
		params.require(:micropost).permit(:content, :attachment)
	end

	def correct_user
		@micropost = current_user.microposts.find_by(id: params[:id])
		redirect_to root_url if @micropost.nil?
	end

end
