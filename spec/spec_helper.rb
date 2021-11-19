require "./lib/supplier_payments"

module FixtureHelper
  def fixture_path(filename)
    File.join(__dir__, "fixtures", filename)
  end
end

RSpec.configure do |config|
  config.include FixtureHelper
  config.disable_monkey_patching!
end
