# CFMX_COMPAT

Ruby implementation of the CFMX_COMPAT algorithm within ColdFusion. This will allow you to encrypt and decrypt strings using the CFMX_COMPAT algorithm.

The ColdFusion `encrypt()` and `decrypt()` functions also encode the result after encryption and automatically decode before decryption. This gem applies the same encoding and decoding behaviours as ColdFusion.

- Base64: the Base64 algorithm, as specified by IETF RFC 2045.
- Hex: the characters A-F0-9 represent the hexadecimal byte values.
- UU: the UUEncode algorithm (DEFAULT).

The Ruby implementation here is translated from one [found](https://github.com/getrailo/railo/blob/f0da69a7ad62fe760e40d9cd880bdecfd38a51d7/railo-java/railo-core/src/railo/runtime/crypt/CFMXCompat.java) in Railo and a [C# implementation](http://stackoverflow.com/a/4627069) of that.

## Installation

Add this line to your application's Gemfile:

    gem 'cfmx_compat'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cfmx_compat

## Usage

In Ruby, using this gem:

```
key = "secretkey"
plain = "plain text value"

encrypted = CfmxCompat.encrypt(plain, key)
decrypted = CfmxCompat.decrypt(encrypted, key)
plain == decrypted # true

encrypted = CfmxCompat.encrypt(plain, key, "uu")
decrypted = CfmxCompat.decrypt(encrypted, key, "uu")
plain == decrypted # true

encrypted = CfmxCompat.encrypt(plain, key, "hex")
decrypted = CfmxCompat.decrypt(encrypted, key, "hex")
plain == decrypted # true

encrypted = CfmxCompat.encrypt(plain, key, "base64")
decrypted = CfmxCompat.decrypt(encrypted, key, "base64")
plain == decrypted # true
```

Is the same as this in ColdFusion:

```
<cfscript>
key = "secretkey";
plain = "plain text value";

encrypted = encrypt(plain, key);
decrypted = decrypt(encrypted, key);
decrypted == plain; # true

encrypted = encrypt(plain, key, "CFMX_COMPAT", "uu");
decrypted = decrypt(encrypted, key, "CFMX_COMPAT", "uu");
decrypted == plain; # true

encrypted = encrypt(plain, key, "CFMX_COMPAT", "hex");
decrypted = decrypt(encrypted, key, "CFMX_COMPAT", "hex");
decrypted == plain; # true

encrypted = encrypt(plain, key, "CFMX_COMPAT", "base64");
decrypted = decrypt(encrypted, key, "CFMX_COMPAT", "base64");
decrypted == plain; # true
</cfscript>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
