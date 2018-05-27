# CrOTP

The Crystal One Time Password library. Use this to generate HOTP or TOTP codes for two factor authentication.

[![Build Status](https://travis-ci.org/philnash/crotp.svg?branch=master)](https://travis-ci.org/philnash/crotp)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  crotp:
    github: philnash/crotp
```

## Usage

### HOTP

```crystal
require "crotp"

hotp = CrOTP::HOTP.new("secret")
counter = 1

# Generate a token
token = hotp.generate(counter)
# => "533881"

# Verify code
result = hotp.verify(token, counter)
# => true
```

### TOTP

```crystal
require "crotp"

totp = CrOTP::TOTP.new("secret")

# Generate a code at a specific time stamp (by default, #generate will make a
# code using Time.now)
token = totp.generate(at: 1484007247)
# => "020567"

# Verify code at a specific time stamp
result = totp.verify(token, at: 1484007247)
# => true

# Verify code at different time stamp, with allowed drift
result = totp.verify(token, at: 1484007299, allowed_drift: 1)
# => true

# Verify code at different time stamp, outside allowed drift
result = totp.verify(token, at: 1484007300, allowed_drift: 1)
# => false
```

### Authenticator applications

To share secrets with an authenticator application, like [Authy](https://authy.com/) or Google Authenticator you need a URI that you can share as a QR code. The [implementation details for the URI are in the Google Authenticator wiki](https://github.com/google/google-authenticator/wiki/Key-Uri-Format).

Here is how you can get the URI and, in case your user can't scan the code, the base 32 representation of the secret.

#### HOTP

```crystal
# For HOTP you need the initial counter and an issuer
puts hotp.authenticator_uri(initial_counter: 0, issuer: "Test app")
# => otpauth://hotp/Test%20app?secret=ONSWG4TFOQ&algorithm=SHA1&counter=0&digits=6&issuer=Test%20app

# You can add a user account detail too, normally an email address or username, that shows up in the authenticator app
puts hotp.authenticator_uri(initial_counter: 0, issuer: "Test app", user: "philnash@example.com")
# => otpauth://hotp/Test%20app:philnash%40example.com?secret=ONSWG4TFOQ&algorithm=SHA1&counter=0&digits=6&issuer=Test%20app
```

#### TOTP

```crystal
# For TOTP you only need an issuer
puts totp.authenticator_uri(issuer: "Test app")
# => otpauth://totp/Test%20app?secret=ONSWG4TFOQ&algorithm=SHA1&period=30&digits=6&issuer=Test%20app

# You can add a user detail here too
puts totp.authenticator_uri(issuer: "Test app", user: "philnash@example.com")
# => otpauth://totp/Test%20app:philnash%40example.com?secret=ONSWG4TFOQ&algorithm=SHA1&period=30&digits=6&issuer=Test%20app
```

#### Base 32 secret

```crystal
puts hotp.base32_secret
# => ONSWG4TFOQ

puts totp.base32_secret
# => ONSWG4TFOQ
```

You can see and run these examples and more in `example/crotp.cr`.

## Todo

- [x] Basic HOTP and TOTP generation and verification
- [x] Rewrite `int_to_bytes` and extract from `CrOTP::OTP`
- [x] Verifying a token over a window of counters/time
- [x] Google Authenticator otpauth URI generation
- [ ] Ability to choose algorithm (currently only sha1)
- [ ] Ability to choose size of period in TOTP
- [ ] Example application using Kemal
- [ ] Much more documentation

## Running the project locally

First clone the project:

```bash
git clone https://github.com/philnash/crotp.git
cd crotp
```

Run the tests with:

```bash
crystal spec
```

## Contributing

1. Fork it ( https://github.com/philnash/crotp/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [philnash](https://github.com/philnash) Phil Nash - creator, maintainer
- [benoist](https://github.com/benoist) Benoist Claassen
