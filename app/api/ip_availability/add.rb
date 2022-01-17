class IpAvailability::Add < Grape::API
  desc 'Adds IP address to track'
  params do
    requires :ip, type: String, regexp: Resolv::AddressRegex
  end
  post '/*ip/add' do
    render_mutation_result IpAvailability::AddMutation.run(ip: params[:ip]), status_only: true
  end
end
