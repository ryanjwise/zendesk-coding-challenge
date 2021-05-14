require 'json'
require 'tty-prompt'
require_relative '../lib/shared'
require_relative '../lib/user'

RSpec.describe User do
  subject(:user) do
    User.new
  end

  describe 'Validate test file' do
    it 'should create an instance of user class' do
      expect(user).to be_a User
    end
  end

  describe 'File Load' do
    context 'should correctly populate fields using file IO' do

      it 'should correctly populate subdomain' do
        expect(user.subdomain).to be_truthy
      end

      it 'should correctly populate subdomain' do
        expect(user.email).to be_truthy
      end

      it 'should correctly populate subdomain' do
        expect(user.password).to be_truthy
      end
    end
  end
end
