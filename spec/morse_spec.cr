require "./spec_helper"

describe Morse do
  it "load table and convert Table" do
    table = Morse::Table.from_json(File.read("table/test.json")) 
    table.language.should eq "test"
    table.conversion_table.should eq({"a" => "(^-^)"})
  end
end
