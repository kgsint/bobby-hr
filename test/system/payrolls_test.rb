require "application_system_test_case"

class PayrollsTest < ApplicationSystemTestCase
  setup do
    @payroll = payrolls(:one)
  end

  test "visiting the index" do
    visit payrolls_url
    assert_selector "h1", text: "Payrolls"
  end

  test "should create payroll" do
    visit payrolls_url
    click_on "New payroll"

    fill_in "Benefits deductions", with: @payroll.benefits_deductions
    fill_in "Employee", with: @payroll.employee_id
    fill_in "Gross pay", with: @payroll.gross_pay
    fill_in "Net pay", with: @payroll.net_pay
    fill_in "Other deductions", with: @payroll.other_deductions
    fill_in "Pay date", with: @payroll.pay_date
    fill_in "Tax deductions", with: @payroll.tax_deductions
    click_on "Create Payroll"

    assert_text "Payroll was successfully created"
    click_on "Back"
  end

  test "should update Payroll" do
    visit payroll_url(@payroll)
    click_on "Edit this payroll", match: :first

    fill_in "Benefits deductions", with: @payroll.benefits_deductions
    fill_in "Employee", with: @payroll.employee_id
    fill_in "Gross pay", with: @payroll.gross_pay
    fill_in "Net pay", with: @payroll.net_pay
    fill_in "Other deductions", with: @payroll.other_deductions
    fill_in "Pay date", with: @payroll.pay_date
    fill_in "Tax deductions", with: @payroll.tax_deductions
    click_on "Update Payroll"

    assert_text "Payroll was successfully updated"
    click_on "Back"
  end

  test "should destroy Payroll" do
    visit payroll_url(@payroll)
    click_on "Destroy this payroll", match: :first

    assert_text "Payroll was successfully destroyed"
  end
end
