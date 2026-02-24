class Schedule < ApplicationRecord
  # belongs_to :journal

  # Пример: { times: ['08:00', '17:00'], days: [1,2,3,4,5] }
  # attribute :times, :array, default: []
  # attribute :days, :array, default: (0..6).to_a
end
