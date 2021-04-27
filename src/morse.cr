require "json"
require "string_scanner"

module Morse
  VERSION = "0.1.0"

  struct Table
    include JSON::Serializable

    property from : String
    property to : String
    property conversion_table : Hash(String, String)

    def generate_regex
      conversion_table.keys.map { |key| /#{key}/i }.reduce { |res, regex| res + regex }
    end
  end

  class Encoder
    def initialize(@table : Table, @regex : Regex)
    end

    def initialize(table_path : String)
      @table = Table.from_json(load_table(table_path))
      @regex = @table.generate_regex
    end

    def self.encode(table_path : String, text : String)
      self.new(table_path).encode(text)
    end

    def encode(text : String)
      res = ""
      scanner = StringScanner.new(text)

      while e = scanner.scan(@regex)
        res += @table.conversion_table[e]
      end

      res
    end

    private def load_table(table_path)
      File.read(table_path)
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
