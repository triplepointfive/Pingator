describe IpAvailability::Remove do
  describe 'DELETE /ip_availability/remove' do
    it 'close interval' do
      ip_tracking_interval = create :ip_tracking_interval

      delete "/api/v1/ip_availability/#{ip_tracking_interval.ip}/remove"

      expect(response.status).to eq(200)
      expect(response_body).to eq status: 'ok'

      ip_tracking_interval = IpTrackingInterval.last
      expect(ip_tracking_interval).not_to be_nil
      expect(ip_tracking_interval.since).not_to be_nil
      expect(ip_tracking_interval.till).not_to be_nil
    end

    it 'when not tracking' do
      delete '/api/v1/ip_availability/127.0.0.1/remove'

      expect(response.status).to eq(422)
      expect(response_body).to eq error: 'Not tracking 127.0.0.1'
    end

    it 'when interval is closed' do
      ip_tracking_interval = create :ip_tracking_interval, till: Time.current

      delete "/api/v1/ip_availability/#{ip_tracking_interval.ip}/remove"

      expect(response.status).to eq(422)
      expect(response_body).to eq error: "Not tracking #{ip_tracking_interval.ip}"
    end
  end
end
