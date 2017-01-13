require "openssl/hmac"
require "crypto/subtle"

module CrOTP
  module OTP
    private def generate_otp(counter : Int) : String
      IO::ByteFormat::LittleEndian.encode(counter, bytes = Bytes.new(8))
      digest = OpenSSL::HMAC.digest(:sha1, @secret, bytes.reverse!)
      truncated = truncate(digest)
      (truncated % 10**@digits).to_s.rjust(@digits, '0')
    end

    private def truncate(hmac : Bytes)
      offset = (hmac[-1] & 0xf)
      code = (hmac[offset].to_i & 0x7f) << 24 |
             (hmac[offset + 1].to_i & 0xff) << 16 |
             (hmac[offset + 2].to_i & 0xff) << 8 |
             (hmac[offset + 3].to_i & 0xff)
    end

    private def verify_otp(token : String, counter : Int)
      otp = generate_otp(counter)
      Crypto::Subtle.constant_time_compare(otp, token)
    end
  end
end
