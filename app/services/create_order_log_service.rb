class  CreateOrderLogService
  def initialize(params)
    @params = params
  end

  def call
    ActiveRecord::Base.transaction do
      company = OrderLog.create!(
        name: @params[:name],
        departments_attributes: build_departments
      )
      company
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Ошибка при создании компании: #{e.message}")
    nil
  end

  private

  def build_departments
    return [] unless @params[:departments]

    @params[:departments].map do |dept|
      {
        name: dept[:name],
        employees_attributes: build_employees(dept[:employees])
      }
    end
  end

  def build_employees(employees)
    return [] unless employees

    employees.map do |emp|
      {
        name: emp[:name],
        position: emp[:position]
      }
    end
  end



end