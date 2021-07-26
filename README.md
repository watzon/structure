# Structure

Crystal's answer to Python's `struct` and Ruby's `Array.pack/unpack`.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     structure:
       github: watzon/structure
   ```

2. Run `shards install`

## Usage

```crystal
require "structure"

s = Structure.from("2IB")
buf = s.pack(1, 2, 3)
# alternatively
buf = s.pack([1, 2, 3])

pp buf == Bytes[0, 0, 0, 1, 0, 0, 0, 2, 3]
# => true

pp s.unpack(buf)
# => [1u32, 2u32, 3u8]
```

You can also make use of `pack_into` and `unpack_from` if you would like to use an existing IO.

```crystal
require "structure"

io = IO::Memory.new

s = Structure.from("2IB")
buf = s.pack_into(io, 1, 2, 3)
# alternatively
buf = s.pack_into(io, [1, 2, 3])

io2 = IO::Memory.new

pp s.unpack_from(io)
# => [1u32, 2u32, 3u8]
```

# Format Strings

## Endianness

By default, the endianness is big-endian. It could be determined by specifying one of the
following characters at the beginning of the format:

Character   |   Endianness
---------   |   ----------
'='         |   native (target endian)
'<'         |   little-endian
'>'         |   big-endian
'!'         |   network (= big-endian)

## Types

Character   |   Type
---------   |   ----
'b'         |   `i8`
'B'         |   `u8`
'?'         |   `bool`
'h'         |   `i16`
'H'         |   `u16`
'i'         |   `i32`
'I'         |   `u32`
'q'         |   `i64`
'Q'         |   `u64`
'f'         |   `f32`
'd'         |   `f64`
's'         |   `Bytes` (WIP)
'S'         |   `Bytes` (WIP)
'P'         |   `Pointer(Void)` (WIP)
'x'         |   padding (`0u8`)

Any format character may be preceded by an integral repeat count. For example, the format string '4h' means exactly the same as 'hhhh'.

# Differences from Python struct library

* Numbers' byte order is big-endian by default (e.g. u32, f64...).
* There is no alignment support.
* 32 bit integer format character is only 'I'/'i' (and not 'L'/'l').

## Contributing

1. Fork it (<https://github.com/watzon/structure/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Chris Watson](https://github.com/watzon) - creator and maintainer
