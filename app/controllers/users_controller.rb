class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:otp_page, :verify_otp]
  before_action :set_user, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token, only: %i[ update_2fa ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def otp_page
    @user = params[:user]
  end

  def verify_otp
    @user = User.find(params[:user_id])
    if @user.present? 
      if validate_otp(params[:otp_text].to_i)
        sign_in(@user)
        flash[:notice] = "Login successfully"
        redirect_to user_path(@user)
      else
        flash[:alert] = "Incorrect otp."
        redirect_to otp_page_path
      end
    else
      redirect_to root
    end
  end

  def update_2fa
    @user = User.find(params[:user])
    if @user
      @user.update_columns(two_factor: !@user.two_factor)
      respond_to do |format|
        format.js { render layout: false, msg: "Two FA settings updated", code: 200 }
      end
    else
      respond_to do |format|
        format.js { render layout: false, msg: "User not found", code: 400 }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def validate_otp(otp_text)
      if @user.otp == otp_text
        return true
      else
        return false
      end
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name)
    end
end
