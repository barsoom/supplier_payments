# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "supplier_payments/version"

Gem::Specification.new do |s|
  s.name        = "supplier_payments"
  s.version     = SupplierPayments::VERSION
  s.authors     = ["Andreas Alin"]
  s.email       = ["andreas.alin@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "supplier_payments"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
end
