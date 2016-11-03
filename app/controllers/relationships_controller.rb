class RelationshipsController < ApplicationController
	before_action :logged_in_user
	def create
		page = Page.find(params[:followed_id])
		current_user.follow(page)
		redirect_to page
	end

	def destroy
		if current_user.admin?
			page = Relationship.find(params[:id]).followed
			user = Relationship.find(params[:id]).follower
			page.block(user)
			redirect_to page
		else
			page = Relationship.find(params[:id]).followed
			current_user.unfollow(page)
			redirect_to page
		end
	end
end
