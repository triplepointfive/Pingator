class Pinger
  extend Dry::Initializer
  include BunnyConnection

  param :logger, default: -> { Rails.logger }

  def start_tracking(ip)
    exchange.publish({ event: 'start', ip: ip }.to_json)
    bunny_close!
  end

  def stop_tracking(ip)
    exchange.publish({ event: 'stop', ip: ip }.to_json)
    bunny_close!
  end

  def listen
    queue.bind(exchange)

    logger.info 'Start listening'

    queue.subscribe(block: true) do |_, _, body|
      process(JSON.parse(body, symbolize_names: true))

      logger.info "Processed #{body}"
    end
  rescue Interrupt
  ensure
    bunny_close!
  end

  def process(event:, ip:)
    case event
    when 'start'
      start_pinging(ip)
    when 'stop'
      stop_pinging(ip)
    end
  end

  def start_pinging(ip)
    return if workers[ip]

    pinger = Net::Ping::External.new(ip, Settings.pinger.port, Settings.pinger.timeout)
    task = Concurrent::TimerTask.new(run_now: true, execution_interval: Settings.pinger.frequency) do
      logger.info "start #{ip}"

      if pinger.ping
        logger.info "done  #{ip} #{pinger.duration}"
      else
        logger.info "lost  #{ip}"
      end

      Ping.create!(ip: ip, rtt: pinger.duration)
    end
    task.execute

    workers[ip] = task
  end

  def stop_pinging(ip)
    return unless workers[ip]

    workers[ip].kill
    workers.delete(ip)
  end

  def exchange
    @exchange ||= channel.direct('pinger')
  end

  def queue
    @queue ||= channel.queue('', exclusive: true)
  end

  def workers
    @workers ||= Concurrent::Hash.new
  end
end
