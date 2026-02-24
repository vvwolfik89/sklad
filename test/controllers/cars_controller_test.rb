# test/controllers/cars_controller_test.rb
require 'test_helper'
require "support/model_helper"

class CarsControllerTest < ActionDispatch::IntegrationTest
  include ModelHelper

  let(:user) { users(:superadmin) }

  setup do
    @car = cars(:one)
    @valid_params = {
      car: {
        registration_number: 'ABC123',
        model: 'Test Model',
        brand: 'Test Brand',
        date_registration: Date.current,
        date_of_manufacture: Date.current - 5.years,
        fuel_type: 'diesel',
        vin: 'VIN1234567890',
        vin_equipment: 'EQUIP123',
        date_to: Date.current + 1.year,
        date_safety: Date.current + 6.months
      }
    }
  end

  setup do
    sign_in(user)
    # Time.stubs(current: Time.utc(2015, 10, 10))
  end

  test 'should get index' do
    get cars_url
    assert_response :success
    assert_not_nil assigns(:cars)
  end

  test 'should get index as json' do
    get cars_url, as: :json
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal Car.all.size, json_response.size
  end

  test 'should get show' do
    get car_url(@car)
    assert_response :success
    assert_equal @car, assigns(:car)
  end

  test 'should get show as json' do
    get car_url(@car), as: :json
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal @car.id, json_response['id']
  end

  test 'should get new' do
    get new_car_url
    assert_response :success
    assert_not_nil assigns(:car)
  end

  test 'should get new as json' do
    get new_car_url, as: :json
    assert_response :success
  end

  test 'should get edit' do
    get edit_car_url(@car)
    assert_response :success
    assert_equal @car, assigns(:car)
  end

  test 'should create car' do
    assert_difference('Car.count') do
      post cars_url, params: @valid_params
    end

    assert_redirected_to car_url(Car.last)
    assert_equal 'Permission was successfully created.', flash[:notice]
  end

  test 'should not create car with invalid params' do
    invalid_params = @valid_params.deep_dup
    invalid_params[:car][:registration_number] = nil

    assert_no_difference('Car.count') do
      post cars_url, params: invalid_params
    end

    assert_template :new
  end

  test 'should create car as json with valid params' do
    assert_difference('Car.count') do
      post cars_url, params: @valid_params, as: :json
    end

    assert_response :created
  end

  test 'should not create car as json with invalid params' do
    invalid_params = @valid_params.deep_dup
    invalid_params[:car][:registration_number] = nil

    post cars_url, params: invalid_params, as: :json

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)

    # Проверяем, что есть какие‑то ошибки (любые)
    assert json_response.values.any?(&:present?),
           'Response should contain some error information'
  end

  test 'should update car' do
    patch car_url(@car), params: @valid_params

    @car.reload
    assert_equal 'ABC123', @car.registration_number
    assert_redirected_to car_url(@car)
    assert_equal 'Car was successfully updated.', flash[:notice]
  end

  test 'should not update car with invalid params' do
    invalid_params = @valid_params.deep_dup
    invalid_params[:car][:registration_number] = ''

    patch car_url(@car), params: invalid_params

    assert_template :edit
  end

  test 'should update car as json' do
    patch car_url(@car), params: @valid_params, as: :json

    assert_response :no_content
  end

  test 'should not update car as json with invalid params' do
    invalid_params = @valid_params.deep_dup
    invalid_params[:car][:registration_number] = nil

    patch car_url(@car), params: invalid_params, as: :json

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert json_response.values.any?(&:present?),
           'Response should contain some error information'
  end

  test 'should destroy car' do
    assert_difference('Car.count', -1) do
      delete car_url(@car)
    end

    assert_redirected_to cars_url
  end

  test 'should destroy car as json' do
    delete car_url(@car), as: :json

    assert_response :no_content
  end
end
