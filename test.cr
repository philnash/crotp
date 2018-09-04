require "./src/crotp"

secret = "HELLO"
totp = CrOTP::TOTP.new(secret)
# token = totp.generate()
# sleep(30)
# puts totp.verify(token)
# # => false
# puts totp.verify(token, allowed_drift: 1)


# Generate a code at a specific time stamp (by default, #generate will make a
# code using Time.now)
token = totp.generate(at: 1484007247)
# => "020567"

# Verify code at a specific time stamp
puts totp.verify(token, at: 1484007247)
# => true

# Verify code at different time stamp, with allowed drift
puts totp.verify(token, at: 1484007300, allowed_drift: 1)

puts totp.authenticator_uri(issuer: "Phil")
puts totp.generate