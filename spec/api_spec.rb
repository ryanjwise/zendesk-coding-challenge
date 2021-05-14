require 'faraday'
require_relative '../lib/api'

RSpec.describe Api do
  subject(:api) do
    Api.new('subdomain', 'email@address.com', 'password')
  end

  describe 'Validate test file' do
    it 'should create an instance of api' do
      expect(api).to be_a Api
    end
  end

  describe 'Should return a response message' do
    it 'should receive a message response from the API' do
      expect(api.get_request('tickets').status).to eq(401)
    end
  end

  describe 'Should process response codes' do
    it 'should continue running on a 200 response' do
      expect(api.evaluate_response(200)).to be_nil
    end

    it 'should exit on a 400 response' do
      skip 'Currently unsure how to test exit codes, currently rspec is exiting when it hits them.'
      expect(api.evaluate_response(400)).to call_exit.with(400)
    end
  end
end