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

# Verify code at different time stamp, with allowed drift
result = totp.verify(token, at: 1484007299, allowed_drift: 1)
# => true

# Verify code at different time stamp, outside allowed drift
result = totp.verify(token, at: 1484007300, allowed_drift: 1)
# => false

# Authenticator URI
# See implementation details here: https://github.com/google/google-authenticator/wiki/Key-Uri-Format

# For HOTP you need the initial counter and an issuer
puts hotp.authenticator_uri(initial_counter: 0, issuer: "Test app")
# => otpauth://hotp/Test%20app?secret=ONSWG4TFOQ&algorithm=SHA1&counter=0&digits=6&issuer=Test%20app

# You can add a user account detail too, normally an email address or username, that shows up in the authenticator app
puts hotp.authenticator_uri(initial_counter: 0, issuer: "Test app", user: "philnash@example.com")
# => otpauth://hotp/Test%20app:philnash%40example.com?secret=ONSWG4TFOQ&algorithm=SHA1&counter=0&digits=6&issuer=Test%20app

# For TOTP you only need an issuer
puts totp.authenticator_uri(issuer: "Test app")
# => otpauth://totp/Test%20app?secret=ONSWG4TFOQ&algorithm=SHA1&period=30&digits=6&issuer=Test%20app

# You can add a user detail here too
puts totp.authenticator_uri(issuer: "Test app", user: "philnash@example.com")
# => otpauth://totp/Test%20app:philnash%40example.com?secret=ONSWG4TFOQ&algorithm=SHA1&period=30&digits=6&issuer=Test%20app

# Base 32 secret
# Google Authenticator, and thus other apps, require the secret in base 32 format. If your user needs to copy the secret, you can get the base 32 version from each HOTP and TOTP object.

puts hotp.base32_secret
# => ONSWG4TFOQ

puts totp.base32_secret
# => ONSWG4TFOQ
