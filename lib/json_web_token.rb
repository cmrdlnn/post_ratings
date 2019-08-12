# frozen_string_literal: true

require 'jwt'

module JSONWebToken
  class << self
    def encode(payload, *args)
      supplemented_payload = meta.merge(payload)
      JWT.encode(supplemented_payload, secret, *args)
    end

    def decode(token, *args)
      JWT.decode(token, secret, *args)
    end

    private

    def meta
      {
        iat: Time.now.to_i,
      }
    end

    def secret
      Rails.application.credentials.secret_key_base
    end
  end
end
