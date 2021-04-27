require "json"

module Morse
  VERSION = "0.1.0"

  struct Table
    include JSON::Serializable

    property from : String
    property to : String
    property conversion_table : Hash(String, String)

    def generate_regex
      conversion_table.keys.map { |key| /^#{key}/}.reduce { |res, regex| res + regex }
    end
  end

  class Encoder
    def initialize(@table : Table)
    end

    def initialize(table_path : String)
      abort "missing file" if !File.file?(table_path)
      @table = Table.from_json(File.read(table_path))
    end

    def self.encode(text : String, table : Table)
      self.new(table).encode(text)
    end

    def encode(text : String)
      res = ""

      while @table.generate_regex =~ text
        res += @table.conversion_table[$~[0]]
        text = text[$~.end(0)..-1]
      end
        
      res
    end
  end

  class Decoder
    def initialize(@table : Table)
    end

    def initialize(table_path : String)
      abort "missing file" if !File.file?(table_path)
      @table = Table.from_json(File.read(table_path))
    end

    def self.decode(text : String, table : Table)
      self.new(table).decode(text)
    end

    def decode(text : String)
    end
  end
end
