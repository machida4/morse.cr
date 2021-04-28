require "json"
require "string_scanner"

module Morse
  VERSION = "0.1.0"

  # TODO: tableに対する問い合わせを振る舞い側に
  class Table
    include JSON::Serializable

    property from : String
    property to : String
    property conversion_table : Hash(String, String)

    def initialize(
      @from : String,
      @to : String,
      @conversion_table : Hash(String, String)
    )
    end

    def inverted_conversion_table
      @conversion_table.invert
    end

    def regex
      generate_regex(@conversion_table)
    end

    def inverted_regex
      generate_regex(inverted_conversion_table)
    end

    private def generate_regex(conversion_table)
      conversion_table.keys.map { |key| /#{Regex.escape(key)}/i }.reduce { |res, regex| res + regex }
    end
  end

  # TODO: EncoderとDecoderで分ける必要ない気がするのでmacroとかでfrom_en, from_morseみたいなメソッドを生成するようにする
  class Encoder
    @conversion_table : Hash(String, String)
    @regex : Regex

    def initialize(table_path : String)
      table = Table.from_json(load_table(table_path))
      @conversion_table = table.conversion_table
      @regex = table.regex
    end

    def self.encode(table_path : String, text : String)
      self.new(table_path).encode(text)
    end

    def encode(text : String)
      res = ""
      scanner = StringScanner.new(text)

      while e = scanner.scan(@regex)
        res += @conversion_table[e]
        break if scanner.eos?
      end

      res
    end

    private def load_table(table_path)
      File.read(table_path)
    end
  end

  class Decoder
    @conversion_table : Hash(String, String)
    @regex : Regex

    def initialize(table_path : String)
      table = Table.from_json(load_table(table_path))
      @conversion_table = table.inverted_conversion_table
      @regex = table.inverted_regex
    end

    def self.decode(text : String, table : Table)
      self.new(table_path).decode(text)
    end

    def decode(text : String)
      res = ""
      scanner = StringScanner.new(text)

      while e = scanner.scan(@regex)
        res += @conversion_table[e]
        break if scanner.eos?
      end

      res
    end

    private def load_table(table_path)
      File.read(table_path)
    end
  end
end
