class User
  attr_reader :subdomain, :email, :password

  include Shared

  def initialize
    @file_path = './data/credentials.json'
    @subdomain = nil
    @email = nil
    @password = nil
    load_user
  end

  def get_input(query, type="ask")
    case type
    when "ask"
      @@prompt.ask("What is your #{query}?", required: true)
    when "mask"
      @@prompt.mask("What is your #{query}?", required: true)
    end
  end

  def load_user
    create_user unless File.exist?(@file_path)

    json_data = JSON.parse(File.read(@file_path), symbolize_names: true)
    @subdomain = json_data[:subdomain]
    @email = json_data[:email]
    @password = json_data[:password]
  end

  def create_user
    puts "No User Credentials Stored, please input user credentials"
    user = { 
      subdomain: get_input("Subdomain Path"),
      email: get_input("Email Address"),
      password: get_input("Password", "mask")
    }
    File.open(@file_path, 'w+') # Create new file with read/write \
    File.write(@file_path, user.to_json)
  end
end