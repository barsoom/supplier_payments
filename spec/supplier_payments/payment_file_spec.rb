require 'spec_helper'

describe SupplierPayments::PaymentFile do
  describe ".load" do
    context 'with LBin-exempel1.txt' do
      before do
        @raw_data = File.read(fixture_path('LBin-exempel1.txt'))
        @raw_data.force_encoding("iso-8859-15")
      end

      it 'should load a file' do
        file = SupplierPayments::PaymentFile.load(@raw_data)
        @raw_data.lines.zip(file.to_s.lines).each do |line1, line2|
          expect(line1.strip).to eq(line2.force_encoding("iso-8859-15").strip)
        end
      end
    end

    context 'with LBin-exempel2.txt' do
      before do
        @raw_data = File.read(fixture_path('LBin-exempel2.txt'))
        @raw_data.force_encoding("iso-8859-15")
      end

      it 'should load a file' do
        file = SupplierPayments::PaymentFile.load(@raw_data)
        @raw_data.lines.zip(file.to_s.lines).each do |line1, line2|
          expect(line1.strip).to eq(line2.force_encoding("iso-8859-15").strip)
        end
      end
    end
  end
end
