require File.expand_path(File.join(%w(.. .. rvm)), File.dirname(__FILE__))

module Puppet::Parser::Functions
    newfunction(:rvm_command, :type => :rvalue) do |args|
        environment, command, cmd_args = *args
        Puppet::RVM.command(environment, command, cmd_args)
    end
end
