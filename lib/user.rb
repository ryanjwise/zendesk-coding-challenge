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

  def load_user
    if File.exist?(@file_path)
      json_data = JSON.parse(File.read(@file_path), symbolize_names: true)
      @subdomain = json_data[:subdomain]
      @email = json_data[:email]
      @password = json_data[:password]
    else
      puts 'No stored user credentials found, please input user credentials:'
      create_user
    end
  end

  def create_user
    @subdomain = get_input('Subdomain Path')
    @email = get_input('Email Address')
    @password = get_input('Password', 'mask')
    save_user
  end

  def save_user
    user = {
      subdomain: @subdomain,
      email: @email,
      password: @password
    }
    File.open(@file_path, 'w+') # Create new file with read/write permissions
    File.write(@file_path, user.to_json)
  end
end