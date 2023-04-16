module ApplicationHelper
  def main_left_menu_link(path, icon, text, options = {})
    left_menu_link(path, icon, text, options.merge(class_name: 'nav-item nav-link'))
  end

  def left_menu_link(path, icon, text, options = {})
    active_link_options = options[:active_link_options] || {}
    active_link_to(path, active_link_options.merge(wrap_tag: :a, wrap_class: 'nav-item nav-link')) do
        # concat content_tag(:a, text, class: options[:class_name])
        concat content_tag(:i, text, class: "fa #{icon}") if icon
    end
  end

  def fa_icon (icon_name, text='')
    content_tag(:i, text, class: "fa fa-#{icon_name}")
  end
end
