require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe CfmxCompat do
  let(:key) { "mySecretKey" }
  let(:plain) { "clear text" }

  describe ".encrypt" do
    context "encoding" do
      context "when not specified" do
        it "encrypts correctly" do
          CfmxCompat.encrypt(plain, key).should == "*<@>J&XG+`99/40``\n"
        end
      end

      context "when uu" do
        it "encrypts correctly" do
          CfmxCompat.encrypt(plain, key, "uu").should == "*<@>J&XG+`99/40``\n"
        end
      end

      context "when hex" do
        it "encrypts correctly" do
          CfmxCompat.encrypt(plain, key, "hex").should == "7207AA1B89CB01964F51"
        end
      end

      context "when base64" do
        it "encrypts correctly" do
          CfmxCompat.encrypt(plain, key, "base64").should == "cgeqG4nLAZZPUQ=="
        end
      end
    end
  end

  describe ".decrypt" do
    context "encoding" do
      context "when not specified" do
        it "decrypts correctly" do
          CfmxCompat.decrypt(CfmxCompat.encrypt(plain, key), key).should == plain
        end
      end

      context "when uu" do
        it "decrypts correctly" do
          CfmxCompat.decrypt(CfmxCompat.encrypt(plain, key, :uu), key, :uu).should == plain
        end
      end

      context "when hex" do
        it "decrypts correctly" do
          CfmxCompat.decrypt(CfmxCompat.encrypt(plain, key, :hex), key, :hex).should == plain
        end
      end

      context "when base64" do
        it "decrypts correctly" do
          CfmxCompat.decrypt(CfmxCompat.encrypt(plain, key, :base64), key, :base64).should == plain
        end
      end
    end
  end
end
