# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "supplier_payments/version"

Gem::Specification.new do |s|
  s.name        = "supplier_payments"
  s.version     = SupplierPayments::VERSION
  s.authors     = ["Andreas Alin"]
  s.email       = ["andreas.alin@gmail.com"]
  s.homepage    = "https://github.com/barsoom/supplier_payments"
  s.summary     = %q{Supplier payment files}
  s.description = %q{This gem should help you parse and generate supplier payment files that will work with BGC.}

  s.rubyforge_project = "supplier_payments"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
end
