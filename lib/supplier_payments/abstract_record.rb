module SupplierPayments
  class AbstractRecord
    class << self
      attr_accessor :transaction_code
      attr_accessor :layout
    end
  end
end
