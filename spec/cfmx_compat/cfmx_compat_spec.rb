require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe CfmxCompat do
  let(:key) { "mySecretKey" }
  let(:plaintext) { "clear text" }

  describe ".encrypt" do
    context "nil string value" do
      it "returns empty string" do
        CfmxCompat.encrypt(nil, key).should == ''
      end
    end

    context "nil key value" do
      it "raises ArgumentError" do
        expect { CfmxCompat.encrypt(plaintext, nil) }.to raise_error(ArgumentError)
      end
    end

    context "encoding" do
      context "when not specified" do
        it "encrypts correctly" do
          CfmxCompat.encrypt(plaintext, key).should == "*<@>J&XG+`99/40``\n"
        end
      end

      context "when uu" do
        it "encrypts correctly" do
          CfmxCompat.encrypt(plaintext, key, "uu").should == "*<@>J&XG+`99/40``\n"
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
    context "nil string value" do
      it "returns empty string" do
        CfmxCompat.decrypt(nil, key).should == ''
      end
    end

    context "nil key value" do
      it "raises ArgumentError" do
        expect { CfmxCompat.decrypt(plaintext, nil) }.to raise_error(ArgumentError)
      end
    end

    context "encoding" do
      context "when not specified" do
        it "decrypts correctly" do
          CfmxCompat.decrypt(CfmxCompat.encrypt(plaintext, key), key).should == plaintext
        end
      end

      context "when uu" do
        it "decrypts correctly" do
          CfmxCompat.decrypt(CfmxCompat.encrypt(plaintext, key, :uu), key, :uu).should == plaintext
        end
      end

      context "when hex" do
        it "decrypts correctly" do
          CfmxCompat.decrypt(CfmxCompat.encrypt(plaintext, key, :hex), key, :hex).should == plaintext
        end
      end

      context "when base64" do
        it "decrypts correctly" do
          CfmxCompat.decrypt(CfmxCompat.encrypt(plaintext, key, :base64), key, :base64) == plaintext
        end
      end
    end
  end
end
