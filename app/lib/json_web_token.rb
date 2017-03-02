class JsonWebToken
  def self.encode(payload)
    payload.reverse_merge!(meta)
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base)
  end

  def self.valid_payload(payload)
    in_time?(payload) &&
      payload_matches?(payload, :iss) &&
      payload_matches?(payload, :aud)
  end

  def self.in_time?(payload)
    value = payload[:exp].to_i
    payload_time = Time.zone.at(value)
    now = Time.zone.now
    now < payload_time
  end

  def self.meta
    {
      exp: 7.days.from_now.to_i,
      iss: 'issuer_name',
      aud: 'client'
    }
  end

  def self.payload_matches?(payload, claim)
    payload[claim] == meta[claim]
  end
end
