class CustomFormBuilder < SimpleForm::FormBuilder
  include Rails.application.routes.url_helpers
  include ActionView::Context
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::FormTagHelper
  # include FieldNotesHelper

  def input(attribute_name, options = {}, &block)
    form_name = @object.class.name
    field_name = attribute_name
    dynamic_options = if options[:label] == false
                        # no label
                        {}
                      else
                        {
                          # hint: build_field_note(form_name, field_name, default_note: options[:hint]),
                          # label: build_field_label(form_name, field_name, template.assigns['current_agent'], default_label: options[:label])
                        }
                      end
    super(
      attribute_name,
      options.merge(dynamic_options),
      &block
    )
  end
end