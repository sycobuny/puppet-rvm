require File.expand_path(File.join(%w(.. .. rvm)), File.dirname(__FILE__))

module Puppet::Parser::Functions
    newfunction(:rvm_get_edata, :type => :rvalue) do |args|
        environment, key = *args
        Puppet::RVM.environment_data(environment, key)
    end
end
