class CarsController < ApplicationController
  load_and_authorize_resource

  def index
    @cars = Car.all #.order(:name).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cars }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @car }
    end
  end

  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @car }
    end
  end

  def edit
  end

  def create
    @car = Car.new(car_params)

    respond_to do |format|
      if @car.save
        format.html { redirect_to @car, notice: 'Permission was successfully created.' }
        format.json { render json: @car, status: :created, location: @car }
      else
        format.html { render action: "new" }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  def update

    respond_to do |format|
      if @car.update(car_params)
        format.html { redirect_to @car, notice: 'Permission was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @car.destroy
    respond_to do |format|
      format.html { redirect_to cars_url }
      format.json { head :no_content }
    end
  end

  protected

  def car_params
    permitted_fields = [
      :registration_number, :model, :brand, :date_registration, :date_of_manufacture, :fuel_type, :vin, :vin_equipment, :date_to, :date_safety]

    params.require(:car).permit(permitted_fields)
  end
end
