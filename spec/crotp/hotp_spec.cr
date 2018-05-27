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
    "520489",
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

      it "does verify the RFC example for the result with counter #{counter} + 1 and an allowed drift of 1" do
        hotp.verify(result, counter + 1, allowed_drift: 1).should be_true
      end
    end
  end

  describe "generate a authenticator app URI" do
    hotp = CrOTP::HOTP.new(secret)

    it "can show the secret in base 32" do
      hotp.base32_secret.should eq("GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ")
    end

    describe "with just an issuer and initial counter" do
      url = hotp.authenticator_uri(initial_counter: 0, issuer: "Test label")

      it "makes a label and issuer parameter out of the issuer" do
        url.should match(/\Aotpauth:\/\/hotp\/Test%20label/)
        url.should match(/issuer=Test%20label/)
      end

      it "base32 encodes the secret as a parameter" do
        url.should match(/secret=GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ/)
      end

      it "sets the counter parameter" do
        url.should match(/counter=0/)
      end

      it "sets the other parameters" do
        url.should match(/digits=6/)
        url.should match(/algorithm=SHA1/)
      end
    end

    describe "with an issuer and a user" do
      url = hotp.authenticator_uri(initial_counter: 0, issuer: "Test label", user: "philnash@example.com")

      it "generates label from both issuer and user" do
        url.should match(/\Aotpauth:\/\/hotp\/Test%20label:philnash%40example.com/)
      end

      it "just uses the issuer as a parameter" do
        url.should match(/issuer=Test%20label/)
      end
    end
  end
end
