class Journals::EntriesController < ApplicationController
  load_and_authorize_resource
  before_action :set_journal

  def new
    @entry = @journal.entries.new
    # Загружаем поля журнала и создаём пустые FieldValue для формы
    @journal.fields.each do |field|
      @entry.field_values.build(field: field)
    end
  end

  def create
    @entry = @journal.entries.new(entry_params)
    @entry.journal = @journal
    @entry.creator = current_user

    if @entry.save
      redirect_to [@journal, @entry], notice: t('notices.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @entry = Entry.find(params[:id])
    # # Очищаем nil-элементы
    # @journal.fields.reject(&:nil?)
    # # Добавляем хотя бы один пустой объект для формы, если нужно
    # @journal.fields.build unless @journal.fields.any?
  end

  def update
    if @entry.update(entry_params)
      redirect_to :journal_entry, notice: 'Запись успешно обновлёна.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @entry = @journal.entries.find(params[:id])
  end

  def destroy
    @entry.destroy
    respond_to do |format|
      format.html { redirect_to journal_entry_url }
      format.json { head :no_content }
    end
  end

  private

  def set_journal
    @journal = Journal.find(params[:journal_id])
  end

  def entry_params
    params.require(:entry).permit(
      :journal_id,
      :date,
      field_values_attributes: [:field_id, :value, :related_record_id]
    )
  end
end