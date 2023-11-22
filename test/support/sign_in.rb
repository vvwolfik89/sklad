module SignIn
  def sign_in(user = users(:superadmin))
    @current_user = user
    post sign_in_url(email: @current_user.email, password: @current_user.password)
  end
end
