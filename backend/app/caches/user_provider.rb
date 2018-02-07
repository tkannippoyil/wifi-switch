class UserProvider
  def get_user(user_id)
    begin
      user_json = $redis.get("user_#{user_id}")

      unless user_json.present?
        user_json = refresh_user(user_id)
      end

      user = JSON.parse(user_json)

      user
    rescue
      fetch_user(user_id)
    end
  end

  def refresh_user(user_id)
    user = fetch_user(user_id)

    user_json = user.to_json

    begin
      $redis.set("user_#{user.id}", user_json)
    rescue
    end

    user_json
  end

  def fetch_user(user_id)
    User.find(user_id)
  end
end
