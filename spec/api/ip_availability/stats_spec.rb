describe IpAvailability::Stats do
  describe 'GET /ip_availability/stats' do
    let(:since) { 1.hour.ago }
    let(:till) { 10.minutes.ago }
    let(:ip) { interval.ip }
    let(:interval) { create :ip_tracking_interval, since: since, till: till }

    it 'with data' do
      create :ping, ip: ip, rtt: 19.679, created_at: rand(since..till)
      create :ping, :lost, ip: ip, created_at: rand(since..till)

      get "/api/v1/ip_availability/#{ip}/stats/#{since.to_i}-#{till.to_i}"

      expect(response.status).to eq(200)
      expect(response_body).to eq(
        status: "ok",
        result: {
          average: 19.679,
          lost: 0.5,
          maximum: 19.679,
          median: 19.679,
          minimum: 19.679,
          standard_deviation: nil,
        }
      )
    end

    it 'without data' do
      get "/api/v1/ip_availability/#{ip}/stats/#{since.to_i}-#{till.to_i}"

      expect(response.status).to eq(422)
      expect(response_body).to eq(
        status: "error",
        error: { base: "No data for IP #{ip} and interval #{since.to_i}-#{till.to_i}" },
      )
    end
  end
end
