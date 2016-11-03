class UsersController < ApplicationController

  before_action :logged_in_user, only: [:edit, :update, :show, :destroy, :index, :following]
  before_action :correct_user, only: [:edit, :update]

  def index
  	@users = User.order(:name).paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  	@micropost = current_user.microposts.build
	@feed_items = @user.feed_for_specific_user(current_user_id).paginate(page: params[:page])
  end

  def create
	@user = User.new(user_params)
	if @user.save
		flash[:success] = "Dobrodošli!"
		log_in @user
		remember @user
		redirect_to @user
	else
		render 'new'
	end
  end

  def destroy
	User.find(params[:id]).destroy
	flash[:success] = "Izbrisan korisnik!"
	redirect_to users_url
  end

  def edit
	@user = User.find(params[:id])
  end

  def update
	@user = User.find(params[:id])
	if @user.update_attributes(user_params)
		flash[:success] = "Ažurirano!"
		redirect_to @user
	else
		render 'edit'
	end
  end

  def following
	@user= User.find(params[:id])
	@pages = @user.following.paginate(page: params[:page])
	render 'show_following'
end

  private
	def user_params
		params.require(:user).permit(:name, :email, :password,:password_confirmation)
	end

end
