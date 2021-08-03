require "spec_helper"

describe SupplierPayments::PaymentFile::AbstractRecord do
  context "with a test record class" do
    class TestRecord < SupplierPayments::PaymentFile::AbstractRecord
      self.transaction_code = "99"
      self.layout = [
        [ :transaction_code!, 2, "N" ],
        [ :foo, 14, "N", :zerofill, :right_align ],
        [ :bar, 20, "A" ],
        [ :reserved!, 5, "N", :zerofill ],
        [ :baz, 10, "A", :right_align, :upcase ],
        [ :reserved!, 29, "A" ],
      ]
    end

    it "should parse a line" do
      record = TestRecord.parse("9900000000054321BBBBBBBBBBBBBBBBBBBBxxxxx     YYYYY                             ")
      expect(record.transaction_code).to eq("99")
      expect(record.foo).to eq("00000000054321")
      expect(record.bar).to eq("BBBBBBBBBBBBBBBBBBBB")
      expect(record.baz).to eq("     YYYYY")
    end

    it "should make a line" do
      record = TestRecord.new
      record.foo = 1234
      record.bar = "ASDFG"
      record.baz = "Ghijk"
      expect(record.to_s).to eq("9900000000001234ASDFG               00000     GHIJK                             ")
    end

    it "should strip long lines" do
      record = TestRecord.new
      record.foo = 314159265358979323846
      expect(record.to_s.length).to eq(80)
      expect(record.to_s).to eq("9931415926535897                    00000                                       ")
    end
  end

  it "should complain if the sum of the lengths don't equal 80" do
    expect {
      Class.new(SupplierPayments::PaymentFile::AbstractRecord) do
        self.transaction_code = "98"
        self.layout = [
          [ :transaction_code, 2, "N" ],
        ]
      end
    }.to raise_error(SupplierPayments::PaymentFile::AbstractRecord::LayoutError)
  end
end

