class Mqtt
  def initialize()
  end

  def get_path(file)
    File.join(Rails.root, "lib/aws/#{file}")
  end

  def publish(topic, message)
    client.publish(topic, message, retain=false, qos=1)
  end

  def subscribe(topic)
    client.subscribe(topic)

    client.get do |topic, message|
      puts topic, message
    end
  end

  def listen_to_devices
    puts 'listening...'
    client.subscribe('stat/#')

    client.get do |topic, message|
      device_id, action = topic.split('/')[1..2]
      @device = Device.find_or_create_by(address: device_id)

      if action == 'RESULT'
        message = JSON.parse message

        case message['POWER']
          when 'ON'
            @device.turn_on
            print 'Turned on. '
          when 'OFF'
            @device.turn_off
            print 'Turned off. '
          else
            nil
        end
      end

      puts "#{topic} => #{message}"
    end
  end

  def reconnect
    connect
  end

  def client
    connect if @client.nil?
    @client
  end

  def turn_on_device(address)
    publish "cmnd/#{address}/Power", 'ON'
  end

  def turn_off_device(address)
    publish "cmnd/#{address}/Power", 'OFF'
  end

  def connect_ssl
    @client = MQTT::Client.connect(
        host: 'a2oy2r1tr1f4ip.iot.us-west-2.amazonaws.com',
        port: 8883,
        ssl: true,
        client_id: "rails_#{'%09d' % rand(10 ** 9)}",
        cert_file: get_path('certificate.pem.crt'),
        key_file: get_path('private.pem.key'),
        ca_file: get_path('ca.pem')
    )
  end

  def connect
    @client = MQTT::Client.connect(
        'localhost', 1883
    )
  end

  def custom
    MQTT::Packet.parse('binary_packet')
  end
end
