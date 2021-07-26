class Structure
  abstract class Transformer
    def self.from_char(char : Char)
      case char
      when 'b'
        BaseTransformer(Int8).new
      when 'B'
        BaseTransformer(UInt8).new
      when '?'
        BoolTransformer.new
      when 'h'
        BaseTransformer(Int16).new
      when 'H'
        BaseTransformer(UInt16).new
      when 'i'
        BaseTransformer(Int32).new
      when 'I'
        BaseTransformer(UInt32).new
      when 'q'
        BaseTransformer(Int64).new
      when 'Q'
        BaseTransformer(UInt64).new
      when 'f'
        BaseTransformer(Float32).new
      when 'd'
        BaseTransformer(Float64).new
      when 's'
        BytesTransformer.new(1, exact: false)
      when 'S'
        BytesTransformer.new(1, exact: true)
      # when 'P'
      when 'x'
        PaddingTransformer.new
      else
        raise FmtError.new("Invalid format character '#{char}'.")
      end
    end
  end

  class BaseTransformer(T) < Transformer
    def pack(io : IO, value, endian : Endianness)
      io.write_bytes(value.is_a?(T) ? value : T.new(value.unsafe_as(T)), endian.to_byte_format)
    end

    def unpack(io : IO, endian : Endianness) : T
      io.read_bytes(T, endian.to_byte_format)
    end
  end

  class PaddingTransformer < BaseTransformer(UInt8)
    def pack(io : IO, value, endian : Endianness)
      io.write_bytes(0u8, endian.to_byte_format)
    end

    def unpack(io : IO, endian : Endianness)
      io.read_bytes(UInt8, endian.to_byte_format)
    end
  end

  class BoolTransformer < BaseTransformer(UInt8)
    def pack(io : IO, value, endian : Endianness)
      io.write_bytes(value ? 1u8 : 0u8, endian.to_byte_format)
    end

    def unpack(io : IO, endian : Endianness)
      io.read_bytes(UInt8, endian.to_byte_format)
    end
  end
end
