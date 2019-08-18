module CrOTP
  class TOTP
    PERIOD = 30

    include CrOTP::OTP

    ALLOWED_ALGORITHMS = [OpenSSL::Algorithm::SHA1, OpenSSL::Algorithm::SHA256, OpenSSL::Algorithm::SHA512]

    def initialize(@secret : String, @digits : Int = 6, @algorithm : OpenSSL::Algorithm = OpenSSL::Algorithm::SHA1)
      if !ALLOWED_ALGORITHMS.includes?(@algorithm)
        raise CrOTP::OTP::InvalidAlgorithmError.new("TOTP only allows for using SHA1, SHA256 or SHA512")
      end
    end

    def generate(at : Int = Time.utc.to_unix) : String
      counter = at // PERIOD
      generate_otp(counter)
    end

    def generate(at : Time) : String
      generate(at.to_unix)
    end

    def verify(token : String, at : Int = Time.utc.to_unix, allowed_drift : Int = 0) : Bool
      counter = at // PERIOD
      Array.new(allowed_drift + 1) { |i| verify_otp(token, counter - i) }.any?
    end

    def verify(token : String, at : Time, allowed_drift : Int = 0) : Bool
      verify(token, at.to_unix, allowed_drift)
    end

    def authenticator_uri(issuer : String, user : String) : String
      label = "#{escape(issuer)}:#{escape(user)}"
      build_authenticator_uri(issuer: issuer, label: label)
    end

    def authenticator_uri(issuer : String) : String
      label = escape(issuer)
      build_authenticator_uri(issuer: issuer, label: label)
    end

    private def build_authenticator_uri(issuer : String, label : String) : String
      query = "secret=#{base32_secret}"
      query += "&algorithm=#{@algorithm}"
      query += "&period=#{PERIOD}"
      query += "&digits=#{@digits}"
      query += "&issuer=#{escape(issuer)}"
      "otpauth://totp/#{label}?#{query}"
    end
  end
end
