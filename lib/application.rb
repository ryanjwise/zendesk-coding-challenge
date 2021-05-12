class Application

  include Shared

  def initialize
    @user = User.new()
    @api = Api.new(@user.subdomain, @user.email, @user.password)
    @tickets = []
  end

  def run
    confirm_user?
    response = @api.get_request('tickets?page[size]=25')
    populate_tickets(JSON.parse(response.body, :symbolize_names => true))
    build_table

  end

  def populate_tickets(json)
    json[:tickets].each do |ticket|
      @tickets << ticket
    end
  end

  def build_table
    table = TTY::Table.new(header: ["ID", "Subject", "Priority", "Status", "Last Updated"])
    @tickets.each do |ticket|
      ticket[:priority] ||= 'n/a'
      # Remove time from datestamp and reverse order to DD/MM/YYYY
      ticket[:updated_at] = ticket[:updated_at].split('T').first.split('-').reverse.join('-')
      table << [ticket[:id], ticket[:subject], ticket[:priority], ticket[:status], ticket[:updated_at]]
    end
    puts table.render(:ascii, padding: [0,1,0,1])
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