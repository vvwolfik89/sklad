class OrderLogsController < ApplicationController
  load_and_authorize_resource

  def index
    filters = permitted_index_params.to_h

    @order_logs = OrderLog#.includes(order_details: [:partner, orders: [:product_types]])
                    .by_date(filters[:date])
                    .with_all_partners(filters[:partner_ids])
                    .with_product_types(filters[:product_type_ids])
                    .distinct

    # Фильтрация
    #   @order_logs = @order_logs.by_date(filters[:date]).with_partners(filters[:partner_ids])


    # Сортировка
    # case filters[:sort]
    # when 'partner_name_asc'
    #   @order_logs = @order_logs.order('partners.name ASC')
    #   # ... другие случаи
    # else
    #   @order_logs = @order_logs.order('order_logs.id ASC')
    # end

    # Пагинация (ВАЖНО: должен быть Relation!)
    page = [filters[:page].to_i, 1].max
    @order_logs = @order_logs.paginate(page: page, per_page: 5)
    #
    # puts "@order_logs class: #{@order_logs.class}"
    # puts "@order_logs class: #{@order_logs.present?}"
    # puts "@order_logs is a Relation? #{@order_logs.is_a?(ActiveRecord::Relation)}"

    respond_to do |format|
      format.html
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

  def version_history
    @order_log = OrderLog.find(params[:id])

    # Собираем версии с информацией о пользователе
    versions = @order_log.related_versions.map do |version|
      {
        event: version.event,
        changed_at: version.created_at.strftime("%d.%m.%Y %H:%M"),
        changed_by: version.whodunnit ? User.find_by(id: version.whodunnit)&.full_name : "Неизвестно",
        changes: version.changeset
      }
    end

    render json: versions
  end

  protected
  # Безопасные параметры для index-действия
  def permitted_index_params
    params.permit(:date, :sort, :page, partner_ids: [], product_type_ids: [])
  end

  def order_log_params
    permitted_fields = [
      :date,
      :page,
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




