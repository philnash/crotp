# CrOTP

The Crystal One Time Password library.

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
```

You can see and run these examples and more in `example/crotp.cr`.

## Todo

- [x] Basic HOTP and TOTP generation and verification
- [x] Rewrite `int_to_bytes` and extract from `CrOTP::OTP`
- [ ] Verifying a token over a window of counters/time
- [ ] Google Authenticator otpauth URI generation
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
