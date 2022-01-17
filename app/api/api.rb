class API < Grape::API
  IP_ADDRESS_REGEXP = /\A((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\z/

  version 'v1', using: :path
  format :json
  prefix :api

  resource :ip_availability do
    desc 'Adds IP address to track'
    params do
      requires :ip, type: String, regexp: IP_ADDRESS_REGEXP
    end
    post '/*ip/add' do
      puts params

      { status: :ok }
    end

    desc 'Deletes IP address from tracking'
    params do
      requires :ip, type: String, regexp: IP_ADDRESS_REGEXP
    end
    delete '/*ip/remove' do
      puts params

      { status: :ok }
    end

    desc 'Calculates IP address availability statistics for specific time interval'
    params do
      requires :ip, type: String, regexp: IP_ADDRESS_REGEXP
      requires :since, type: Integer
      requires :till, type: Integer
    end
    get '/*ip/stats/:since-:till' do
      puts params

      { status: :ok }
    end
  end
end
