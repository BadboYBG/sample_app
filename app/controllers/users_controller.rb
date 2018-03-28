class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :find_user, except: %i(new index create)

  def index
    @users = User.list_user.page(params[:page]).per Settings.page
  end

  def new
    @user = User.new
  end

  def show
    if @user.nil?
      flash[:danger] = t "users.index.not_found_user"
      redirect_to users_url
    end
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t ".success"
      redirect_to @user
    else
      render :new
    end

  end

  def edit

  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "users.edit.success"
      redirect_to @user
    else
      render :edit
    end

  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.index.user_delete"
    else
      flash[:danger] = t "error.delete"
    end

    redirect_to users_url

  end

  private

    def user_params
      params.require(:user).permit :name, :email, :password, :password_confirmation
    end

    def logged_in_user
      unless logged_in?
        flash[:danger] = t "users.edit.please"
        redirect_to login_url
      end
    end

    def correct_user
      find_user
      redirect_to root_url unless current_user? @user
    end

    def admin_user
      redirect_to root_url unless current_user.admin?
    end

    def find_user
      @user = User.find_by id: params[:id]
      if @user.nil?
        flash[:danger] = t "users.index.not_found_user"
        redirect_to users_url
      end
    end

end
