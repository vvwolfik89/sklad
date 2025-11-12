class OrderLogsController < ApplicationController
  load_and_authorize_resource

  def index
    @order_logs = OrderLog.all #.order(:name).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @order_logs }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order_log }
    end
  end

  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order_log }
    end
  end

  def edit
  end

  def create
    @order_log = OrderLog.new(order_log_params)

    respond_to do |format|
      if @order_log.save
        format.html { redirect_to @order_log, notice: 'Permission was successfully created.' }
        format.json { render json: @order_log, status: :created, location: @order_log }
      else
        format.html { render action: "new" }
        format.json { render json: @order_log.errors, status: :unprocessable_entity }
      end
    end
  end

  def update

    respond_to do |format|
      if @order_log.update(order_log_params)
        format.html { redirect_to @order_log, notice: 'Permission was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order_log.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order_log.destroy
    respond_to do |format|
      format.html { redirect_to order_logs_url }
      format.json { head :no_content }
    end
  end

  protected

  def order_log_params
    permitted_fields = [
      :name
    ]

    params.require(:order_log).permit(permitted_fields)
  end
end




