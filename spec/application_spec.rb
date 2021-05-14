require 'json'
require 'tty-prompt'
require 'tty-table'
require 'faraday'
require_relative '../lib/shared'
require_relative '../lib/user'
require_relative '../lib/api'
require_relative '../lib/application'

RSpec.describe Application do
  subject(:app) do
    Application.new
  end

  describe 'Validate test file' do
    it 'should create an instance of application class' do
      expect(app).to be_a Application
    end
  end

  describe 'Confirm default data types' do
    it 'should contain an empty ticket array' do
      expect(app.inspect).to include('@tickets=[]')
    end

    it 'should contain the correct initial endpoint' do
      expect(app.inspect).to include(@endpoint="tickets?page[size]=25")
    end

    it 'should contain an empty page_direction field' do
      expect(app.inspect).to include('@page_direction=nil')
    end

    it 'should contain an empty link_back field' do
      expect(app.inspect).to include('@link_back=nil')
    end

    it 'should contain an empty link_forward field' do
      expect(app.inspect).to include('@link_forward=nil')
    end
  end

  describe 'update links' do
    before(:each) do
      links = {
        next: 'text to be removed/text to keep(next)',
        prev: 'text to be removed/text to keep(prev)'
      }
      app.update_links(links)
    end

    it 'should correctly populate the link_forward attribute' do
      expect(app.inspect).to include(@link_forward='text to keep(next)')
    end

    it 'should correctly populate the link_backward attribute' do
      expect(app.inspect).to include(@link_backward='text to keep(prev)')
    end
  end

  describe 'process_menu' do
    before(:each) do
      links = {
        next: 'text to be removed/text to keep(next)',
        prev: 'text to be removed/text to keep(prev)'
      }
      app.update_links(links)
    end

    it 'should return false to maintain the menu selection loop when displaying ticket' do
      skip 'Test works, however requires minimal additional input on the part of the tester and thus has been enabled for simplicity'
      expect(app.process_menu(1)).to be_truthy
    end

    it 'should set the correct endpoint when paging forward' do
      app.process_menu(2)
      expect(app.inspect).to include(@link_forward='text to keep(next)')
    end

    it 'should update page direction correctly when paging forward' do
      app.process_menu(2)
      expect(app.inspect).to include(@page_direction='forward')
    end

    it 'should set the correct endpoint when paging backward' do
      app.process_menu(3)
      expect(app.inspect).to include(@link_back='text to keep(prev)')
    end

    it 'should update page direction correctly when paging backward' do
      app.process_menu(3)
      expect(app.inspect).to include(@page_direction='backward')
    end
    
    it 'should exit the application on option 4' do
      skip 'Currently unsure how to test exit codes, currently rspec is exiting when it hits them.'
      expect(app.process_menu(4)).to call_exit.with(0)
    end
  end

end