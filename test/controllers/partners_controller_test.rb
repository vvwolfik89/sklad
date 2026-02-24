# test/controllers/partners_controller_test.rb
require 'test_helper'
require 'roo'
require "support/model_helper"

class PartnersControllerTest < ActionDispatch::IntegrationTest
  include ModelHelper

  let(:user) { users(:superadmin) }
  setup do
    sign_in(user)
    @partner = partners(:one)
    @valid_params = {
      partner: {
        name: 'New Partner',
        address: '123 Test Street',
        description: 'Test description',
        email: 'test@example.com',
        phone_number: '123-456',
        legal_address: 'Legal address'
      }
    }
  end

  test 'should get index' do
    get partners_url
    assert_response :success
    assert_not_nil assigns(:partners)
  end

  test 'should get index as json' do
    get partners_url, as: :json
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal Partner.all.size, json_response.size
  end

  test 'should get show' do
    get partner_url(@partner)
    assert_response :success
    assert_equal @partner, assigns(:partner)
  end

  test 'should get show as json' do
    get partner_url(@partner), as: :json
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal @partner.id, json_response['id']
  end

  test 'should get new' do
    get new_partner_url
    assert_response :success
    assert_not_nil assigns(:partner)
  end

  test 'should get new as json' do
    get new_partner_url, as: :json
    assert_response :success
  end

  test 'should get edit' do
    get edit_partner_url(@partner)
    assert_response :success
    assert_equal @partner, assigns(:partner)
  end

  test 'should create partner' do
    assert_difference('Partner.count') do
      post partners_url, params: @valid_params
    end

    assert_redirected_to partner_url(Partner.last)
    assert_equal 'Permission was successfully created.', flash[:notice]
  end

  test 'should create partner as json with valid params' do
    assert_difference('Partner.count') do
      post partners_url, params: @valid_params, as: :json
    end

    assert_response :created
    assert_response_header 'Location'
  end

  test 'should not create partner with invalid params' do
    invalid_params = @valid_params.deep_dup
    invalid_params[:partner][:name] = nil

    assert_no_difference('Partner.count') do
      post partners_url, params: invalid_params
    end

    assert_template :new
  end

  test 'should not create partner as json with invalid params' do
    invalid_params = @valid_params.deep_dup
    invalid_params[:partner][:name] = nil

    post partners_url, params: invalid_params, as: :json

    # Отладочный вывод
    puts "Status: #{response.status}"
    puts "Headers: #{response.headers}"
    puts "Body: #{response.body}"

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    # assert json_response.key?('errors')
    assert json_response.key?('name')
  end

  test 'should update partner' do
    patch partner_url(@partner), params: @valid_params

    @partner.reload
    assert_equal 'New Partner', @partner.name
    assert_redirected_to partner_url(@partner)
    assert_equal 'Permission was successfully updated.', flash[:notice]
  end

  test 'should update partner as json' do
    patch partner_url(@partner), params: @valid_params, as: :json

    assert_response :no_content
  end

  test 'should not update partner with invalid params' do
    invalid_params = @valid_params.deep_dup
    invalid_params[:partner][:name] = ''

    patch partner_url(@partner), params: invalid_params

    assert_template :edit
  end

  test 'should destroy partner' do
    assert_difference('Partner.count', -1) do
      delete partner_url(@partner)
    end

    assert_redirected_to partners_url
  end

  test 'should destroy partner as json' do
    delete partner_url(@partner), as: :json

    assert_response :no_content
  end

  test 'should handle missing file in import' do
    post import_partners_url

    assert_redirected_to partners_url
    assert_equal 'Выберите файл для импорта', flash[:alert]
  end


  private
  def assert_response_header(header_name)
    assert_not_nil response.headers[header_name], "Header '#{header_name}' should be present"
  end
end
