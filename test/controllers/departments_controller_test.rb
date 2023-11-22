require "test_helper"
# require 'support/sign_in'
require "support/model_helper"


class DepartmentsControllerTest < ActionDispatch::IntegrationTest
  # include SignIn
  include ModelHelper

  let(:user) { users(:superadmin) }

  let(:success_attributes) do
    {
      title: 'some event',
      start: '2018-11-12 16:00',
      end: '2018-11-12 19:00'
    }
  end

  setup do
    sign_in(user)
    # Time.stubs(current: Time.utc(2015, 10, 10))
  end


  test "should get index" do
    get departments_url

    assert_response :success
  end

  test "should get new" do
    get new_department_url
    assert_response :success
  end

  test "should create department" do
    department_params = {
      title: "Title",
      body: "body"
    }

    assert_difference('Department.count') do
      post departments_url, params: {
        department: department_params
      }
    end

    department = assigns(:department)

    assert_attributes(department, department_params)

    assert_redirected_to department_path(department)
  end


  test "should show role" do
    department = departments(:one)
    get departments_url, params: { id: department }
    assert_response :success
  end

  test "should get edit" do
    department = departments(:one)
    get edit_department_url(department)
    assert_response :success
  end

  test "should update role" do
    success_attributes = { title: 'MyString1', body: 'MyText1' }
    department = departments(:one)
    patch department_url(department), params: { department: success_attributes }
    # patch article_url(article), params: { article: { title: "updated" } }

    department.reload
    assert_attributes(department, success_attributes)
    assert_redirected_to department_path(department)
  end
end



