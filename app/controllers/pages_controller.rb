class PagesController < ApplicationController
	before_action :admin_user, only: [:edit, :destroy, :new, :create]
	before_action :logged_in_user, only: [:show, :index, :followers]
	
  def index
  	@pages = Page.order(:name).paginate(page: params[:page])
  end

  def new
  	@page=Page.new
  end

  def create
	@page = Page.new(page_params)
	if @page.save
		flash[:success] = "Uspješno ste kreirali novu stranicu!"
		redirect_to @page
	else
		render 'new'
	end
  end

  def show
  	@page = Page.find(params[:id])
  	current_page @page
  	@microposts = @page.microposts.paginate(page: params[:page])
  	@micropost = current_user.microposts.build if logged_in?
  end

  def edit
  	@page = Page.find(params[:id])
  end

  def update
	@page = Page.find(params[:id])
	if @page.update_attributes(page_params)
		flash[:success] = "Stranica ažurirana!"
		redirect_to @page
	else
		render 'edit'
	end
  end

  def destroy
	Page.find(params[:id]).destroy
	flash[:success] = "Stranica izbrisana!"
	redirect_to pages_url
  end

  def followers
	@title = "Followers"
	@page = Page.find(params[:id])
	@users = @page.followers.paginate(page: params[:page])
	render 'show_followers'
  end

  private
	def page_params
		params.require(:page).permit(:name, :description)
	end

	
end
