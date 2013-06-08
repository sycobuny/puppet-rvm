require File.expand_path(File.join(%w(.. .. rvm)), File.dirname(__FILE__))

module Puppet::Parser::Functions
    newfunction(:rvm_root, :type => :rvalue) do |args|
        environment = *args
        Puppet::RVM.root(environment)
    end
end
