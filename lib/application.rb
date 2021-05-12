class Application

  include Shared

  def initialize
    @user = User.new()
    @api = Api.new(@user.subdomain, @user.email, @user.password)
    @tickets = []
  end

  def run
    confirm_user?
    endpoint = 'tickets?page[size]=25'
    loop do
      unless endpoint.nil?
        response = @api.get_request(endpoint)
        response_body = JSON.parse(response.body, symbolize_names: true)
        populate_tickets(response_body)
        puts '---'
        pp response_body[:meta]
        pp response_body[:links]
        puts '---'
        pp response.status
        puts '---'
        # system('clear')
        build_table
      end
      endpoint = process_menu(menu_options, response_body)
    end

  end

  def menu_options
    choices = {
      'View ticket' => 1,
      'Next Page' => 2,
      'Previous' => 3,
      'Quit' => 4
    }
    get_choice('What would you like to do?', choices)
  end

  def process_menu(selection, response)
    case selection
    when 1
      selection = select_ticket
      display_ticket(selection) unless selection == 'Cancel'
      nil
    when 2
      response[:links][:next].split('/').last
    when 3
      response[:links][:prev].split('/').last
    when 4
      puts "\nSee you next time!"
      exit(0)
    end
  end

  def select_ticket
    choices = {}
    choices[:Cancel] = 'Cancel'
    @tickets.each_with_index { |ticket, index| choices["#{ticket[:id]} - #{ticket[:subject]}"] = index }
    get_choice('Which Ticket', choices)
  end

  def display_ticket(selection)
    ticket = @tickets[selection]
    puts
    puts "#{ticket[:id]} - #{ticket[:subject]}"
    puts "\nPriority: #{ticket[:priority]}"
    puts "Created: #{ticket[:created_at]}"
    puts "Updated: #{ticket[:updated_at]}"
    puts "Description: \n\n#{ticket[:description]}"
    puts
  end

  def populate_tickets(json)
    @tickets = []
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
      ticket[:created_at] = ticket[:created_at].split('T').first.split('-').reverse.join('-')
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