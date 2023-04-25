class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(resource_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { head :no_content }
      else
        format.html { render action: :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end


  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(resource_params)
        format.html { redirect_to @user, notice: 'Department was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private

  def resource_params
    permited_fields = [ :email, :role, :avatar, :bday, :first_name, :last_name, :patronymic, :password, :password_confirmation, {department_ids: []}  ]
    params.require(:user).permit(permited_fields)
  end
end
