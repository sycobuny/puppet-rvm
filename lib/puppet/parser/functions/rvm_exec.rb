require File.expand_path(File.join(%w(.. .. rvm)), File.dirname(__FILE__))

module Puppet::Parser::Functions
    newfunction(:rvm_exec, :type => :rvalue) do |args|
        environment, ruby, cmd_args = *args
        Puppet::RVM.exec(environment, ruby, cmd_args)
    end
end
