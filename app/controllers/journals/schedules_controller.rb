module Journals
  class SchedulesController < ApplicationController
    before_action :set_journal

    def edit
      @schedule = @journal.schedule || @journal.build_schedule
    end

    def update
      @schedule = @journal.schedule || @journal.build_schedule
      if @schedule.update(schedule_params)
        redirect_to @journal, notice: 'Расписание сохранено'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_journal
      @journal = Journal.find(params[:journal_id])
    end

    def schedule_params
      params.require(:schedule).permit(:times, :days)
    end
  end
end