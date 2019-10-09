# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [0.5.0] - 2019-10-09

- Crystal 0.31.0 changed the behaviour of `Int#/` in favour of `Int#//` for integer division. This affected the base32 module, which no longer builds. Updated to point at a fork of base32 that does build in 0.31.0.

## [0.4.0] - 2019-08-18

### Changed

- Crystal 0.30.0 deprecated `URI.escape` in favour of `URI.encode_www_form`. Updated this to match the original behaviour (with `space_to_plus: false`).
- Crystal 0.28.0 deprecated `Time.now`. Updated to use `Time.utc` which is actually more correct according to the RFC.
- Crystal 0.29.0 deprecated the behaviour of `Int#/` to return integers. Changed to use `Int#//` instead.

## [0.3.0] - 2019-07-27

### Added

- Support and tests for TOTP with SHA256 and SHA512

### Fixed

- Crystal 0.28.0 changed the first argument for `OpenSSL::HMAC#digest` from a symbol to a type of `OpenSSL::Algorithm`. Updated this within the library thanks to [@Xosmond](https://github.com/Xosmond).

## [0.2.0] - 2019-03-28

### Fixed

- Crystal 0.27.0 changed `Time#epoch` to `Time#to_unix`, updated within the library thanks to [@Xosmond](https://github.com/Xosmond)

## [0.1.3] - 2018-05-27

### Added

- Added `authenticator_uri` to `HOTP` and `TOTP` objects to generate URIs for 2FA authenticator apps.
- Added `base32_secret` to both objects so that users who can't use the URI or QR code can copy the base32 secret to their authenticator app.

## [0.1.2] - 2018-05-26

### Added

- Added an `allowed_drift` to `verify` methods so that codes can be valid longer.

## [0.1.1] - 2017-01-10

### Changed

- Replaced implementation of `int_to_bytes` with `IO::ByteFormat::LittleEndian.encode` thanks to [@benoist](https://github.com/benoist)

## [0.1.0] - 2017-01-07

### Added

- Initial implementation of HOTP and TOTP.
