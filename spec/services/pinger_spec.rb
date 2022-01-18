describe Pinger do
  let(:pinger) { described_class.new }
  let(:ip) { '8.8.8.8' }
  let(:rtt) { 0.1234 }

  it 'listen subscribes to queue' do
    expect(pinger.queue).to receive(:subscribe)

    pinger.listen
  end

  it 'stars and stops pinging' do
    expect_any_instance_of(Net::Ping::External).to receive(:ping).once
    expect_any_instance_of(Net::Ping::External).to receive(:duration).once.and_return(rtt)

    pinger.process(event: 'start', ip: ip)
    sleep Settings.pinger.frequency / 2

    pinger.process(event: 'stop', ip: ip)
    sleep Settings.pinger.frequency * 2

    ping = Ping.last
    expect(ping).not_to be_nil
    expect(ping.ip).to eq ip
    expect(ping.rtt).to eq rtt
  end
end
