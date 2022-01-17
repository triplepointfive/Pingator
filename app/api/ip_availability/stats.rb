class IpAvailability::Stats < Grape::API
  desc 'Calculates IP address availability statistics for specific time interval'
  params do
    requires :ip, type: String, regexp: Resolv::AddressRegex
    requires :since, type: Integer
    requires :till, type: Integer
  end
  get '/*ip/stats/:since-:till' do
    ip = params[:ip]
    since = Time.at(params[:since])
    till = Time.at(params[:till])

    rtts = Ping.where(ip: ip).round_trip.at(since: since, till: till).order(rtt: :asc).pluck(:rtt)
    lost_count = Ping.where(ip: ip).lost.at(since: since, till: till).count
    rtts_mean = rtts.sum(0.0) / rtts.size

    return error!("No data for IP #{ip} and interval #{since.to_i}-#{till.to_i}", 422) if rtts.empty? && lost_count.zero?

    {
      status: :ok,
      stats: {
        average: rtts_mean,
        minimum: rtts.first,
        maximum: rtts.last,
        median: rtts.any? ? (rtts[(rtts.size - 1) / 2] + rtts[rtts.size / 2]) / 2.0 : nil,
        standard_deviation: rtts.any? ? Math.sqrt(rtts.sum(0.0) { |element| (element - rtts_mean) ** 2 } / (rtts.size - 1)) : nil,
        lost: lost_count.to_f / (rtts.size + lost_count),
      }.transform_values { |v| v&.round(3) }
    }
  end
end
