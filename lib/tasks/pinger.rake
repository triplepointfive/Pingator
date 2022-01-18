task pinger: :environment do
  Pinger.new(Logger.new($stdout)).listen
end
