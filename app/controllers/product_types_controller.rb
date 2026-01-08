class ProductTypesController < ApplicationController
    load_and_authorize_resource

    def index
      @product_types = ProductType.all #.order(:name).page(params[:page])

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @product_types }
      end
    end

    def show
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @product_type }
      end
    end

    def new
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @product_type }
      end
    end

    def edit
    end

    def create
      @product_type = ProductType.new(product_type_params)

      respond_to do |format|
        if @product_type.save
          format.html { redirect_to @product_type, notice: 'Permission was successfully created.' }
          format.json { render json: @product_type, status: :created, location: @product_type }
        else
          format.html { render action: "new" }
          format.json { render json: @product_type.errors, status: :unprocessable_entity }
        end
      end
    end

    def update

      respond_to do |format|
        if @product_type.update(product_type_params)
          format.html { redirect_to @product_type, notice: 'Permission was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @product_type.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @product_type.destroy
      respond_to do |format|
        format.html { redirect_to product_types_url }
        format.json { head :no_content }
      end
    end

    protected

    def product_type_params
      permitted_fields = [
        :name
      ]

      params.require(:product_type).permit(permitted_fields)
    end
  end

