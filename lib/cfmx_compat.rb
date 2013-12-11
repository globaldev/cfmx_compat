require "base64"

class CfmxCompat
  def self.encrypt(string, key, encoding = "uu")
    Worker.new.encrypt(string, key, encoding)
  end

  def self.decrypt(encoded, key, encoding = "uu")
    Worker.new.decrypt(encoded, key, encoding)
  end
end

class Worker
  M_MASK_A = 0x80000062
  M_MASK_B = 0x40000020
  M_MASK_C = 0x10000002
  M_ROT0_A = 0x7fffffff
  M_ROT0_B = 0x3fffffff
  M_ROT0_C = 0xfffffff
  M_ROT1_A = 0x80000000
  M_ROT1_B = 0xc0000000
  M_ROT1_C = 0xf0000000

  UNSIGNED_CHAR = "C*"
  UU_ENCODED_STRING = "u"
  HEX_ENCODED_STRING = "H*"

  def encrypt(string, key, encoding = "uu")
    encode(transform_string(string || "", key), encoding)
  end

  def decrypt(encoded, key, encoding = "uu")
    transform_string(decode(encoded || "", encoding), key)
  end

private

  def encode(result, encoding)
    case encoding.downcase.to_s
    when "uu" then
      [result].pack(UU_ENCODED_STRING)
    when "hex" then
      result.unpack(HEX_ENCODED_STRING).first.upcase
    when "base64"
      Base64.strict_encode64(result) # strict = no new line to match CF.
    else
      raise ArgumentError, "Invalid CfmxCompat encoding option: '#{encoding}' (Expected UU, HEX, or BASE64)"
    end
  end

  def decode(encoded, encoding)
    case encoding.downcase.to_s
    when "uu" then
      encoded.unpack(UU_ENCODED_STRING).first
    when "hex" then
      encoded.scan(/../).map {|x| x.hex.chr }.join
    when "base64" then
      Base64.decode64(encoded)
    else
      raise ArgumentError, "Invalid CfmxCompat decoding option: '#{encoding}' (Expected UU, HEX, or BASE64)"
    end
  end

  def transform_string(string, key)
    raise ArgumentError, "CfmxCompat a key must be specified for encryption or decryption" unless key && key.length > 0
    return "" unless string && string.length > 0

    @m_LFSR_A = 0x13579bdf
    @m_LFSR_B = 0x2468ace0
    @m_LFSR_C = 0xfdb97531
    seed_from_key(key)

    string.bytes.map {|byte| transform_byte(byte) }.pack(UNSIGNED_CHAR)
  end

  def transform_byte(target)
    crypto = 0
    b = @m_LFSR_B & 1
    c = @m_LFSR_C & 1

    8.times do
      if @m_LFSR_A & 1 != 0
        @m_LFSR_A = @m_LFSR_A ^ M_MASK_A >> 1 | M_ROT1_A

        if @m_LFSR_B & 1 != 0
          @m_LFSR_B = @m_LFSR_B ^ M_MASK_B >> 1 | M_ROT1_B
          b = 1
        else
          @m_LFSR_B = @m_LFSR_B >> 1 & M_ROT0_B
          b = 0
        end
      else
        @m_LFSR_A = @m_LFSR_A >> 1 & M_ROT0_A
        if @m_LFSR_C & 1 != 0
          @m_LFSR_C = @m_LFSR_C ^ M_MASK_C >> 1 | M_ROT1_C
          c = 1
        else
          @m_LFSR_C = @m_LFSR_C >> 1 & M_ROT0_C
          c = 0
        end
      end
      crypto = crypto << 1 | b ^ c
    end
    target ^ crypto
  end

  def seed_from_key(key)
    doublekey = (key * 2).bytes.to_a
    seed = Array.new(12) {|i| doublekey[i] || 0 }

    4.times do |i|
      @m_LFSR_A = (@m_LFSR_A << 8) | seed[i+4]
      @m_LFSR_B = (@m_LFSR_B << 8) | seed[i+4]
      @m_LFSR_C = (@m_LFSR_C << 8) | seed[i+4]
    end

    @m_LFSR_A = 0x13579bdf if @m_LFSR_A.zero?
    @m_LFSR_B = 0x2468ace0 if @m_LFSR_B.zero?
    @m_LFSR_C = 0xfdb97531 if @m_LFSR_C.zero?
  end
end
