# frozen_string_literal: true

module SupplierPayments
  class PaymentFile
    class << self
      @@record_classes = []

      def record_classes
        @@record_classes
      end

      def register_record_class(record_class)
        record_classes << record_class
      end
    end

    attr_accessor :records

    def initialize(records)
      @records = records
    end

    def to_s
      records.map { |record| "#{record}\r\n" }.join.force_encoding("ISO-8859-15")
    end

    def self.load(data)
      records = data.lines.map do |line|
        line.strip!
        next if line.empty?

        record_class(line).parse(line)
      end
      new(records)
    end

    private

    def self.record_class(line)
      record_classes.find do |record_class|
        line.match(/^#{record_class.transaction_code}/)
      end or raise "No record class found for line: #{line.inspect}"
    end
  end
end
