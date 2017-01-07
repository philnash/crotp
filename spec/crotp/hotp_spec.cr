require "./../spec_helper"

describe CrOTP::HOTP do
  # Using data from Appendix D of RFC 4226
  # https://tools.ietf.org/html/rfc4226#page-32
  results = [
    "755224",
    "287082",
    "359152",
    "969429",
    "338314",
    "254676",
    "287922",
    "162583",
    "399871",
    "520489"
  ]
  secret = "12345678901234567890"
  hotp = CrOTP::HOTP.new(secret)

  describe "generate a token" do
    results.each_with_index do |result, counter|
      it "matches the RFC example for #{counter} counter" do
        hotp.generate(counter).should eq(result)
      end
    end
  end

  describe "verify the token" do
    results.each_with_index do |result, counter|
      it "verifies the RFC example for the result at #{counter}" do
        hotp.verify(result, counter).should be_true
      end

      it "does not verify the RFC example for the result with counter #{counter} + 1" do
        hotp.verify(result, counter + 1).should be_false
      end
    end
  end
end
