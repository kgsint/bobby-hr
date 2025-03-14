require "application_system_test_case"

class LeaveRequestsTest < ApplicationSystemTestCase
  setup do
    @leave_request = leave_requests(:one)
  end

  test "visiting the index" do
    visit leave_requests_url
    assert_selector "h1", text: "Leave requests"
  end

  test "should create leave request" do
    visit leave_requests_url
    click_on "New leave request"

    fill_in "Approved at", with: @leave_request.approved_at
    fill_in "Employee", with: @leave_request.employee_id
    fill_in "From", with: @leave_request.from
    fill_in "Status", with: @leave_request.status
    fill_in "To", with: @leave_request.to
    fill_in "Type", with: @leave_request.type
    click_on "Create Leave request"

    assert_text "Leave request was successfully created"
    click_on "Back"
  end

  test "should update Leave request" do
    visit leave_request_url(@leave_request)
    click_on "Edit this leave request", match: :first

    fill_in "Approved at", with: @leave_request.approved_at
    fill_in "Employee", with: @leave_request.employee_id
    fill_in "From", with: @leave_request.from
    fill_in "Status", with: @leave_request.status
    fill_in "To", with: @leave_request.to
    fill_in "Type", with: @leave_request.type
    click_on "Update Leave request"

    assert_text "Leave request was successfully updated"
    click_on "Back"
  end

  test "should destroy Leave request" do
    visit leave_request_url(@leave_request)
    click_on "Destroy this leave request", match: :first

    assert_text "Leave request was successfully destroyed"
  end
end
