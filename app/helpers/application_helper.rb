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

  # def build_field_note_id(type, form_name, field_name)
  #   ['field_note', type, form_name, field_name].map do |key|
  #     key.to_s.gsub(/\W/, '')
  #   end.join('-')
  # end
  #
  # def field_note_description(form_name, field_name)
  #   key = build_field_note_id('note', form_name, field_name)
  #   Rails.cache.fetch(key) do
  #     field_note = FieldNote.find_by(form_name: form_name, field_name: field_name)
  #     build_field_note_note(field_note)
  #   end.try(:html_safe)
  # end
  #
  # def field_note_label(form_name, field_name, default_label: nil)
  #   key = build_field_note_id('label', form_name, field_name)
  #   Rails.cache.fetch(key) do
  #     field_note = FieldNote.find_by(form_name: form_name, field_name: field_name)
  #     build_field_note_label(field_note, field_name, default_label)
  #   end
  # end

  # def show_action_field_label(label, dynamic_label: nil)
  #   if dynamic_label
  #     class_name = dynamic_label[:object].class.name

      # d_label = field_note_label(class_name, dynamic_label[:field_name], default_label: label).gsub(':', '')

      # hint = field_note_description(class_name, dynamic_label[:field_name])
      #
      # default_label = if hint.present?
      #                   "#{d_label} #{content_tag(:span, nil, class: 'fa fa-question-circle-o mh5', data: {toggle: 'popover', html: true, content: hint})}".html_safe
      #                 else
      #                   d_label
      #                 end
      # (default_label + ':').html_safe
    # else
    #   label
    # end
  # end

  def show_action_field(label, dynamic_label: nil, &block)
    content_tag(:div, class: 'form-group') do
      # title = show_action_field_label(label, dynamic_label: dynamic_label)
      # concat(content_tag(:label, title, class: 'col-sm-3 control-label'))
      concat(content_tag(:div, class: 'col-sm-9') do
        content_tag(:div, class: 'bs-component') do
          content_tag(:p, yield, class: 'form-control-static text-muted')
        end
      end)
    end
  end

  def custom_form_for(object, *args, &block)
    options = args.extract_options!
    simple_form_for(object, *(args << options.merge(builder: CustomFormBuilder)), &block)
  end

  def bootstrap3_form_options(options = {})
    {
      html: { class: "form-horizontal #{options[:html_class]}" }.merge(options[:html] || {}),
      wrapper: options[:wrapper] || :horizontal_form,
      wrapper_mappings: {
        check_boxes: :horizontal_radio_and_checkboxes,
        radio_buttons: :horizontal_radio_and_checkboxes,
        file: :horizontal_file_input,
        boolean: :horizontal_boolean,
        ckeditor: :vertical_file_input
      }
    }
  end

  def admin
    # User.where(roles: :admin).last
  end

  def tab_link_for(tab_name, text, default = false)
    content_tag(:li, class: tab_pane_class_for(tab_name, default)) do
      link_to(text, "##{tab_name}", data: { toggle: 'tab' })
    end
  end

  def tab_pane_class_for(tab_name, default = false)
    classes = ["tab-#{tab_name}"]
    classes << 'active' if tab_name == params[:tab] || (default && params[:tab].blank?)
    classes.join(' ')
  end
end
