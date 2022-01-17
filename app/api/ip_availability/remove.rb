class IpAvailability::Remove < Grape::API
  desc 'Deletes IP address from tracking'
  params do
    requires :ip, type: String, regexp: Resolv::AddressRegex
  end
  delete '/*ip/remove' do
    ip = params['ip']
    interval = IpTrackingInterval.open.find_by(ip: ip)

    return error!("Not tracking #{ip}", 422) unless interval
    interval.update! till: Time.current

    { status: :ok }
  end
end
