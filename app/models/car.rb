class Car < ApplicationRecord

  enum fuel_type: [:diesel, :gas]

  validates :registration_number, :model, :brand, :date_registration, :date_of_manufacture, :fuel_type, :vin, :vin_equipment, :date_to, :date_safety, presence: true

  validates :registration_number, :vin, :vin_equipment, uniqueness: true

  def self.fuel_type_attributes_for_select
    fuel_types.map do |type, _|
      [I18n.t("activerecord.attributes.#{model_name.i18n_key}.fuel_types.#{type}"), type]
    end
  end
end
