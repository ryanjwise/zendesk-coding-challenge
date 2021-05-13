class Application

  include Shared

  def initialize
    @user = User.new()
    @api = Api.new(@user.subdomain, @user.email, @user.password)
    @tickets = []
    @endpoint = 'tickets?page[size]=25'
    @page_direction = nil
    @link_back = nil
    @link_forward = nil
  end

  def run
    confirm_user?
    loop do
      response = @api.get_request(@endpoint)
      response_body = JSON.parse(response.body, symbolize_names: true)
      populate_tickets(response_body) unless response_body[:links][:prev].nil?
      puts '---'
      pp response_body[:meta][:has_more]
      pp response_body[:links][:prev]
      pp response_body[:links][:next]
      puts '---'
      pp response.status
      puts '---'
      # system('clear')
      build_table
      set_links(response_body)
      menu = true
      while menu
        menu = process_menu(menu_options(response_body[:meta][:has_more]), response_body)
      end
    end

  end

  def menu_options(has_more)
    choices = {}
    choices['View ticket'] = 1
    choices['Next Page']   = 2 unless has_more == false && @page_direction == 'forward'
    choices['Previous']    = 3 unless has_more == false && @page_direction == 'backward'
    choices['Quit']        = 4
    get_choice('What would you like to do?', choices)
  end

  def set_links(response)
    if response[:meta][:has_more]
      @link_forward = response[:links][:next].split('/').last
      @link_back = response[:links][:prev].split('/').last
    end
  end

  def process_menu(selection, response)
    case selection
    when 1
      selection = select_ticket
      display_ticket(selection) unless selection == 'Cancel'
      return true
    when 2
      @endpoint = @link_forward
      @page_direction = 'forward'
    when 3
      @endpoint = @link_back
      @page_direction = 'backward'
    when 4
      puts "\nSee you next time!"
      exit(0)
    end
    false
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