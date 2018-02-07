class Log < ActiveRecord::Base
  # Relationships
  belongs_to :user

  # Validations
  validates :category, presence: true
  validates :level, presence: true
  validates :message, presence: true

  def self.debug(values={})
    add_entry('debug', values)
  end

  def self.info(values={})
    add_entry('info', values)
  end

  def self.warn(values={})
    add_entry('warn', values)
  end

  def self.error(values={})
    add_entry('error', values)
  end

  def self.fatal(values={})
    add_entry('fatal', values)
  end

  private

  def self.add_entry(level, values={})
    values[:level]         ||= level
    values[:category]      ||= ''
    values[:message]       ||= ''
    values[:controller]    ||= ''
    values[:user_id]       ||= nil
    values[:action]        ||= ''
    values[:data]          ||= {}
    values[:notes]         ||= ''

    values[:data] = values[:data].to_json

    begin
      Resque.enqueue(ActionLogger, values)
    rescue Redis::CannotConnectError # Just dump it to the DB if Redis not running
      create values
    end
  end
end
