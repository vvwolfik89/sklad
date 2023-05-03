class PermissionsController < ApplicationController
  load_and_authorize_resource

  def index
    @permissions = Permission.order(:name).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @permissions }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @permission }
    end
  end

  def new
    @permission = Permission.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @permission }
    end
  end

  def edit
  end

  def create
    @permission = Permission.new(permission_params)

    respond_to do |format|
      if @permission.save
        format.html { redirect_to @permission, notice: 'Permission was successfully created.' }
        format.json { render json: @permission, status: :created, location: @permission }
      else
        format.html { render action: "new" }
        format.json { render json: @permission.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @permission.update_attributes(permission_params)
        format.html { redirect_to @permission, notice: 'Permission was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @permission.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @permission.destroy

    respond_to do |format|
      format.html { redirect_to permissions_url }
      format.json { head :no_content }
    end
  end

  protected

  def permission_params
    permitted_fields = [:name, :action_name, :class_name, :is_active, :description]

    params.require(:permission).permit(permitted_fields)
  end
end
