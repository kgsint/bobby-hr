require "test_helper"

class Auth::RegisterControllerTest < ActionDispatch::IntegrationTest
  test "it renders register page" do
    get register_url

    assert_response :ok
  end

  test "it creates users with correct params" do
    post register_url, params: {
      user: {
        name: "someone",
        email: "someone@company.com",
        password: "password"
      }
    }

    assert_redirected_to login_url
  end
end
