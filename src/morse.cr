require "json"

module Morse
  VERSION = "0.1.0"

  struct Table
    include JSON::Serializable

    property language : String
    property conversion_table : Hash(String, String)
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
