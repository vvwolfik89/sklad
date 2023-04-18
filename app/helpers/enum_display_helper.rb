module EnumDisplayHelper
  # enum_display(Member, :role)
  # enum_display(Member, :role, :vip)
  # enum_display(Member.find(1), :role)
  # Returns the translated enum_attr for a particular class and value
  def enum_display(klass, enum_attr, value = nil)
    if (!klass.is_a? Class)
      value = klass.send(enum_attr)
      klass = klass.class
    end
    klass.human_attribute_name([enum_attr, value].join('.'))
  end

  # enum_options_for_select(Member, :role)
  # Returns an array of enum translations and their raw versions for use
  # in select_tag
  def enum_options_for_select(klass, enum)
    klass.send(enum.to_s.pluralize).map do |key, _|
      [enum_display(klass, enum, key), key]
    end
  end
end
