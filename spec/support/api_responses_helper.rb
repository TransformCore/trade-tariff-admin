module ApiResponsesHelper
  def stub_api_for(klass, &block)
    klass.use_api(api = Her::API.new)

    api.setup url: Rails.application.config.api_host do |c|
      c.use Her::Middleware::HeaderMetadataParse # lib/her/middleware/header_metadata_parse.rb
      c.use Her::Middleware::AcceptApiV2         # lib/her/middleware/accept_api_v2.rb
      c.use Her::Middleware::TariffJsonapiParser # lib/her/middleware/tariff_jsonapi_parser.rb
      c.adapter(:test, &block)
    end
  end

  def api_success_response(response = {}, headers = {})
    [200, headers, response.to_json]
  end

  def jsonapi_success_response(type, response = {}, headers = {})
    response = case response
               when Hash
                 { data: { type: type, attributes: response } }
               when Array
                 { data: response.map { |r| { type: type, attributes: r } } }
               else
                 response
               end
    [200, headers, response.to_json]
  end

  def api_created_response(body = {}, headers = {})
    api_response(201, headers, body)
  end

  def api_no_content_response(body = {}, headers = {})
    api_response(204, headers, body)
  end

  def api_response(status, headers, body)
    [status, headers, body.to_json]
  end
end
