module SupplierPayments
  class PaymentFile
    class AbstractRecord
      LayoutError = Class.new(Exception)
      FormatError = Class.new(Exception)

      class << self
        attr_accessor :transaction_code
        attr_reader :layout

        protected

        def layout=(layout)
          length = layout_length(layout)
          raise LayoutError.new("Layout length #{ length } is not 80") unless length == 80

          layout.each do |field, length, format, *opts|
            next if field[-1] == "!"
            attr_accessor field
          end

          @layout = layout
        end

        def layout_length(layout)
          layout.inject(0) do |total, (field, length, format, *opts)|
            total + length
          end
        end

        def inherited(klass)
          PaymentFile.register_record_class(klass)
        end
      end

      def self.parse(line)
        io = StringIO.new(line)
        record = new

        layout.each do |field, length, format, *opts|
          if field[-1] == "!"
            io.seek(length, IO::SEEK_CUR)
          else
            record.send("#{ field }=", io.read(length))
          end
        end

        record
      end

      def initialize(attrs = {})
        attrs.each do |key, value|
          self.send("#{ key }=", value)
        end
      end

      def to_s
        self.class.layout.map { |field, length, format, *opts|
          format_field(field, length, format, *opts)
        }.join
      end

      def inspect
        str = self.class.layout.map { |field, length, format, *opts|
          next if field[-1] == "!"
          ":#{ field } => #{ send(field).inspect }"
        }.compact.join(", ")
        "<#{ self.class.name }(#{ transaction_code }) #{ str }>"
      end

      def transaction_code
        self.class.transaction_code
      end

      private

      def format_field(field, length, format, *opts)
        value = field_value(field)
        value.upcase! if opts.include?(:upcase)

        padding = opts.include?(:zerofill) ? "0" : " "
        align_method = opts.include?(:right_align) ? :rjust : :ljust

        value[0, length].send(align_method, length, padding)
      end

      def field_value(field)
        case field
        when :reserved!
          ""
        when :transaction_code!
          transaction_code
        else
          send(field).to_s
        end
      end
    end
  end
end

require "supplier_payments/payment_file/domestic_records"
