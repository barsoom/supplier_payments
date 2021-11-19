# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "supplier_payments/version"

Gem::Specification.new do |s|
  s.name        = "supplier_payments"
  s.version     = SupplierPayments::VERSION
  s.authors     = [ "Andreas Alin" ]
  s.email       = [ "andreas.alin@gmail.com" ]
  s.homepage    = "https://github.com/barsoom/supplier_payments"
  s.summary     = %q{Parse and generate supplier payment files for Bankgirot.}
  s.description = %q{Parse and generate supplier payment files for "Leverantörsbetalningar" in Bankgirot.}
  s.metadata    = { "rubygems_mfa_required" => "true" }

  s.files         = Dir["lib/**/*.rb", "README.md"]
  s.test_files    = Dir["spec/**/*.{rb,txt}"]
  s.require_paths = [ "lib" ]
end
