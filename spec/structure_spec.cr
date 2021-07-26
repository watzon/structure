require "./spec_helper"

Spectator.describe Structure do
  describe "#pack" do
    it "packs single value into bytes" do
      expect(Structure.from("I").pack(3)).to eq(Bytes[0, 0, 0, 3])
    end

    it "packs 2 values into bytes" do
      expect(Structure.from("If").pack(6, 5.2)).to eq(Bytes[0, 0, 0, 6, 204, 204, 204, 205])
    end

    it "packs booleans" do
      expect(Structure.from("?").pack(true)).to eq(Bytes[1])
      expect(Structure.from("?").pack(false)).to eq(Bytes[0])
    end

    it "packs using big endian by default" do
      expect(Structure.from("I").pack(1)).to eq(Bytes[0, 0, 0, 1])
      expect(Structure.from(">I").pack(1)).to eq(Bytes[0, 0, 0, 1])
      expect(Structure.from("!I").pack(1)).to eq(Bytes[0, 0, 0, 1])
    end

    it "packs using little endian" do
      expect(Structure.from("<I").pack(1)).to eq(Bytes[1, 0, 0, 0])
    end

    it "packs repeated values" do
      expect(Structure.from("2B2?").pack(2, 3, true, false)).to eq(Bytes[2, 3, 1, 0])
    end
  end

  describe "#pack_into" do
    it "packs single value into the provided IO" do
      io = IO::Memory.new
      Structure.from("I").pack_into(io, 3)
      expect(io.rewind.to_slice).to eq(Bytes[0, 0, 0, 3])
    end
  end

  describe "#unpack" do
    it "unpacks values into an Array" do
      expect(Structure.from("I").unpack(Bytes[0, 0, 0, 3])).to eq([3i32])
    end
  end

  describe "#unpack_from" do
    it "unpacks values from IO into an Array" do
      io = IO::Memory.new(Bytes[0, 0, 0, 3])
      expect(Structure.from("I").unpack_from(io)).to eq([3i32])
    end
  end
end
