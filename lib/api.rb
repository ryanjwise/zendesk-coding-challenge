class Api
  def initialize(subdomain, email, password)
    @zendesk = Faraday.new(
      url: "https://#{subdomain}.zendesk.com/api/v2/"
    )
    @zendesk.basic_auth(email, password)
  end

  def get_request(endpoint)
    @zendesk.get(endpoint)
  end

  def evaluate_response(response_code)
    case response_code
    when 200
      return
    when 401
      puts "Error #{response_code}"
      puts 'invalid credentials, please update and try again'
    when 500..599
      puts "Error #{response_code}"
      puts 'Indicating a Zendesk internal issue, check https://status.zendesk.com/ for status or try again'
    else
      puts "Error code #{response_code}"
      puts 'Check https://developer.zendesk.com/rest_api/docs/support/introduction#response-format for details'
    end
    exit(response_code)
  end
end
