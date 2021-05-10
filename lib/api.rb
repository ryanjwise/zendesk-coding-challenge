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
end