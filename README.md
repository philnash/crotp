# CrOTP

The Crystal One Time Password library.

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

# Generate a code
hotp.generate(counter)
# => "423748"

# Verify code
hotp.verify(token, counter)
# => true
```

### TOTP

```crystal
require "crotp"

totp = CrOTP::TOTP.new("secret")

# Generate a code
totp.generate
# => "423748"

# Generate a code at a specific time stamp
totp.generate(at: 3.minutes.ago)
# => "923832"

# Verify code (verifies against the current time)
totp.verify(token)
# => true

# Verify code at a specific time stamp
totp.verify(token, at: 3.minutes.ago)
# => true

```

## Todo

- [x] Basic HOTP and TOTP generation and verification
- [ ] Rewrite `int_to_bytes` and extract from `CrOTP::OTP`
- [ ] Verifying a token over a window of counters/time
- [ ] Google Authenticator otpauth URI generation
- [ ] Ability to choose algorithm (currently only sha1)
- [ ] Ability to choose size of period in TOTP

## Contributing

1. Fork it ( https://github.com/philnash/crotp/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [philnash](https://github.com/philnash) Phil Nash - creator, maintainer
