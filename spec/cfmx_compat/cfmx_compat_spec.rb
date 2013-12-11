require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe CfmxCompat do
  let(:key) { "mySecretKey" }
  let(:plaintext) { "clear text" }

  describe ".encrypt" do
    specify { CfmxCompat.encrypt(nil, key).should == '' }
    specify { CfmxCompat.encrypt('', key).should == '' }

    it { expect { CfmxCompat.encrypt(plaintext, nil) }.to raise_error(ArgumentError) }
    it { expect { CfmxCompat.encrypt(plaintext, '') }.to raise_error(ArgumentError) }

    context "encoding" do
      specify { CfmxCompat.encrypt(plaintext, key, 'uu').should == "*<@>J&XG+`99/40``\n" }
      specify { CfmxCompat.encrypt(plaintext, key, 'hex').should == "7207AA1B89CB01964F51" }
      specify { CfmxCompat.encrypt(plaintext, key, 'base64').should == "cgeqG4nLAZZPUQ==" }
      specify { CfmxCompat.encrypt(plaintext, key).should == CfmxCompat.encrypt(plaintext, key, 'uu') }
    end
  end

  describe ".decrypt" do
    specify { CfmxCompat.decrypt(nil, key).should == '' }
    it { expect { CfmxCompat.decrypt(plaintext, nil) }.to raise_error(ArgumentError) }

    context "encoding" do
      context "when not given" do
        it "assumes ciphertext is uu encoded" do
          uu_ciphertext = CfmxCompat.encrypt(plaintext, key, 'uu')
          CfmxCompat.decrypt(uu_ciphertext, key).should == plaintext
        end
      end

      it "decrypts correctly with specified encoding" do
        [:uu, :hex, :base64].each do |encoding_type|
          ciphertext = CfmxCompat.encrypt(plaintext, key, encoding_type)
          CfmxCompat.decrypt(ciphertext, key, encoding_type).should == plaintext
        end
      end
    end
  end
end
