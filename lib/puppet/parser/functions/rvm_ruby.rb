require File.expand_path(File.join(%w(.. .. rvm)), File.dirname(__FILE__))

module Puppet::Parser::Functions
    newfunction(:rvm_ruby, :type => :rvalue) do |args|
        components = *args

        begin
            Puppet::RVM.ruby(components)
        rescue Exception => e
            Puppet::Parser::Functions.function('fail')
            function_fail("Failed to get ruby name: #{e.to_s}")
        end
    end
end
