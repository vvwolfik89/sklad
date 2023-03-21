class DepartmentsController < ApplicationController
  def index
    @departments = Department.all
  end

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(resource_params)

    respond_to do |format|
      if @department.save
        format.html { redirect_to @department, notice: 'Dot was successfully created.' }
        format.json { head :no_content }
      else
        format.html { render action: :edit }
        format.json { render json: @dot.errors, status: :unprocessable_entity }
      end
    end


  end

  def show
    @department = Department.find(params[:id])
  end

  def edit
    @department = Department.find(params[:id])
  end

  def update
    @department = Department.find(params[:id])
    respond_to do |format|
      if @department.update(resource_params)
        format.html { redirect_to @department, notice: 'Department was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: :edit }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @department = Department.find(params[:id])
    @department.destroy
    respond_to do |format|
      format.html { redirect_to departments_url }
      format.json { head :no_content }
    end
  end

  private

  def resource_params
    permited_fields = [ :title, :body ]
    params.require(:department).permit(permited_fields)
  end
end
