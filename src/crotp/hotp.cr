module CrOTP
  class HOTP
    include CrOTP::OTP

    def initialize(@secret : String, @digits : Int = 6)
    end

    def generate(counter : Int) : String
      generate_otp(counter)
    end

    def verify(token : String, counter : Int) : Bool
      verify_otp(token, counter)
    end
  end
end
