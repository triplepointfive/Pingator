describe IpAvailability::Stats do
  describe 'GET /ip_availability/stats' do
    let(:since) { 1.hour.ago }
    let(:till) { 10.minutes.ago }
    let(:ip) { interval.ip }
    let(:interval) { create :ip_tracking_interval, since: since, till: till }

    it 'with data' do
      [19.679, 19.263, 19.464, 32.640, 16.555, 18.582, 15.706].shuffle.each do |rtt|
        create :ping, ip: ip, rtt: rtt, created_at: rand(since..till)
      end
      create_list :ping, 2, :lost, ip: ip, created_at: rand(since..till)

      get "/api/v1/ip_availability/#{ip}/stats/#{since.to_i}-#{till.to_i}"

      expect(response.status).to eq(200)
      expect(response_body).to eq(
        status: "ok",
        stats: {
          average: 20.27,
          minimum: 15.706,
          maximum: 32.64,
          median: 19.263,
          standard_deviation: 5.664,
          lost: 0.222
        }
      )
    end

    it 'all lost' do
      create_list :ping, 2, :lost, ip: ip, created_at: rand(since..till)

      get "/api/v1/ip_availability/#{ip}/stats/#{since.to_i}-#{till.to_i}"

      expect(response.status).to eq(200)
      expect(response_body).to eq(
        status: "ok",
        stats: {
          average: nil,
          minimum: nil,
          maximum: nil,
          median: nil,
          standard_deviation: nil,
          lost: 1.0
        }
      )
    end

    it 'without data' do
      get "/api/v1/ip_availability/#{ip}/stats/#{since.to_i}-#{till.to_i}"

      expect(response.status).to eq(422)
      expect(response_body).to eq error: "No data for IP #{ip} and interval #{since.to_i}-#{till.to_i}"
    end
  end
end
