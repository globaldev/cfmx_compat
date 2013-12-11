require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe CfmxCompat do
  let(:key) { "mySecretKey" }
  let(:plaintext) { "clear text" }
  let(:other_plaintext) { "other plaintext"}

  describe ".encrypt" do
    it { expect { CfmxCompat.encrypt(plaintext, nil) }.to raise_error(ArgumentError) }
    it { expect { CfmxCompat.encrypt(plaintext, '') }.to raise_error(ArgumentError) }

    specify { CfmxCompat.encrypt(nil, key).should == '' }
    specify { CfmxCompat.encrypt('', key).should == '' }

    specify { CfmxCompat.encrypt(plaintext, key, 'uu').should == "*<@>J&XG+`99/40``\n" }
    specify { CfmxCompat.encrypt(other_plaintext, key, 'uu').should == "/?A^G'XG+!9]63%VH@*=3\n" }
    specify { CfmxCompat.encrypt(plaintext, key, 'hex').should == "7207AA1B89CB01964F51" }
    specify { CfmxCompat.encrypt(other_plaintext, key, 'hex').should == "7E1FA71F89CB059F564C5DA880A753" }
    specify { CfmxCompat.encrypt(plaintext, key, 'base64').should == "cgeqG4nLAZZPUQ==" }
    specify { CfmxCompat.encrypt(other_plaintext, key, 'base64').should == "fh+nH4nLBZ9WTF2ogKdT" }

    specify { CfmxCompat.encrypt(plaintext, key).should == CfmxCompat.encrypt(plaintext, key, 'uu') }
  end

  describe ".decrypt" do
    it { expect { CfmxCompat.decrypt(plaintext, nil) }.to raise_error(ArgumentError) }
    specify { CfmxCompat.decrypt(nil, key).should == '' }

    context "encoding" do
      context "when not given" do
        it "assumes ciphertext is uu encoded" do
          uu_ciphertext = CfmxCompat.encrypt(plaintext, key, 'uu')
          CfmxCompat.decrypt(uu_ciphertext, key).should == plaintext
        end
      end

      context "when given" do
        it "decrypts correctly with specified encoding" do
          [:uu, :hex, :base64].each do |encoding_type|
            ciphertext = CfmxCompat.encrypt(plaintext, key, encoding_type)
            CfmxCompat.decrypt(ciphertext, key, encoding_type).should == plaintext
          end
        end
      end
    end
  end
end
