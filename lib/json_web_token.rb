class JsonWebToken
    # Secret key to encode and decode the token
    HMAC_SECRET = Rails.application.secrets.secret_key_base
    
    def self.encode(payload, exp = 24.hours.from_now)
      # Set the expiration time for the token
      payload[:exp] = exp.to_i
      
      # Encode the payload with the secret key
      JWT.encode(payload, HMAC_SECRET)
    end
    
    def self.decode(token)
      # Decode the token using the secret key
      decoded = JWT.decode(token, HMAC_SECRET)[0]
      HashWithIndifferentAccess.new(decoded)
    rescue JWT::DecodeError => e
      raise ExceptionHandler::InvalidToken, e.message
    end
  end