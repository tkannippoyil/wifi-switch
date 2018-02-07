class ActionLoggerJob < ActiveJob::Base
  queue_as :action_logging_queue

  def perform(log_entry)
    Log.info log_entry
  end
end
