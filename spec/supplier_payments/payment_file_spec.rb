require 'spec_helper'

describe SupplierPayments::PaymentFile::AbstractRecord do
  context 'with a test record class' do
    class TestRecord < SupplierPayments::PaymentFile::AbstractRecord
      self.transaction_code = '99'
      self.layout = [
        [ :transaction_code!, 2, 'N' ],
        [ :foo, 14, 'N', :zerofill, :right_align ],
        [ :bar, 20, 'A' ],
        [ :reserved!, 5, 'N', :zerofill ],
        [ :baz, 10, 'A', :right_align, :upcase ],
        [ :reserved!, 29, 'A' ]
      ]
    end

    it 'should parse a line' do
      record = TestRecord.parse("9900000000054321BBBBBBBBBBBBBBBBBBBBxxxxx     YYYYY                             ")
      record.transaction_code.should == "99"
      record.foo.should == "00000000054321"
      record.bar.should == "BBBBBBBBBBBBBBBBBBBB"
      record.baz.should == "     YYYYY"
    end

    it 'should make a line' do
      record = TestRecord.new
      record.foo = 1234
      record.bar = "ASDFG"
      record.baz = "Ghijk"
      record.to_s.should == "9900000000001234ASDFG               00000     GHIJK                             "
    end

    it 'should strip long lines' do
      record = TestRecord.new
      record.foo = 314159265358979323846
      record.to_s.length.should == 80
      record.to_s.should == "9931415926535897                    00000                                       "
    end
  end

  it "should complain if the sum of the lengths don't equal 80" do
    lambda {
      Class.new(SupplierPayments::PaymentFile::AbstractRecord) do
        self.layout = [
          [ :transaction_code, 2, 'N' ]
        ]
      end
    }.should raise_error(SupplierPayments::PaymentFile::AbstractRecord::LayoutError)
  end
end

describe SupplierPayments::PaymentFile do
  describe ".load" do
    before do
      fixture_filename = File.join(File.dirname(__FILE__), '..', 'fixtures', 'LBin-exempel1.txt')
      @raw_data = File.read(fixture_filename)
      @raw_data.force_encoding("iso-8859-15")
    end

    it 'should load a file' do
      file = SupplierPayments::PaymentFile.load(@raw_data)
      file.records.size.should == @raw_data.lines.count
    end
  end
end
