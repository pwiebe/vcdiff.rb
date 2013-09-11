require "test_helper"

describe VCDIFF::VCDIFFHeader do
  it "requires a valid header" do
    # requires VCD\0 with the uppermost bits set to 1 for "V","C","D"
    expect { VCDIFF::VCDIFFHeader.read("\xD6\xC3\xC4\x00") }.to_not raise_error(BinData::ValidityError)
    expect { VCDIFF::VCDIFFHeader.read("\x01\x02\x03\x00") }.to raise_error(BinData::ValidityError)
  end

  describe "#secondary_compressor?" do
    it "is true if the header_indicator has the appropriate bit set" do
      header = VCDIFF::VCDIFFHeader.read("\xD6\xC3\xC4\x00\x01\x00\x00\x00\x00\x00\x00")
      header.secondary_compressor?.should be_true
      header.header_indicator[0].should == 1
    end
  end

  describe "#custom_codetable?" do
    it "is true if the header_indicator has the appropriate bit set" do
      # VCD\0 + 0b10 for custom code table, plus a bunch of zeroes to have enough bytes to read
      header = VCDIFF::VCDIFFHeader.read("\xD6\xC3\xC4\x00\x02\x00\x00\x00\x00\x00\x00")
      header.custom_codetable?.should be_true
      header.header_indicator[1].should == 1
    end
  end
end

describe VCDIFF::DeltaFile do
  it "requires a valid header" do
    expect { VCDIFF::DeltaFile.read("\xD6\xC3\xC4\x00") }.to_not raise_error(BinData::ValidityError)
    expect { VCDIFF::DeltaFile.read("\x01\x02\x03\x00") }.to raise_error(BinData::ValidityError)
  end
end