require "spec_helper"

describe SupplierPayments::PaymentFile do
  describe ".load" do
    context "with LBin-exempel1.txt" do
      before do
        @raw_data = File.read(fixture_path("LBin-exempel1.txt"))
        @raw_data.force_encoding("iso-8859-15")
      end

      it "should load a file" do
        file = SupplierPayments::PaymentFile.load(@raw_data)
        @raw_data.lines.zip(file.to_s.lines).each do |line1, line2|
          expect(line1.strip).to eq(line2.force_encoding("iso-8859-15").strip)
        end
      end
    end

    context "with LBin-exempel2.txt" do
      before do
        @raw_data = File.read(fixture_path("LBin-exempel2.txt"))
        @raw_data.force_encoding("iso-8859-15")
      end

      it "should load a file" do
        file = SupplierPayments::PaymentFile.load(@raw_data)
        @raw_data.lines.zip(file.to_s.lines).each do |line1, line2|
          expect(line1.strip).to eq(line2.force_encoding("iso-8859-15").strip)
        end
      end
    end
  end

  describe "#to_s" do
    class TestRecord < SupplierPayments::PaymentFile::AbstractRecord
      self.transaction_code = "99"
      self.layout = [
        [ :transaction_code!, 2, "N" ],
        [ :foo, 14, "N", :zerofill, :right_align ],
        [ :bar, 20, "A" ],
        [ :reserved!, 5, "N", :zerofill ],
        [ :baz, 10, "A", :right_align, :upcase ],
        [ :reserved!, 29, "A" ]
      ]
    end

    it "enforces ISO-8859-15 encoding" do
      record = TestRecord.new
      expect(record.to_s.encoding).to eq(Encoding::UTF_8)  # Sanity
      expect(SupplierPayments::PaymentFile.new([ record ]).to_s.encoding).to eq(Encoding::ISO_8859_15)
    end
  end
end
