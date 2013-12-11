require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe CfmxCompat do
  let(:key) { "mySecretKey" }
  let(:plaintext) { "clear text" }

  describe ".encrypt" do
    context "nil plaintext" do
      it "returns empty string" do
        CfmxCompat.encrypt(nil, key).should == ''
      end
    end

    context "empty plaintext" do
      it "returns empty string" do
        CfmxCompat.encrypt('', key).should == ''
      end
    end

    context "nil key" do
      it "raises ArgumentError" do
        expect { CfmxCompat.encrypt(plaintext, nil) }.to raise_error(ArgumentError)
      end
    end

    context "empty key" do
      it "raises ArgumentError" do
        expect { CfmxCompat.encrypt(plaintext, '') }.to raise_error(ArgumentError)
      end
    end

    context "encoding" do
      context "when uu" do
        it "encrypts correctly" do
          CfmxCompat.encrypt(plaintext, key, "uu").should == "*<@>J&XG+`99/40``\n"
        end
      end

      context "when not specified" do
        it "defaults to uu" do
          CfmxCompat.encrypt(plaintext, key).should == "*<@>J&XG+`99/40``\n"
        end
      end

      context "when hex" do
        it "encrypts correctly" do
          CfmxCompat.encrypt(plaintext, key, "hex").should == "7207AA1B89CB01964F51"
        end
      end

      context "when base64" do
        it "encrypts correctly" do
          CfmxCompat.encrypt(plaintext, key, "base64").should == "cgeqG4nLAZZPUQ=="
        end
      end
    end
  end

  describe ".decrypt" do
    context "nil plaintext" do
      it "returns empty string" do
        CfmxCompat.decrypt(nil, key).should == ''
      end
    end

    context "nil key" do
      it "raises ArgumentError" do
        expect { CfmxCompat.decrypt(plaintext, nil) }.to raise_error(ArgumentError)
      end
    end

    context "encoding" do
      context "when not specified" do
        it "assumes ciphertext is uu encoded" do
          uu_ciphertext = CfmxCompat.encrypt(plaintext, key, 'uu')
          CfmxCompat.decrypt(uu_ciphertext, key).should == plaintext
        end
      end

      it "decrypts correctly with specified encoding" do
        [:uu, :hex, :base64].each do |encoding_type|
          CfmxCompat.decrypt(CfmxCompat.encrypt(plaintext, key, encoding_type), key, encoding_type).should == plaintext
        end
      end
    end
  end
end
