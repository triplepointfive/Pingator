class IpAvailability::Add < Grape::API
  desc 'Adds IP address to track'
  params do
    requires :ip, type: String, regexp: Resolv::AddressRegex
  end
  post '/*ip/add' do
    ip = params['ip']

    return error!("Already tracking #{ip}", 422) if IpTrackingInterval.open.where(ip: ip).any?
    IpTrackingInterval.create!(ip: ip, since: Time.current)

    { status: :ok }
  end
end
