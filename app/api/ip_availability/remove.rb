class IpAvailability::Remove < Grape::API
  desc 'Deletes IP address from tracking'
  params do
    requires :ip, type: String, regexp: Resolv::AddressRegex
  end
  delete '/*ip/remove' do
    render_mutation_result IpAvailability::RemoveMutation.run(ip: params[:ip]), status_only: true
  end
end
