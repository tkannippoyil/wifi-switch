class SchedulerJob < ActiveJob::Base
  queue_as :scheduler

  def perform
    Schedule.for_now.each do |schedule| 
      schedule.execute
      puts "Executed scheduler #{schedule.id}"
    end
  end
end
