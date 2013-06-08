require File.expand_path(File.join(%w(.. .. rvm)), File.dirname(__FILE__))

module Puppet::Parser::Functions
    newfunction(:rvm_set_edata) do |args|
        environment, key, value = *args
        Puppet::RVM.environment_data(environment, key, value)
    end
end
