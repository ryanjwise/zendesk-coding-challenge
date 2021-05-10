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
    response = @api.get_request('tickets')
    pp response
  end
end