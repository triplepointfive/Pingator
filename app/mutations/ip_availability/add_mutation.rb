class IpAvailability::AddMutation < Mutations::Command
  required do
    string :ip
  end

  def validate
    add_error(:ip, :invalid, "Already tracking #{ip}") if IpTrackingInterval.open.where(ip: ip).any?
  end

  def execute
    IpTrackingInterval.create!(ip: ip, since: Time.current)
  end
end
