module OrderLogsHelper

  ROUTE_DIRECTION = {
    'Минск'    => 'highlight-minsk',
    'Гомель'   => 'highlight-gomel',
    'Бобруйск' => 'highlight-gomel',
    'Шклов' => 'highlight-mogilev',
    'Могилев' => 'highlight-mogilev',
    'Борисов' => 'highlight-vitebsk',
    'Витебск' => 'highlight-vitebsk',
    'Гродно' => 'highlight-grodno',
    'Брест' => 'highlight-brest',
    'Барановичи' => 'highlight-brest',
    'Солигорск' => 'highlight-soligorsk'
    # ... другие города
  }.freeze


  def get_highlight_class(address)
    ROUTE_DIRECTION.each do |city, css_class|
      # Приводим к нижнему регистру и ищем подстроку
      if address.downcase.include?(city.downcase)
        return css_class
      end
    end
    '' # если город не найден
  end

  def partners_collection
    available_partners
  end
end
