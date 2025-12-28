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
    @order_log = OrderLog.includes(order_details: [:partner, :orders])
                         .find(params[:id])

    # Переопределяем отношение с явной сортировкой
    @sorted_order_details = @order_log.order_details
                                      .includes(:partner)
                                      .order('partners.address ASC')
                                      .load
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order_log }
    end
  end

  def new
    @order_log = OrderLog.new
    order_detail = @order_log.order_details.build
    order_detail.orders.build
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order_log }
    end
  end

  def edit
  end

  def create
    @order_log = OrderLog.new(order_log_params)

    if @order_log.save
      redirect_to @order_log, notice: 'Заказ успешно создан.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /order_logs/1
  def update
    if @order_log.update(order_log_params)
      redirect_to @order_log, notice: 'Заказ успешно обновлён.'
    else
      render :edit, status: :unprocessable_entity
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
      :date,
      order_details_attributes: [
        :id,
        :partner_id,
        :count_places,
        :_destroy, orders_attributes: [:id, :number, :lists, { product_type_ids: []},
                              :_destroy, :data_list]

      ]
    ]

    params.require(:order_log).permit(permitted_fields)
  end
end




