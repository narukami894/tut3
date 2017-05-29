class UsersController < ApplicationController
  before_action :logged_in_user,            only:   %i[edit update index destroy]
  before_action :set_user,                  except: %i[new create index]
  before_action :correct_user,              only:   %i[edit update]
  before_action :redirect_unless_activated, only:   %i[edit update destroy]
  before_action :admin_user,                only:   :destroy

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = 'Please check your email to activate your account.'
      redirect_to root_url
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'success'
      redirect_to @user
    else
      render :edit
    end
  end

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def destroy
    @user.delete
    flash[:success] = 'User deleted'
    redirect_to users_url
  end

  def following; end

  def followers; end

  private

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def set_user
    @user = User.find(params[:id])
  end

  def correct_user
    redirect_to root_url unless current_user?(@user)
  end

  def redirect_unless_activated
    redirect_to root_url and return unless @user.activated?
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
