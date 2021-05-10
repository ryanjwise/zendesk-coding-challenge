class User
  attr_reader :credentials

  def initialize
    @file_path = './data/credentials.json'
    @credentials = load_user
  end

  def load_user
    create_user unless File.exist?(@file_path)

    json_data = JSON.parse(File.read(@file_path), symbolize_names: true)
  end

  def create_user
    File.open(@file_path, 'w+') # Create new file with read/write \
    user = { 
      subdomain: "subdomain_path",
      email: "user@email.com",
      password: "password"
    }
    File.write(@file_path, user.to_json)
  end
end