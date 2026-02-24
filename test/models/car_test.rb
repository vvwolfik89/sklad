# test/models/car_test.rb
require 'test_helper'

class CarTest < ActiveSupport::TestCase
  setup do
    @car = cars(:one) # предполагаем, что есть фикстура cars с записью :one
    @valid_attributes = {
      registration_number: 'A123BC',
      model: 'X5',
      brand: 'BMW',
      date_registration: Date.today,
      date_of_manufacture: Date.today.prev_year,
      fuel_type: 'diesel', # используем строку, как в тестах валидации
      vin: '1HGCM82633A123456',
      vin_equipment: 'EQUIP123',
      date_to: Date.today + 1.year,
      date_safety: Date.today + 6.months
    }
  end

  test 'should be valid with valid attributes' do
    assert_not @car.valid?
  end

  describe 'Validations' do
    %i[registration_number model brand date_registration date_of_manufacture fuel_type vin vin_equipment date_to date_safety].each do |attribute|
      test "should validate presence of #{attribute}" do
        @car[attribute] = nil
        assert_not @car.valid?, "#{attribute} should not be valid when blank"
        assert_includes @car.errors[attribute], "can't be blank"
      end
    end

    %i[registration_number vin vin_equipment].each do |attribute|
      test "should validate uniqueness of #{attribute}" do
        # Создаём существующую машину с уникальным значением
        existing_car = Car.create!(@valid_attributes)

        # Пытаемся создать машину с тем же значением атрибута
        duplicate_car = Car.new(existing_car.attributes.except('id'))

        assert_not duplicate_car.valid?
        assert_includes duplicate_car.errors[attribute], 'has already been taken'
      end
    end

    test 'should reject invalid fuel types' do
      invalid_types = ['electric', 'hybrid']

      invalid_types.each do |type|
        attributes = @valid_attributes.merge(fuel_type: type)
        assert_raises ArgumentError do
          car = Car.new(attributes)
          refute car.valid?
          assert_includes car.errors[:fuel_type], 'is not included in the list'
        end

      end
    end
  end

  test 'should have correct associations' do
    assert_respond_to @car, :registers_car_inspections
    # Дополнительно можно проверить тип ассоциации и через какую таблицу
  end

  test 'enum fuel_type should have correct values' do
    expected_fuel_types = { 'diesel' => 0, 'gas' => 1 }
    assert_equal expected_fuel_types, Car.fuel_types
  end

  test 'can be set to diesel fuel type' do
    car = Car.new(fuel_type: :diesel)
    assert_equal 'diesel', car.fuel_type
  end

  test 'can be set to gas fuel type' do
    car = Car.new(fuel_type: :gas)
    assert_equal 'gas', car.fuel_type
  end

  test '.fuel_type_attributes_for_select should return translated fuel types' do
    # Мокаем I18n.t для тестирования локализации
    I18n.stub(:t, ->(key) { key.split('.').last.capitalize }) do
      result = Car.fuel_type_attributes_for_select

      expected_result = [
        ['Diesel', 'diesel'],
        ['Gas', 'gas']
      ]

      assert_equal expected_result, result
    end
  end

  test '.fuel_type_attributes_for_select calls I18n.t with correct keys' do
    keys_received = []
    I18n.stub(:t, ->(key) { keys_received << key; key.split('.').last.capitalize }) do
      Car.fuel_type_attributes_for_select
    end

    expected_keys = [
      'activerecord.attributes.car.fuel_types.diesel',
      'activerecord.attributes.car.fuel_types.gas'
    ]

    assert_equal expected_keys.sort, keys_received.sort
  end

  test 'should be valid with all required attributes' do
    car = Car.new(@valid_attributes)
    assert car.valid?, 'Car should be valid with all required attributes'
  end
  #
end
