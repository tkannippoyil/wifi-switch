class Device < ApplicationRecord

  after_create :set_name

  has_many :schedules

  def set_name
    self.name = "Device #{id}"
    save
  end

  def self.turn_on_all
    all.map &:request_turn_on
  end

  def self.turn_off_all
    all.map &:request_turn_off
  end

  def self.toggle_all
    all.map &:toggle
  end

  def request_turn_on
    self.connected = true
    self.processing = true
    save

    Mqtt.new.turn_on_device(address)
  end

  def turn_on
    self.status = true
    self.connected = true
    self.processing = false
    save
  end

  def request_turn_off
    self.connected = true
    self.processing = true
    save

    Mqtt.new.turn_off_device(address)
  end

  def turn_off
    self.status = false
    self.connected = true
    self.processing = false
    save
  end

  def restart
    request_turn_off
    sleep 1
    request_turn_on
  end

  def toggle
    turned_on? ? request_turn_off : request_turn_on
  end

  def turned_on?
    status == true
  end

  def disconnected?
    processing && (Time.now - updated_at > 15.seconds)
  end

  def check_connectivity!
    self.connected = !disconnected?

    self.processing = false unless connected

    save
  end
end
