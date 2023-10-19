# Supplier Payments

[![CI](https://github.com/barsoom/supplier_payments/actions/workflows/ci.yml/badge.svg)](https://github.com/barsoom/supplier_payments/actions/workflows/ci.yml)

Library for making Bankgirot supplier payment files, _Leverantörsbetalningar_.

## Documentation

* På svenska: ["Leverantörsbetalningar, teknisk manual"](http://www.bgc.se/globalassets/dokument/tekniska-manualer/leverantorsbetalningar_tekniskmanual_sv.pdf) (PDF)
* In English: ["Supplier Payments (Leverantörsbetalningar), technical manual"](http://www.bgc.se/globalassets/dokument/tekniska-manualer/supplierpayments_leverantorsbetalningar_technicalmanual_en.pdf) (PDF)

Records are defined in `lib/supplier_payments/payment_file/domestic_records.rb`. Layouts are defined with arrays, like:

```ruby
[ :credit_transfer_number, 6, 'N', :right_align, :zerofill ]
# :credit_transfer_number is the name of the field
# 6 is the length of the field
# `"N"` if the value consists of two digits, or `"A"` for strings.
# Options for formatting are:
#   :right_align if the field is to be right-aligned (otherwise it will be left-aligned)
#   :zerofill if the field is to be filled with zeros
```

[API documentation for this gem](https://www.rubydoc.info/gems/supplier_payments/)
