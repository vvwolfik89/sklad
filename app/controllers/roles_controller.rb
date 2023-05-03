class RolesController < ApplicationController

  load_and_authorize_resource
  skip_load_resource only: [:create]
  #
  def index
    @roles = Role.all#.page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @roles }
    end
  end

  def show
    @role = Role.find(params[:id])
    # @activities = @role.activities.where(key: 'role.save_changes').order(:created_at)
    respond_to do |format|
      format.html
      format.json { render json: @role }
    end
  end

  def new
    @role = Role.new
    respond_to do |format|
      format.html
      format.json { render json: @role }
    end
  end

  def edit
  end

  def create
    @role = Role.new(role_params)

    respond_to do |format|

      # save_changes_service = SaveChangesService.new(current_agent, @role)
      if @role.save
        format.html { redirect_to @role, notice: 'Role was successfully created.' }
        format.json { render json: @role, status: :created, location: @role }
      else
        format.html { render action: "new" }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @role = Role.find(params[:id])
    respond_to do |format|
      if @role.update(resource_params)
        format.html { redirect_to @role, notice: 'Role was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @role.destroy
        format.html { redirect_to roles_url }
        format.json { head :no_content }
      else
        flash[:error] = @role.errors[:base].join('. ')
        format.html { redirect_to roles_url }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  protected

  def role_params
    permitted_fields = [:title, :description,
                        { permission_ids: [] } ,
                        :role_type
    ]
    params.require(:role).permit(permitted_fields)
  end
end
