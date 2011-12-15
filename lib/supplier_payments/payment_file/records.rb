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

    class OpeningRecord < AbstractRecord
      self.transaction_code = '11'
      self.layout = [
        [ :transaction_code!, 2, 'N' ],
        [ :sender_bankgiro, 10, 'N', :right_align, :zerofill ],
        [ :bgc_date_written, 6, 'N' ],
        [ :product, 22, 'A' ],
        [ :payment_date, 6, 'N' ],
        [ :report_code, 1, 'N' ],
        [ :reserved!, 12, 'N' ],
        [ :currency_code, 3, 'A' ],
        [ :reserved!, 18, 'A' ],
      ]
    end

    class FixedInformationRecord < AbstractRecord
      self.transaction_code = '12'
      self.layout = [
        [ :transaction_code!, 2, 'N' ],
        [ :information_text, 50, 'A' ], # Information reported to recipients with bankgiro number in
                                        # all sections with the same forwarding bankgiro number
                                        # (For example: Merry Christmas, We have moved etc.) or blank.
        [ :end_date, 6, 'A' ],
        [ :reserved!, 22, 'A' ]
      ]
    end

    class HeaderRecord < AbstractRecord
      self.transaction_code = '13'
      self.layout = [
        [ :transaction_code!, 2, 'N' ],
        [ :payment_specifications_header, 25, 'A' ],
        [ :net_amount_header, 12, 'A' ],
        [ :reserved!, 41, 'A' ]
      ]
    end

    class PaymentRecord < AbstractRecord
      self.transaction_code = '14'
      self.layout = [
        [ :transaction_code!, 2, 'N' ],
        [ :bankgiro_or_credit_transfer_number, 10, 'N', :right_align, :zerofill ],
        [ :ocr, 25, 'A' ],
        [ :amount, 12, 'N', :right_align, :zerofill ],
        [ :payment_date, 6, 'N' ], # YYMMDD or GENAST
        [ :reserved!, 5, 'A' ],
        [ :information_to_sender, 20, 'A' ]
      ]
    end

    class DeductionRecord < AbstractRecord
      self.transaction_code = '15'
      self.layout = [
        [ :transaction_code!, 2, 'N' ],
        [ :bankgiro_or_credit_transfer_number, 10, 'N', :right_align, :zerofill ],
        [ :ocr, 25, 'A' ],
        [ :deduction_amount, 12, 'N', :right_align, :zerofill ],
        [ :deduction_date, 6, 'N' ], # YYMMDD or GENAST
        [ :reserved!, 5, 'A' ],
        [ :information_to_sender, 20, 'A' ]
      ]
    end

    class CreditInvoiceWithMonitoringRecord < AbstractRecord
      self.transaction_code = '16'
      self.layout = [
        [ :transaction_code!, 2, 'N' ],
        [ :bankgiro_or_credit_transfer_number, 10, 'N', :right_align, :zerofill ],
        [ :ocr, 25, 'A' ],
        [ :amount, 12, 'N', :right_align, :zerofill ],
        [ :last_monitoring_day, 6, 'A' ], # YYMMDD or GENAST
        [ :reserved!, 5, 'A' ],
        [ :information_to_sender, 20, 'N' ]
      ]
    end

    class InformationRecord < AbstractRecord
      self.transaction_code = '25'
      self.layout = [
        [ :transaction_code!, 2, 'N' ],
        [ :bankgiro_or_credit_transfer_number, 10, 'N', :right_align, :zerofill ],
        [ :information_text, 50, 'A' ],
        [ :reserved!, 18, 'A' ],
      ]
    end

    class TotalAmountRecord < AbstractRecord
      self.transaction_code = '29'
      self.layout = [
        [ :transaction_code!, 2, 'N' ],
        [ :senders_bankgiro_number, 10, 'N', :right_align, :zerofill ],
        [ :number_of_payment_records, 8, 'N', :right_align, :zerofill ],
        [ :total_amount, 12, 'N', :right_align, :zerofill ],
        [ :negative_total_amount, 1, 'A' ], # Minus sign (if total amount is negative) or blank.
        [ :reserved!, 47, 'A' ]
      ]
    end

    class NameRecord < AbstractRecord
      self.transaction_code = '26'
      self.layout = [
        [ :transaction_code!, 2, 'N' ],
        [ :reserved!, 4, 'N', :zerofill ], # 0000
        [ :credit_transfer_number, 6, 'N' ], # Must be the same as in the payment record or account number record, to which it belongs.
        [ :payee_name, 35, 'A', :upcase ],
        [ :extra_information, 33, 'A' ], # Used, for example, for C/O addresses.
      ]
    end

    class AddressRecord < AbstractRecord
      self.transaction_code = '27'
      self.layout = [
        [ :transaction_code!, 2, 'N' ],
        [ :reserved!, 4, 'N', :zerofill ],
        [ :credit_transfer_number, 6, 'N', :right_align, :zerofill ],
        [ :payee_address, 35, 'A', :upcase ],
        [ :post_code, 5, 'N' ], # No spaces
        [ :town, 20, 'A', :upcase ],
        [ :reserved!, 8, 'A' ]
      ]
    end

    class AccountNumberRecord < AbstractRecord
      self.transaction_code = '40'
      self.layout = [
        [ :transaction_code!, 2, 'N' ],
        [ :reserved!, 4, 'N', :zerofill ], # 0000
        [ :credit_transfer_number, 6 ],
        [ :clearing_number, 4, 'N' ],
        [ :account_number, 12, 'N', :right_align, :zerofill ],
        [ :payment_identification, 12, 'A' ], # Information to the payee to identify the payment. Printed on the payee's bank statement.
        [ :code_for_salary, 1, 'A' ], # L for salary, else blank.
        [ :reserved!, 39, 'A' ]
      ]
    end

    class PlusGiroPaymentRecord < AbstractRecord
      self.transaction_code = '54'
      self.layout = [
        [ :transaction_code!, 2, 'N' ],
        [ :plusgiro_account, 10, 'N', :right_align, :zerofill ],
        [ :ocr, 25, 'A' ],
        [ :amount, 12, 'N', :right_align, :zerofill ],
        [ :payment_date, 6, 'A' ], # YYMMDD or GENAST.
        [ :reserved!, 5, 'A' ],
        [ :information_to_sender, 20, 'A' ] # Optional text or blank.
      ]
    end

    class PlusGiroInformationRecord < AbstractRecord
      self.transaction_code = '65'
      self.layout = [
        [ :transaction_code!, 2, 'N' ],
        [ :plusgiro_account, 10, 'N', :right_align, :zerofill ],
        [ :information_text, 35, 'A' ], # Optional text, printed on notifications and lists.
        [ :reserved!, 33, 'A' ]
      ]
    end
  end
end
