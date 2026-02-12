class Journal < ApplicationRecord
  include TrackableLastChanger
  has_paper_trail ignore: [:updated_at]

  has_many :fields, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :schedules, dependent: :destroy

  validates :title, presence: true

  accepts_nested_attributes_for :fields,
                                allow_destroy: true,          # разрешаем удаление полей
                                reject_if: proc { |attributes| attributes['name'].blank? }  # игнорируем пустые

  def related_versions
    # Предварительно загружаем версии для Journal и его полей
    journal_with_versions = Journal.includes(:versions, fields: :versions).find(self.id)

    versions = []
    versions += journal_with_versions.versions.to_a
    versions += journal_with_versions.fields.map(&:versions).flat_map(&:to_a)

    versions.sort_by { |v| v.created_at || Time.at(0) }
  end
end
