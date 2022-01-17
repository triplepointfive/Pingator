class IpAvailability::StatsMutation < Mutations::Command
  required do
    string :ip
    time :since
    time :till
  end

  def validate
    add_error(:base, :invalid, "No data for IP #{ip} and interval #{since.to_i}-#{till.to_i}") if rtts.empty? && lost_count.zero?
  end

  def execute
    {
      average: rtts_mean,
      minimum: rtts.first,
      maximum: rtts.last,
      median: rtts.any? ? (rtts[(rtts.size - 1) / 2] + rtts[rtts.size / 2]) / 2.0 : nil,
      standard_deviation: standard_deviation,
      lost: lost_count.to_f / (rtts.size + lost_count),
    }.transform_values { |v| v&.round(3) }
  end

  def rtts
    @rtts ||= Ping.where(ip: ip).round_trip.at(since: since, till: till).order(rtt: :asc).pluck(:rtt)
  end

  def rtts_mean
    @rtts_mean ||= rtts.empty? ? nil : rtts.sum(0.0) / rtts.size
  end

  def lost_count
    @lost_count ||= Ping.where(ip: ip).lost.at(since: since, till: till).count
  end

  def standard_deviation
    return if rtts.size < 2

    Math.sqrt(rtts.sum(0.0) { |element| (element - rtts_mean) ** 2 } / (rtts.size - 1))
  end
end
