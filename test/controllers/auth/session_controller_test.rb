require "test_helper"

class Auth::SessionControllerTest < ActionDispatch::IntegrationTest
  test "it renders login page" do
    get login_url

    assert_response :ok
  end

  test "it logins with user account" do
    assert_nil Current.user
    post login_url, params: { email: "userone@gmail.com", password: "password" }

    assert_redirected_to root_url
  end

  test "it doesnt login when incorrect email or password is provided" do
    post login_url, params: { email: "testuser@gmail.com", password: "dummy_password" }

    assert_response :unprocessable_entity
  end
end
