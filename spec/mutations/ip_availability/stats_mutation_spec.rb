describe IpAvailability::StatsMutation do
  let(:since) { 1.hour.ago }
  let(:till) { 10.minutes.ago }
  let(:ip) { interval.ip.to_s }
  let(:interval) { create :ip_tracking_interval, since: since, till: till }

  let(:outcome) { described_class.run(ip: ip, since: since, till: till) }

  it 'all lost' do
    create_list :ping, 2, :lost, ip: ip, created_at: rand(since..till)

    expect(outcome).to be_success
    expect(outcome.result).to eq(
      average: nil,
      minimum: nil,
      maximum: nil,
      median: nil,
      standard_deviation: nil,
      lost: 1.0
    )
  end

  it 'single ping' do
    create :ping, ip: ip, rtt: 19.679, created_at: rand(since..till)

    expect(outcome).to be_success
    expect(outcome.result).to eq(
      average: 19.679,
      lost: 0.0,
      maximum: 19.679,
      median: 19.679,
      minimum: 19.679,
      standard_deviation: nil,
    )
  end

  it 'counts correctly' do
    [19.679, 19.263, 19.464, 32.640, 16.555, 18.582, 15.706].shuffle.each do |rtt|
      create :ping, ip: ip, rtt: rtt, created_at: rand(since..till)
    end
    create_list :ping, 2, :lost, ip: ip, created_at: rand(since..till)

    expect(outcome).to be_success
    expect(outcome.result).to eq(
      average: 20.27,
      minimum: 15.706,
      maximum: 32.64,
      median: 19.263,
      standard_deviation: 5.664,
      lost: 0.222
    )
  end
end
