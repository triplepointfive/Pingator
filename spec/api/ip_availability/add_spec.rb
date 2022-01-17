describe IpAvailability::Add do
  describe 'POST /ip_availability/add' do
    it 'open interval' do
      post '/api/v1/ip_availability/127.0.0.1/add'

      expect(response.status).to eq(201)
      expect(response_body).to eq status: 'ok'

      ip_tracking_interval = IpTrackingInterval.last
      expect(ip_tracking_interval).not_to be_nil
      expect(ip_tracking_interval.since).not_to be_nil
      expect(ip_tracking_interval.till).to be_nil
      expect(ip_tracking_interval.ip).to eq '127.0.0.1'
    end

    it 'when already tracking' do
      ip_tracking_interval = create :ip_tracking_interval

      post "/api/v1/ip_availability/#{ip_tracking_interval.ip}/add"

      expect(response.status).to eq(422)
      expect(response_body).to eq(
        status: "error",
        error: { ip: "Already tracking #{ip_tracking_interval.ip}" },
      )
    end
  end
end
