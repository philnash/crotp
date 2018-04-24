module CrOTP
  class TOTP
    include CrOTP::OTP

    def initialize(@secret : String, @digits : Int = 6)
    end

    def generate(at : Int = Time.now.epoch) : String
      counter = at / 30
      generate_otp(counter)
    end

    def generate(at : Time) : String
      generate(at.epoch)
    end

    def verify(token : String, at : Int = Time.now.epoch, allowed_drift : Int = 0) : Bool
      counter = at / 30
      Array.new(allowed_drift+1) { |i| verify_otp(token, counter - i) }.any?
    end

    def verify(token : String, at : Time, allowed_drift : Int = 0) : Bool
      verify(token, at.epoch, allowed_drift)
    end
  end
end
