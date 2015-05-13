module SupplierPayments
  class PaymentFile
    class InternationalOpeningRecord < AbstractRecord
      self.transaction_code = '0'
      self.layout = [
        [ :transaction_code!, 1, 'N' ],
        [ :sender_bankgiro, 8, 'N', :right_align, :zerofill ],
        [ :date_written, 6, 'N' ],
        [ :sender_name, 22, 'A' ],
        [ :sender_address, 35, 'A' ],
        [ :payment_date, 6, 'N' ],
        [ :layout_code!, 1, 'N' ], # number of digits of sender_bankgiro, 1 for 7 digits, 2 for 8 digits
        [ :reserved!, 1, 'A' ],
      ]
    end

    class InternationalNameRecord < AbstractRecord
      self.transaction_code = '2'
      self.layout = [
        [ :transaction_code!, 1, 'N' ],
        [ :payee_number, 7, 'N', :right_align, :zerofill ],
        [ :payee_name_1, 30, 'A' ],
        [ :payee_name_2, 35, 'A' ],
        [ :reserved!, 7, 'A' ],
      ]
    end

    class InternationalAddressRecord < AbstractRecord
      self.transaction_code = '3'
      self.layout = [
        [ :transaction_code!, 1, 'N' ],
        [ :payee_number, 7, 'N', :right_align, :zerofill ],
        [ :payee_street_address, 30, 'A' ],
        [ :payee_town_and_country, 35, 'A' ],
        [ :reserved!, 1, 'A' ],
        [ :riksbank_country_code, 2, 'A' ],
        [ :reserved!, 1, 'A' ],
        [ :cost_debiting, 1, 'A' ], # 0 sender pays swedish costs, 2 payee pays, 3 sender pays everything
        [ :means_of_payment, 1, 'A' ], # TODO: figure out the possible values
        [ :payment_method, 1, 'A' ], # 0 normal, 1 express, 2 inter-company
      ]
    end

    class InternationalBankRecord < AbstractRecord
      self.transaction_code = '4'
      self.layout = [
        [ :transaction_code!, 1, 'N' ],
        [ :payee_number, 7, 'N', :right_align, :zerofill ],
        [ :bic_code, 12, 'A' ],
        [ :iban_code, 30, 'A' ],
        [ :clearing_code, 30, 'A' ],
      ]
    end

    class InternationalCreditInvoiceRecord < AbstractRecord
      self.transaction_code = '5'
      self.layout = [
        [ :transaction_code!, 1, 'N' ],
        [ :payee_number, 7, 'N', :right_align, :zerofill ],
        [ :payments_reference, 25, 'A' ],
        [ :customer_amount, 11, 'N', :right_align, :zerofill ],
        [ :forex_account_or_future_agreements_number, 10, 'N', :zerofill ],
        [ :currency_code, 3, 'A' ],
        [ :final_monitoring_date, 6, 'N' ],
        [ :audit_code_or_zero, 1, 'N' ], # 0 or audit code
        [ :reserved!, 1, 'N' ],
        [ :invoice_amount, 13, 'N', :right_align, :zerofill ],
        [ :reserved!, 1, 'A' ],
        [ :zero_filled!, 1, 'N', :zerofill ],
      ]
    end

    class InternationalDebitInvoiceRecord < AbstractRecord
      self.transaction_code = '6'
      self.layout = [
        [ :transaction_code!, 1, 'N' ],
        [ :payee_number, 7, 'N', :right_align, :zerofill ],
        [ :payments_reference, 25, 'A' ],
        [ :customer_amount, 11, 'N', :right_align, :zerofill ],
        [ :forex_account_or_future_agreements_number, 10, 'N', :zerofill ],
        [ :currency_code, 3, 'A' ],
        [ :payment_date, 6, 'N' ],
        [ :audit_code_or_zero, 1, 'N' ], # 0 or audit code
        [ :reserved!, 1, 'N' ],
        [ :invoice_amount, 13, 'N', :right_align, :zerofill ],
        [ :reserved!, 1, 'A' ],
        [ :zero_filled!, 1, 'N', :zerofill ],
      ]
    end

    class InternationalRiksbankRecord < AbstractRecord
      self.transaction_code = '7'
      self.layout = [
        [ :transaction_code!, 1, 'N' ],
        [ :payee_number, 7, 'N', :right_align, :zerofill ],
        [ :riksbank_code, 3, 'N' ],
        [ :reserved!, 69, 'A' ],
      ]
    end

    class InternationalTotalAmountRecord < AbstractRecord
      self.transaction_code = '9'
      self.layout = [
        [ :transaction_code!, 1, 'N' ],
        [ :sender_bankgiro, 8, 'N', :right_align, :zerofill ],
        [ :total_amount, 12, 'N', :right_align, :zerofill ],
        [ :reserved!, 10, 'A' ],
        [ :sum_of_all_payee_numbers, 12, 'A', :right_align, :zerofill ],
        [ :number_of_payment_records, 12, 'A' ],
        [ :reserved!, 8, 'A' ],
        [ :sum_of_all_invoice_amounts_in_foreign_currencies, 15, 'N', :right_align, :zerofill ],
        [ :reserved!, 2, 'A' ],
      ]
    end
  end
end
