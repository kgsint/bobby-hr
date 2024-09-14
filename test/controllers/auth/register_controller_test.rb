require "test_helper"

class Auth::RegisterControllerTest < ActionDispatch::IntegrationTest
  test "it renders register page" do
    get register_url

    assert_response :ok
  end

  test "it creates users" do
    assert_nil User.find_by(email: "someone@company.com")

    post register_url, params: {
      user: {
        name: "someone",
        email: "someone@company.com",
        password: "password"
      }
    }

    assert_not_nil User.find_by(email: "someone@company.com")
  end
end
