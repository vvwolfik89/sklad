# test/models/partner_test.rb
require 'test_helper'
require 'roo'

class PartnerTest < ActiveSupport::TestCase
  setup do
    @valid_attributes = {
      name: 'Test Partner',
      address: '123 Test Street'
    }
  end

  test 'should be valid with valid attributes' do
    partner = Partner.new(@valid_attributes)
    assert partner.valid?
  end

  test 'should validate presence of name' do
    partner = Partner.new(@valid_attributes.merge(name: nil))
    assert_not partner.valid?
    assert_includes partner.errors[:name], "can't be blank"
  end

  test 'should validate uniqueness of name' do
    Partner.create!(@valid_attributes)

    duplicate_partner = Partner.new(@valid_attributes)
    assert_not duplicate_partner.valid?
    assert_includes duplicate_partner.errors[:name], 'has already been taken'
  end

  test 'should have many order_details' do
    assert_respond_to Partner.new, :order_details
  end
end
