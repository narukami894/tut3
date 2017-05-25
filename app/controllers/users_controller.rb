class UsersController < ApplicationController
  before_action :set_user, except: %i[new create index destroy]

  def new; end

  def create; end

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
