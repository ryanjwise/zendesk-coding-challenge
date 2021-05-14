class Application
  include Shared

  def initialize
    @user = User.new
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
      @api.evaluate_response(response.status)
      response_body = JSON.parse(response.body, symbolize_names: true)
      has_more = response_body[:meta][:has_more]
      links = response_body[:links]
      @tickets = response_body[:tickets] unless links[:prev].nil?
      system('clear')
      build_table
      has_more ? update_links(links) : (puts "No more tickets #{@page_direction}")
      menu = true
      menu = process_menu(menu_options(has_more)) while menu
    end
  end

  # Menu's

  def menu_options(has_more)
    choices = {}
    choices['View ticket'] = 1
    choices['Next Page']   = 2 unless has_more == false && @page_direction == 'forward'
    choices['Previous']    = 3 unless has_more == false && @page_direction == 'backward'
    choices['Quit']        = 4
    get_choice('What would you like to do?', choices)
  end

  def process_menu(selection)
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

  def confirm_user?
    update = true
    while update
      update = get_input(
        "You are currently connecting to the #{@user.subdomain} subdomain, would you like to update credentials?",
        'confirm',
        false
      )
      @user.create_user if update
    end
  end

  # Ticket Methods

  def select_ticket
    choices = {}
    choices[:Cancel] = 'Cancel'
    # Populate selection menu with menu text & return value
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

  # Helper Methods

  def update_links(links)
    @link_forward = links[:next].split('/').last
    @link_back = links[:prev].split('/').last
  end

  def build_table
    table = TTY::Table.new(header: ['ID', 'Subject', 'Priority', 'Status', 'LastUpdated'])
    @tickets.each do |ticket|
      ticket[:priority] ||= 'n/a'
      # Remove time from datestamp and reverse order to DD/MM/YYYY
      ticket[:updated_at] = ticket[:updated_at].split('T').first.split('-').reverse.join('-')
      ticket[:created_at] = ticket[:created_at].split('T').first.split('-').reverse.join('-')
      table << [ticket[:id], ticket[:subject], ticket[:priority], ticket[:status], ticket[:updated_at]]
    end
    puts table.render(:ascii, padding: [0, 1, 0, 1])
  end
end
