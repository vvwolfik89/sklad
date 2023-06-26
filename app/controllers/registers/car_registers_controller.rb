module Registers
  class CarRegistersController < ApplicationController

    # load_and_authorize_resource
    # skip_load_resource only: [:create]
    #
    def index
      @car_registers =  Registers::CarRegister.all #.page(params[:page])

      respond_to do |format|
        format.html
        format.json {render json: @car_registers}
      end
    end

    def show
      @car_register = Registers::CarRegister.find(params[:id])
      # @activities = @car_register.activities.where(key: 'role.save_changes').order(:created_at)
      respond_to do |format|
        format.html
        format.json {render json: @car_register}
      end
    end

    def new
      @car_register =  Registers::CarRegister.new
      respond_to do |format|
        format.html
        format.json {render json: @car_register}
      end
    end

    def edit
    end

    def create
      @car_register =  Registers::CarRegister.new(role_params)

      respond_to do |format|

        # save_changes_service = SaveChangesService.new(current_agent, @car_register)
        if @car_register.save
          format.html {redirect_to @car_register, notice: 'Role was successfully created.'}
          format.json {render json: @car_register, status: :created, location: @car_register}
        else
          format.html {render action: "new"}
          format.json {render json: @car_register.errors, status: :unprocessable_entity}
        end
      end
    end

    def update
      @car_register = Role.find(params[:id])
      respond_to do |format|
        if @car_register.update(role_params)
          format.html {redirect_to @car_register, notice: ' CarRegister was successfully updated.'}
          format.json {head :no_content}
        else
          format.html {render action: :edit}
          format.json {render json: @car_register.errors, status: :unprocessable_entity}
        end
      end
    end

    def destroy
      respond_to do |format|
        if @car_register.destroy
          format.html {redirect_to roles_url}
          format.json {head :no_content}
        else
          flash[:error] = @car_register.errors[:base].join('. ')
          format.html {redirect_to roles_url}
          format.json {render json: @car_register.errors, status: :unprocessable_entity}
        end
      end
    end

    protected

    def role_params
      permitted_fields = [:title, :description,
                          {permission_ids: []},
                          :role_type
      ]
      params.require(:role).permit(permitted_fields)
    end
  end
end
