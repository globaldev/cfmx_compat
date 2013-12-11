require 'worker'

class CfmxCompat
  def self.encrypt(plaintext, key, encoding = 'uu')
    Worker.new(encoding, key).encrypt(plaintext)
  end

  def self.decrypt(ciphertext, key, encoding = 'uu')
    Worker.new(encoding, key).decrypt(ciphertext)
  end
end
