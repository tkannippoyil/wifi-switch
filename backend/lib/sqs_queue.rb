class SqsQueue
  def test_creation(test)
    if $queue.present?
      message = { type: test }
      $queue.send_message message.to_json
    end
  end
end
