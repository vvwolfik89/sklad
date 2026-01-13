# Переопределение модели Version (ваш существующий код)
module PaperTrail
  class Version < ::ActiveRecord::Base
    belongs_to :user, foreign_key: :whodunnit, optional: true
  end
end
