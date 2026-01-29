class JournalsController < ApplicationController
  load_and_authorize_resource
  def index
    @journals = Journal.all
  end

  def show
    @journal = Journal.includes(:fields, :entries).find(params[:id])
    @entries = @journal.entries.order(date: :desc)
  end

  def edit
    @journal = Journal.find(params[:id])
    # Очищаем nil-элементы
    @journal.fields.reject(&:nil?)
    # Добавляем хотя бы один пустой объект для формы, если нужно
    @journal.fields.build unless @journal.fields.any?
  end

  def new
    @journal = Journal.new
  end

  def create
    @journal = Journal.new(journal_params)
    if @journal.save
      redirect_to @journal, notice: 'Журнал создан'
    else
      render :new
    end
  end

  def update
    if @journal.update(journal_params)
      redirect_to @journal, notice: 'Журнал успешно обновлён.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def journal_params
    params.require(:journal).permit(
      :title,
      :description,
      fields_attributes: [
        :id,
        :name,
        :field_type,
        :required,
        :placeholder,
        :related_model,
        :display_field,
        :options,
        :_destroy  # для удаления
      ]
    )
  end
end
