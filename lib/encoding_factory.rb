require "base64"

class EncodingFactory
  def create encoding
    case encoding
      when /uu/i
        UuEncoding
      when /hex/i
        HexEncoding
      when /base64/i
        Base64Encoding
    end
  end
end

module UuEncoding
  extend self

  @@UU_ENCODED_STRING = "u"

  def encode result
    [result].pack(@@UU_ENCODED_STRING)
  end

  def decode encoded
    encoded.unpack(@@UU_ENCODED_STRING).first
  end
end

module HexEncoding
  extend self

  @@HEX_ENCODED_STRING = "H*"

  def encode result
    result.unpack(@@HEX_ENCODED_STRING).first.upcase
  end

  def decode encoded
    encoded.scan(/../).map {|x| x.hex.chr }.join
  end
end

module Base64Encoding
  extend self

  def encode result
    Base64.strict_encode64(result) # strict = no new line to match CF
  end

  def decode encoded
    Base64.decode64(encoded)
  end
end