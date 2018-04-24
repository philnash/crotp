require "./../spec_helper"

describe CrOTP::TOTP do
  # Using data from Appendix B of RFC 6238
  # https://tools.ietf.org/html/rfc6238#appendix-B
  results = [
    { 59, "94287082" },
    { 1111111109, "07081804" },
    { 1111111111, "14050471" },
    { 1234567890, "89005924" },
    { 2000000000, "69279037" },
    { 20000000000, "65353130" },
  ]
  secret = "12345678901234567890"

  describe "generate a token" do
    results.each do |(time, result)|
      it "matches the RFC example at #{time}" do
        totp = CrOTP::TOTP.new(secret)
        totp.generate(at: time).should eq(result[2, 6])
      end
    end

    results.each do |(time, result)|
      it "matches the RFC example at #{time} for 8 digits" do
        totp = CrOTP::TOTP.new(secret, digits = 8)
        totp.generate(at: time).should eq(result)
      end
    end
  end

  describe "verify a token" do
    totp = CrOTP::TOTP.new(secret)

    it "verifies the current time" do
      totp.verify(totp.generate(), at: Time.now)
    end

    results.each do |(time,result)|
      it "verifies the RFC example for the result at time #{time}" do
        totp.verify(result[2, 6], at: time).should be_true
      end

      it "does not verify the RFC example for the result with time #{time} + 1 minute" do
        totp.verify(result[2, 6], at: time + 60).should be_false
      end

      it "verifies the example with time #{time} + 1 minute and an allowed drift of 2" do
        totp.verify(result[2,6], at: time + 60, allowed_drift: 2).should be_true
      end
    end
  end
end
