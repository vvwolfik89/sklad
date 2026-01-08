class Partner < ApplicationRecord
  has_many :order_details

  require 'roo'

  validates :name, presence: true, uniqueness: true
  # has_and_belongs_to_many :users


  def self.import_from_excel(file)
    spreadsheet = Roo::Spreadsheet.open(file.path)
    header = spreadsheet.row(12) # первая строка — заголовки

    imported = 0
    (13..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      partner = Partner.new(
        name: row["Получатель"],
        address: row["Юридический адрес"],
        # phone_number: row["phone_number"]
      )
      imported += 1 if partner.save
    end

    { count: imported }
  end
end
