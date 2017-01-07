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

    def verify(token : String, at : Int = Time.now.epoch) : Bool
      counter = at / 30
      verify_otp(token, counter)
    end

    def verify(token : String, at : Time) : Bool
      verify(token, at.epoch)
    end
  end
end
