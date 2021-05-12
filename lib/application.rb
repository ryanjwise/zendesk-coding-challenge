class Application
  def initialize
    @user = User.new()
    @api = Api.new(@user.subdomain, @user.email, @user.password)
    # tickets = [
      # Either initialise array of ticket class instances
      # Or Array of ticket hashes
    # ]
  end

  def run
    confirm_user?
  end
  def confirm_user?
    update = true
    while update
      update = get_input(
        "You are currently connecting to the #{@user.subdomain} subdomain, would you like to update credentials?",
        "confirm",
        false
      )
      @user.create_user if update
    end
  end
  end
end