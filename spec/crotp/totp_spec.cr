require "./../spec_helper"

describe CrOTP::TOTP do
  # Using data from Appendix B of RFC 6238
  # https://tools.ietf.org/html/rfc6238#appendix-B
  results = {
    :sha1 => [
      {59, "94287082"},
      {1111111109, "07081804"},
      {1111111111, "14050471"},
      {1234567890, "89005924"},
      {2000000000, "69279037"},
      {20000000000, "65353130"},
    ],
    :sha256 => [
      {59, "32247374"},
      {1111111109, "34756375"},
      {1111111111, "74584430"},
      {1234567890, "42829826"},
      {2000000000, "78428693"},
      {20000000000, "24142410"},
    ],
    :sha512 => [
      {59, "69342147"},
      {1111111109, "63049338"},
      {1111111111, "54380122"},
      {1234567890, "76671578"},
      {2000000000, "56464532"},
      {20000000000, "69481994"},
    ],
  }
  secret = "12345678901234567890"

  describe "generate a token" do
    describe "with sha1 algorithm" do
      results[:sha1].each do |(time, result)|
        it "matches the RFC example at #{time}" do
          totp = CrOTP::TOTP.new(secret)
          totp.generate(at: time).should eq(result[2, 6])
        end

        it "matches the RFC example at #{time} for 8 digits" do
          totp = CrOTP::TOTP.new(secret, digits = 8)
          totp.generate(at: time).should eq(result)
        end
      end
    end

    describe "with sha256 algorithm" do
      results[:sha256].each do |(time, result)|
        it "matches the RFC example at #{time}" do
          totp = CrOTP::TOTP.new(secret, algorithm: OpenSSL::Algorithm::SHA256)
          totp.generate(at: time).should eq(result[2, 6])
        end

        it "matches the RFC example at #{time} for 8 digits" do
          totp = CrOTP::TOTP.new(secret, digits = 8, algorithm: OpenSSL::Algorithm::SHA256)
          totp.generate(at: time).should eq(result)
        end
      end
    end

    describe "with sha512 algorithm" do
      results[:sha512].each do |(time, result)|
        it "matches the RFC example at #{time}" do
          totp = CrOTP::TOTP.new(secret, algorithm: OpenSSL::Algorithm::SHA512)
          totp.generate(at: time).should eq(result[2, 6])
        end

        it "matches the RFC example at #{time} for 8 digits" do
          totp = CrOTP::TOTP.new(secret, digits = 8, algorithm: OpenSSL::Algorithm::SHA512)
          totp.generate(at: time).should eq(result)
        end
      end
    end
    describe "with an incorrect algorithm" do
      it "throws an InvalidAlgorithmError" do
        expect_raises(CrOTP::OTP::InvalidAlgorithmError) {
          totp = CrOTP::TOTP.new(secret, algorithm: OpenSSL::Algorithm::MD5)
        }
      end
    end
  end

  describe "verify a token" do
    describe "with sha1 algorithm" do
      totp = CrOTP::TOTP.new(secret)

      it "verifies the current time" do
        totp.verify(totp.generate, at: Time.now).should be_true
      end

      results[:sha1].each do |(time, result)|
        it "verifies the RFC example for the result at time #{time}" do
          totp.verify(result[2, 6], at: time).should be_true
        end

        it "does not verify the RFC example for the result with time #{time} + 1 minute" do
          totp.verify(result[2, 6], at: time + 60).should be_false
        end

        it "verifies the example with time #{time} + 1 minute and an allowed drift of 2" do
          totp.verify(result[2, 6], at: time + 60, allowed_drift: 2).should be_true
        end
      end
    end

    describe "with sha256 algorithm" do
      totp = CrOTP::TOTP.new(secret, algorithm: OpenSSL::Algorithm::SHA256)

      it "verifies the current time" do
        totp.verify(totp.generate, at: Time.now).should be_true
      end

      results[:sha256].each do |(time, result)|
        it "verifies the RFC example for the result at time #{time}" do
          totp.verify(result[2, 6], at: time).should be_true
        end

        it "does not verify the RFC example for the result with time #{time} + 1 minute" do
          totp.verify(result[2, 6], at: time + 60).should be_false
        end

        it "verifies the example with time #{time} + 1 minute and an allowed drift of 2" do
          totp.verify(result[2, 6], at: time + 60, allowed_drift: 2).should be_true
        end
      end
    end

    describe "with sha512 algorithm" do
      totp = CrOTP::TOTP.new(secret, algorithm: OpenSSL::Algorithm::SHA512)

      it "verifies the current time" do
        totp.verify(totp.generate, at: Time.now).should be_true
      end

      results[:sha512].each do |(time, result)|
        it "verifies the RFC example for the result at time #{time}" do
          totp.verify(result[2, 6], at: time).should be_true
        end

        it "does not verify the RFC example for the result with time #{time} + 1 minute" do
          totp.verify(result[2, 6], at: time + 60).should be_false
        end

        it "verifies the example with time #{time} + 1 minute and an allowed drift of 2" do
          totp.verify(result[2, 6], at: time + 60, allowed_drift: 2).should be_true
        end
      end
    end
  end

  describe "generate a authenticator app URI" do
    totp = CrOTP::TOTP.new(secret)

    it "can show the secret in base 32" do
      totp.base32_secret.should eq("GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ")
    end

    describe "with just an issuer" do
      url = totp.authenticator_uri(issuer: "Test label")

      it "makes a label and issuer parameter out of the issuer" do
        url.should match(/\Aotpauth:\/\/totp\/Test%20label/)
        url.should match(/issuer=Test%20label/)
      end

      it "base32 encodes the secret as a parameter" do
        url.should match(/secret=GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ/)
      end

      it "sets the other parameters" do
        url.should match(/digits=6/)
        url.should match(/period=30/)
        url.should match(/algorithm=SHA1/)
      end
    end

    describe "with an issuer and a user" do
      url = totp.authenticator_uri(issuer: "Test label", user: "philnash@example.com")

      it "generates label from both issuer and user" do
        url.should match(/\Aotpauth:\/\/totp\/Test%20label:philnash%40example.com/)
      end

      it "just uses the issuer as a parameter" do
        url.should match(/issuer=Test%20label/)
      end

      it "includes the algorithm" do
        url.should match(/algorithm=SHA1/)
      end
    end

    describe "with an issuer, user and algorithm" do
      totp = CrOTP::TOTP.new(secret, algorithm: OpenSSL::Algorithm::SHA256)

      url = totp.authenticator_uri(issuer: "Test label", user: "philnash@example.com")

      it "generates label from both issuer and user" do
        url.should match(/\Aotpauth:\/\/totp\/Test%20label:philnash%40example.com/)
      end

      it "just uses the issuer as a parameter" do
        url.should match(/issuer=Test%20label/)
      end

      it "includes the algorithm" do
        url.should match(/algorithm=SHA256/)
      end
    end
  end
end
