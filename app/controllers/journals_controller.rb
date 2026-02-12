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
    respond_to do |format|
      if @journal.update(journal_params)
        format.html { redirect_to @journal, notice: 'Permission was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @journal.errors, status: :unprocessable_entity }
      end
    end
  end

  def version_history
    @journal = Journal.find(params[:id])
        # Собираем версии с информацией о пользователе
    versions = @journal.related_versions.map do |version|
      {
        event: version.event,
        changed_at: version.created_at.strftime("%d.%m.%Y %H:%M"),
        changed_by: version.whodunnit ? User.find_by(id: version.whodunnit)&.full_name : "Неизвестно",
        changes: version.changeset
      }
    end

    render json: versions
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
