require File.expand_path(File.join(%w(.. .. rvm)), File.dirname(__FILE__))

module Puppet::Parser::Functions
    newfunction(:rvm_user, :type => :rvalue) do |args|
        environment = *args
        Puppet::RVM.user(environment)
    end
end
