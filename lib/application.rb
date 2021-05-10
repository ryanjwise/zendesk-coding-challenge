

class Application
  def initialize
    @user = User.new()
    pp @user.subdomain
    pp @user.email
    pp @user.password
    # tickets = [
      # Either initialise array of ticket class instances
      # Or Array of ticket hashes
    # ]
  end
end