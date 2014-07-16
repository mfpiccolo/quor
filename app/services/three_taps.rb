class ThreeTaps

  attr_reader :api_key, :rpp, :conn, :base_url, :zwsid, :demo_info

  def initialize(rpp=nil)
    @conn = Faraday.new
    @base_url = "http://search.3taps.com"
    @api_key = "3d6f2bded70fb9d4e7f2f015b1f1f76c"
    @rpp = rpp
  end

  def get_comp_rent
    request = SearchRequest.new
    request.rpp = "100"
    request.retvals = ["id", "price", "category", "location", "external_id", "external_url", "heading", "timestamp"]
    request.category = "RHFR"
    request.zip = "USA-95628"
    request.has_price = "1"
    client = SearchClient.new
    response = client.search(request)
  end

end
