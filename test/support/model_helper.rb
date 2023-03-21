module ModelHelper
  def assert_attributes(record, attrs)
    attrs.each do |key, value|
      if value.is_a?(Array)
        assert_same_elements value, record.send(key)
      else
        if value.nil?
          assert_nil record.send(key)
        else
          assert_equal value, record.send(key)
        end
      end
    end
  end

  def assert_objects(expected, tested, attributes)
    expected_attributes = expected.attributes.select{|attr| attributes.include?(attr) }
    tested_attributes = tested.attributes.select{|attr| attributes.include?(attr) }
    assert_equal expected_attributes, tested_attributes
  end
end