require "./spec_helper"

describe Morse do
  describe "Table" do
    it "load table and convert Table" do
      table = Morse::Table.from_json(File.read("table/test.json")) 
      table.from.should eq("en")
      table.to.should eq("kao-moji")
      table.conversion_table.should eq({"ab" => "(^_^)", "bb" => "(>_<)"})
    end
  end

  describe "Encoder" do
    it "can encode text" do
      text = "ababbb"
      encoder = Morse::Encoder.new("table/test.json")
      encoder.encode(text).should eq("(^_^)(^_^)(>_<)")
    end

    it "can encode text from class method" do
      text = "ababbb"
      Morse::Encoder.encode("table/test.json", text).should eq("(^_^)(^_^)(>_<)")
    end
  end

  describe "Decoder" do
    it "can decode text" do
      text = "(^_^)(^_^)(>_<)"
      decoder = Morse::Decoder.new("table/test.json")
      decoder.decode(text).should eq("ababbb")
    end
  end
end
