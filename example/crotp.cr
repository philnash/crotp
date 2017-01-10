require "../src/crotp"

# HOTP
hotp = CrOTP::HOTP.new("secret")
counter = 1

# Generate a token
token = hotp.generate(counter)
puts token
# => "533881"

# Verify code
result = hotp.verify(token, counter)
puts result
# => true

# TOTP
totp = CrOTP::TOTP.new("secret")

# Generate a code at a specific time stamp (by default, #generate will make a
# code using `Time.now`)
token = totp.generate(at: 1484007247)
puts token
# => "020567"

# Verify code at a specific time stamp
result = totp.verify(token, at: 1484007247)
puts result
# => true

# Generate a code for now
token = totp.generate
puts token

# Verify the token from now
result = totp.verify(token)
puts result
