class Entry < ApplicationRecord
  include TrackableLastChanger
  has_paper_trail ignore: [:updated_at]

  belongs_to :journal
  belongs_to :creator, class_name: 'User'  # кто заполнил
  has_many :field_values, dependent: :destroy

  accepts_nested_attributes_for :field_values, reject_if: :all_blank, allow_destroy: true

  validates :date, presence: true

  def related_versions
    # Предварительно загружаем версии для Journal и его полей
    entry_with_versions = Entry.includes(:versions, field_values: :versions).find(self.id)

    versions = []
    versions += entry_with_versions.versions.to_a
    versions += entry_with_versions.field_values.map(&:versions).flat_map(&:to_a)

    versions.sort_by { |v| v.created_at || Time.at(0) }
  end
end
