module TrackableLastChanger
  extend ActiveSupport::Concern

  def last_changed_by
    # Вызываем метод `related_versions` ИЗ МОДЕЛИ
    version = related_versions.first
    return nil unless version&.whodunnit

    User.find_by(id: version.whodunnit.to_i)
  end
end