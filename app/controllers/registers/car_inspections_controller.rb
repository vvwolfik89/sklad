module Registers
  class CarInspectionsController < ApplicationController

    load_and_authorize_resource
    # skip_load_resource only: [:create]
    #
    def index
      @car_inspections =  Registers::CarInspection.all #.page(params[:page])

      respond_to do |format|
        format.html
        format.json {render json: @car_inspections}
      end
    end

    def show
      @car_inspection = Registers::CarInspection.find(params[:id])
      # @activities = @car_inspection.activities.where(key: 'role.save_changes').order(:created_at)
      respond_to do |format|
        format.html
        format.json {render json: @car_inspection}
      end
    end

    def new
      @car_inspection =  Registers::CarInspection.new
      respond_to do |format|
        format.html
        format.json {render json: @car_inspection}
      end
    end

    def edit
    end

    def create
      @car_inspection =  Registers::CarInspection.new(car_inspection_params)
      respond_to do |format|
        if @car_inspection.save
          format.html {redirect_to @car_inspection, notice: 'Role was successfully created.'}
          format.json {render json: @car_inspection, status: :created, location: @car_inspection}
        else
          format.html {render action: "new"}
          format.json {render json: @car_inspection.errors, status: :unprocessable_entity}
        end
      end
    end

    def update
      @car_inspection = Registers::CarInspection.find(params[:id])
      respond_to do |format|
        if @car_inspection.update(car_inspection_params)
          format.html {redirect_to @car_inspection, notice: ' CarInspection was successfully updated.'}
          format.json {head :no_content}
        else
          format.html {render action: :edit}
          format.json {render json: @car_inspection.errors, status: :unprocessable_entity}
        end
      end
    end

    def destroy
      respond_to do |format|
        if @car_inspection.destroy
          format.html {redirect_to registers_car_inspection_url}
          format.json {head :no_content}
        else
          flash[:error] = @car_inspection.errors[:base].join('. ')
          format.html {redirect_to roles_url}
          format.json {render json: @car_inspection.errors, status: :unprocessable_entity}
        end
      end
    end

    protected

    def car_inspection_params
      permitted_fields = [:name, :department_id, :car_id, :inspect_lighting, :steering_check, :tire_condition, :body_condition, :checking_brake, :checking_windshield, :checking_termoking, :checking_termotrans, :checking_unitess, :notes
      ]
      params.require(:registers_car_inspection).permit(permitted_fields).tap do |attrs|
        attrs[:user] = current_user
      end

      # params.require(:car_inspection).
      #   permit(permitted_fields).tap do |attrs|
      #   attrs[:user] = current_user
      # end
    end
  end
end
