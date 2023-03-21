require "test_helper"

class DepartmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  #
  test "should not save article without title" do
    department = Department.new
    assert_not department.save
  end
end
