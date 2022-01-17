class API < Grape::API
  version 'v1', using: :path
  format :json
  prefix :api

  rescue_from :all do |e|
    rack_response({ error: e.message }.to_json, 500)
  end

  resource :ip_availability do
    mount IpAvailability::Add
    mount IpAvailability::Remove
    mount IpAvailability::Stats
  end
end
