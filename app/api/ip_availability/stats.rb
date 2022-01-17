class IpAvailability::Stats < Grape::API
  desc 'Calculates IP address availability statistics for specific time interval'
  params do
    requires :ip, type: String, regexp: Resolv::AddressRegex
    requires :since, type: Integer
    requires :till, type: Integer
  end
  get '/*ip/stats/:since-:till' do
    puts params

    { status: :ok }
  end
end
