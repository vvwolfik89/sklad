# test/models/role_test.rb
require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  setup do
    @valid_attributes = {
      role_type: :driver,
      title: 'Driver Role'
    }
  end

  test 'should be valid with valid attributes' do
    role = Role.new(@valid_attributes)
    assert role.valid?
  end

  # --- Валидации ---

  test 'should validate presence of role_type' do
    role = Role.new(@valid_attributes.merge(role_type: nil))
    assert_not role.valid?
    assert_includes role.errors[:role_type], "can't be blank"
  end

  test 'should validate presence of title' do
    role = Role.new(@valid_attributes.merge(title: nil))
    assert_not role.valid?
    assert_includes role.errors[:title], "can't be blank"
  end

  test 'should not accept invalid role_type' do
    invalid_types = ['invalid_type', 999, :unknown]

    invalid_types.each do |invalid_type|
      error_occurred = false

      begin
        role = Role.new(@valid_attributes.merge(role_type: invalid_type))
        # Если исключение не выбросилось, проверяем валидность
        assert_not role.valid?, "Role with role_type #{invalid_type} should be invalid"
        assert role.errors.key?(:role_type), "Errors should include role_type for #{invalid_type}"
      rescue ArgumentError => e
        error_occurred = true
        assert_match /is not a valid role_type/, e.message, "Error message should mention invalid role_type"
      end

      assert error_occurred, "Should raise ArgumentError for invalid role_type #{invalid_type}"
    end
  end

  test 'should accept valid role_types' do
    Role.role_types.keys.each do |valid_type|
      role = Role.new(@valid_attributes.merge(role_type: valid_type))
      assert role.valid?, "Role with role_type #{valid_type} should be valid"
    end
  end

  # --- Enum ---

  test 'role_type enum should have correct values' do
    expected_types = %w[super_admin company_admin department_admin department_admin_second driver cleaner picker loader]
    assert_equal expected_types, Role.role_types.keys
  end

  test 'should have correct enum scopes' do
    # Проверяем, что созданы scope‑методы для каждого типа роли
    Role.role_types.keys.each do |role_type|
      scope_method = "#{role_type}?"
      assert Role.instance_methods.include?(scope_method.to_sym), "Should have #{scope_method} method"
    end
  end

  test 'enum scopes should work correctly' do
    role = Role.create!(@valid_attributes)

    assert role.driver?, 'Role should be driver'

    other_types = Role.role_types.keys - ["driver"]
    other_types.each do |other_type|
      refute role.send("#{other_type}?"), "Role should not be #{other_type}"
    end
  end

  # --- Ассоциации ---

  test 'should have many users' do
    assert_respond_to Role.new, :users
    assert_respond_to Role.new.users, :<<
  end

  test 'should have many permissions' do
    assert_respond_to Role.new, :permissions
    assert_respond_to Role.new.permissions, :<<
  end

  test 'should create role with associated users' do
    user = users(:superadmin)  # предполагаем, что есть фикстура пользователя
    role = Role.create!(@valid_attributes)

    role.users << user
    role.reload

    assert_includes role.users, user
  end

  test 'should create role with associated permissions' do
    permission = permissions(:read)  # предполагаем, что есть фикстура разрешения
    role = Role.create!(@valid_attributes)

    role.permissions << permission
    role.reload

    assert_includes role.permissions, permission
  end

  # --- Метод role_type_attributes_for_select ---

  test 'role_type_attributes_for_select should return array of arrays' do
    result = Role.role_type_attributes_for_select

    assert result.is_a?(Array), 'Result should be an array'
    assert result.all? { |item| item.is_a?(Array) && item.size == 2 }, 'Each item should be an array with 2 elements'
  end

  test 'role_type_attributes_for_select should have correct size' do
    expected_count = Role.role_types.keys.size
    result = Role.role_type_attributes_for_select

    assert_equal expected_count, result.size, 'Should have same number of items as role types'
  end

  test 'role_type_attributes_for_select should include all role types' do
    result = Role.role_type_attributes_for_select
    result_types = result.map(&:last)  # берём последние элементы (сами типы)

    defined_types = Role.role_types.keys

    defined_types.each do |type|
      assert_includes result_types, type.to_s, "Should include #{type} type"
    end
  end

  # --- Дополнительные тесты ---


  test 'should save role with valid enum value' do
    valid_types = Role.role_types.keys

    valid_types.each_with_index do |role_type, index|
      # Используем разные названия для избежания дубликатов
      role = Role.new(
        role_type: role_type,
        title: "Test Role #{index}"
      )

      assert role.save, "Role with type #{role_type} should save"
    end
  end

  test 'should find roles by enum scope' do
    driver_role = Role.create!(role_type: :driver, title: 'Driver')
    admin_role = Role.create!(role_type: :super_admin, title: 'Super Admin')

    # Проверяем scope‑методы
    assert_includes Role.driver, driver_role
    refute_includes Role.driver, admin_role

    assert_includes Role.super_admin, admin_role
    refute_includes Role.super_admin, driver_role
  end

  test 'should handle mass assignment of role_type' do
    attributes = @valid_attributes.merge(role_type: 'driver')
    role = Role.new(attributes)

    assert role.valid?
    assert_equal 'driver', role.role_type
  end
end
