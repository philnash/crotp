require "openssl/hmac"
require "crypto/subtle"

module CrOTP
  module OTP
    private def generate_otp(counter : Int) : String
      digest = OpenSSL::HMAC.digest(:sha1, @secret, int_to_bytes(counter))
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

    # Implementation inspired by this conversation: https://groups.google.com/forum/#!topic/crystal-lang/KbdUXgoFYR4.
    # Probably best to rewrite in a version that will produce the same order
    # regardless of the underlying operating system.
    private def int_to_bytes(integer : Int64)
      pointer = pointerof(integer).as({UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8}*)
      tuple = pointer.value
      Slice.new(8) { |i| tuple[i] }.reverse!
    end

    private def int_to_bytes(integer : Int32)
      pointer = pointerof(integer).as({UInt8, UInt8, UInt8, UInt8}*)
      tuple = pointer.value
      Slice.new(8) { |i| tuple[i]? || 0_u8 }.reverse!
    end

    private def int_to_bytes(integer : Int16)
      pointer = pointerof(integer).as({UInt8, UInt8}*)
      tuple = pointer.value
      Slice.new(8) { |i| tuple[i]? || 0_u8 }.reverse!
    end

    private def int_to_bytes(integer : Int8)
      pointer = pointerof(integer).as({UInt8}*)
      tuple = pointer.value
      Slice.new(8) { |i| tuple[i]? || 0_u8 }.reverse!
    end

    private def int_to_bytes(integer : UInt64)
      pointer = pointerof(integer).as({UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8}*)
      tuple = pointer.value
      Slice.new(8) { |i| tuple[i]? || 0_u8 }.reverse!
    end

    private def int_to_bytes(integer : UInt32)
      pointer = pointerof(integer).as({UInt8, UInt8, UInt8, UInt8}*)
      tuple = pointer.value
      Slice.new(8) { |i| tuple[i]? || 0_u8 }.reverse!
    end

    private def int_to_bytes(integer : UInt16)
      pointer = pointerof(integer).as({UInt8, UInt8}*)
      tuple = pointer.value
      Slice.new(8) { |i| tuple[i]? || 0_u8 }.reverse!
    end

    private def int_to_bytes(integer : UInt8)
      Slice.new(8) { |i| tuple[i]? || 0_u8 }.reverse!
    end
  end
end
