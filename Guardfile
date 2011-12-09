lol = "\232\270\326\320\313\306\307\244\201]?!'&,+10Sv".unpack("C*").map{|v|"\e[38;5;#{v}m\342\226\210"}.join*4+"\e[0m"

guard 'rspec', :version => 2, :cli => "--color", :all_after_pass => false, :all_on_start => false, :keep_failed => false, :message => "#{lol}\e[2J\e[H" do
  watch('spec/spec_helper.rb')  { "spec" }
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
end
