require "./structure/*"

class Structure
  alias AnyValue = UInt8 | UInt16 | UInt32 | UInt64 | Int8 | Int16 | Int32 | Int64 | Float32 | Float64 | Bool | Bytes

  @transformers : Array(Transformer)
  @endianness : Endianness

  def initialize(@transformers : Array(Transformer), @endianness : Endianness = Endianness::Network)
  end

  def self.from(fmt_string : String)
    transformers = [] of Transformer
    reader = Char::Reader.new(fmt_string)
    endianness = Endianness::Network

    while reader.has_next?
      char = reader.current_char
      case char
      when '='
        raise FmtError.new("") unless reader.pos == 0
        endianness = Endianness::System
      when '<'
        raise FmtError.new("") unless reader.pos == 0
        endianness = Endianness::Little
      when '>'
        raise FmtError.new("") unless reader.pos == 0
        endianness = Endianness::Big
      when '!'
        raise FmtError.new("") unless reader.pos == 0
        endianness = Endianness::Network
      when '0'..'9'
        num = char.to_i
        char = reader.next_char
        if {'s', 'S'}.includes?(reader.peek_next_char)
          # transformers << BytesTransformer.new(num, exact: char === 'S')
        else
          num.times do
            transformers << Transformer.from_char(char)
          end
        end
      else
        transformers << Transformer.from_char(char)
      end
      reader.next_char
    end

    new(transformers, endianness)
  end

  def pack(values : Iterable(AnyValue))
    io = IO::Memory.new
    pack_into(io, values)
    io.rewind.to_slice
  end

  def pack_into(io : IO, values : Iterable(AnyValue))
    @transformers.each_with_index do |t, i|
      t.pack(io, values[i], @endianness)
    end
  end

  def pack(*values)
    pack(values.to_a)
  end

  def pack_into(io : IO, *values)
    pack_into(io, values.to_a)
  end

  def unpack(bytes : Bytes)
    io = IO::Memory.new(bytes)
    unpack_from(io)
  end

  def unpack_from(io : IO)
    arr = [] of AnyValue
    @transformers.each do |t|
      arr << t.unpack(io, @endianness)
    end
    arr
  end

  class FmtError < Exception; end
end
