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
  end
end
