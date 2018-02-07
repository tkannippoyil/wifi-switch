class ApplicationSerializer < ActiveModel::Serializer
  def serializable_object(options={})
    @context ||= {}
    api = get_api_context(options)

    @context[:exclude_for_api] = begin
      self.class::NOT_REQUIRED_FOR_API[api]
    rescue
      nil
    end

    @context[:exclude_with_condition] = get_exclude_with_condition_keys(api)

    super
  end

  def filter(keys)
    return keys unless context

    begin
      self.class::EXCLUDE_IF_NULL.each {|key|
        keys.delete key unless object.send(key).present?
      }
    rescue
    end

    [:exclude_for_api ,:exclude_with_condition].each { |keys_to_exclude|
      keys -= context[keys_to_exclude] if context[keys_to_exclude].present?
    }

    keys
  end

  def get_api_context(options)
    begin
      options[:context][:api]
    rescue
      nil
    end
  end

  def get_exclude_with_condition_keys(api)
    []
  end
end
