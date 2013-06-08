require File.expand_path(File.join(%w(.. .. rvm)), File.dirname(__FILE__))

module Puppet::Parser::Functions
    newfunction(:rvm_normalize, :type => :rvalue) do |args|
        Puppet::RVM.normalize(args[0])
    end
end
