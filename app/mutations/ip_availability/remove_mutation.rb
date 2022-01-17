class IpAvailability::RemoveMutation < Mutations::Command
  required do
    string :ip
  end

  def validate
    add_error(:ip, :invalid, "Not tracking #{ip}") unless interval
  end

  def execute
    interval.update! till: Time.current
  end

  def interval
    @interval ||= IpTrackingInterval.open.find_by(ip: ip)
  end
end
