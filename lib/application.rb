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
    response = @api.get_request('tickets?page[size]=25')
    populate_tickets(JSON.parse(response.body, :symbolize_names => true))
  def populate_tickets(json)
    json[:tickets].each do |ticket|
      @tickets << ticket
    end
  end
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