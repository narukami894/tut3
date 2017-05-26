class UsersController < ApplicationController
  before_action :set_user, except: %i[new create index destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:info] = 'fugafuga'
      log_in @user
      redirect_to @user
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update; end

  def index; end

  def destroy; end

  def following; end

  def followers; end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
