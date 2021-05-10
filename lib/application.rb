

class Application
  def initialize
    @user = User.new()
    pp @user.credentials[:subdomain]
    # tickets = [
      # Either initialise array of ticket class instances
      # Or Array of ticket hashes
    # ]
  end
end