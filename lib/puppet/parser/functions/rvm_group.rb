require File.expand_path(File.join(%w(.. .. rvm)), File.dirname(__FILE__))

module Puppet::Parser::Functions
    newfunction(:rvm_group, :type => :rvalue) do |args|
        environment = *args
        Puppet::RVM.group(environment)
    end
end
