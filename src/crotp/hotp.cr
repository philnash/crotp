module CrOTP
  class HOTP
    include CrOTP::OTP

    def initialize(@secret : String, @digits : Int = 6, @algorithm : OTP::Algorithm = OTP::Algorithm::SHA1)
    end

    def generate(counter : Int) : String
      generate_otp(counter)
    end

    def verify(token : String, counter : Int, allowed_drift : Int = 0) : Bool
      Array.new(allowed_drift+1) { |i| verify_otp(token, counter - i) }.any?
    end

    def authenticator_uri(initial_counter : Int, issuer : String, user : String) : String
      label = "#{URI.escape(issuer)}:#{URI.escape(user)}"
      build_authenticator_uri(initial_counter: initial_counter, issuer: issuer, label: label)
    end

    def authenticator_uri(initial_counter : Int, issuer : String) : String
      label = URI.escape(issuer)
      build_authenticator_uri(initial_counter: initial_counter, issuer: issuer, label: label)
    end

    private def build_authenticator_uri(initial_counter : Int, issuer : String, label : String) : String
      query =  "secret=#{base32_secret}"
      query += "&algorithm=#{@algorithm}"
      query += "&counter=#{initial_counter}"
      query += "&digits=#{@digits}"
      query += "&issuer=#{URI.escape(issuer)}"
      "otpauth://hotp/#{label}?#{query}"
    end
  end
end
