# config/initializers/paper_trail.rb
PaperTrail.config.serializer = JSON # или YAML, в зависимости от ваших данных

# Конфигурация PaperTrail
PaperTrail.configure do |config|
  # Включение PaperTrail глобально
  config.enabled = true

  # Сериализатор для хранения изменений
  config.serializer = PaperTrail::Serializers::JSON

end