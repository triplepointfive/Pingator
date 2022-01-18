module BunnyConnection
  extend self

  def new
    Bunny.new(ENV['AMQP_URL'] || Settings.rabbitmq.to_hash)
  end

  def current
    @bunny_connection ||= (Rails.env.test? ? BunnyMock.new : new).start
  end

  def channel
    @bunny_channel ||= current.create_channel
  end

  def bunny_close!
    [@bunny_channel, @bunny_connection].compact.each do |bunny_var|
      bunny_var.close
    end
  end

  def bunny_connection_established?
    begin
      return true if Rails.env.test?
      current.start
      current.close
      true
    rescue Bunny::TCPConnectionFailed => e
      Rails.logger.error "Connection failed #{e}"
      false
    end
  end
end
