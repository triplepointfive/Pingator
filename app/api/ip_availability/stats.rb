class IpAvailability::Stats < Grape::API
  desc 'Calculates IP address availability statistics for specific time interval'
  params do
    requires :ip, type: String, regexp: Resolv::AddressRegex
    requires :since, type: Integer
    requires :till, type: Integer
  end
  get '/*ip/stats/:since-:till' do
    render_mutation_result IpAvailability::StatsMutation.run(
      ip: params[:ip],
      since: Time.at(params[:since]),
      till: Time.at(params[:till]),
    )
  end
end
