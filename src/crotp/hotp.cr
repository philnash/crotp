module CrOTP
  class HOTP
    include CrOTP::OTP

    def initialize(@secret : String, @digits : Int = 6)
    end

    def generate(counter : Int) : String
      generate_otp(counter)
    end

    def verify(token : String, counter : Int, allowed_drift : Int = 0) : Bool
      Array.new(allowed_drift+1) { |i| verify_otp(token, counter - i) }.any?
    end
  end
end
