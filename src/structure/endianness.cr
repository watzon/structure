class Structure
  enum Endianness
    Big
    Little
    Network
    System

    def to_byte_format
      case self
      in Big
        IO::ByteFormat::BigEndian
      in Little
        IO::ByteFormat::LittleEndian
      in Network
        IO::ByteFormat::NetworkEndian
      in System
        IO::ByteFormat::SystemEndian
      end
    end
  end
end
