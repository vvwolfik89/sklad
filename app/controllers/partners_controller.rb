class PartnersController < ApplicationController
  load_and_authorize_resource

  def index
    @partners = Partner.all #.order(:name).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @partners }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @partner }
    end
  end

  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @partner }
    end
  end

  def edit
  end

  def create
    @partner = Partner.new(partner_params)

    respond_to do |format|
      if @partner.save
        format.html { redirect_to @partner, notice: 'Permission was successfully created.' }
        format.json { render json: @partner, status: :created, location: @partner }
      else
        format.html { render action: "new" }
        format.json { render json: @partner.errors, status: :unprocessable_entity }
      end
    end
  end

  def update

    respond_to do |format|
      if @partner.update(partner_params)
        format.html { redirect_to @partner, notice: 'Permission was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @partner.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @partner.destroy
    respond_to do |format|
      format.html { redirect_to partners_url }
      format.json { head :no_content }
    end
  end

  def import
    file = params[:file]

    if file.nil?
      redirect_to partners_path, alert: "Выберите файл для импорта"
      return
    end

    # Используем модельный метод
    result = Partner.import_from_excel(file)

    redirect_to partners_path, notice: "Импортировано #{result[:count]} записей"
  end

  protected

  def partner_params
    permitted_fields = [
      :name, :description, :email, :phone_number, :address, :legal_address
    ]

    params.require(:partner).permit(permitted_fields)
  end
end
