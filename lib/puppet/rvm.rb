module Puppet::RVM
    class DataAlreadySetError < ::Exception; end

    # this was found by Justin King/@jufineath, at:
    # http://stackoverflow.com/a/7359006/302012
    # it's a much more stable solution than what I was using before, which
    # required the use of "su" and was thus unable to be run as any user other
    # than root (which was actually necessary during the installation step)
    HOMEDIR   = '$(getent passwd %s | cut -d: -f6)/.rvm'

    NORMALIZE = /^
        (?:([^\:]+)\:)?  # environment
        ([^\@]+)\@?      # ruby
        ([^\/]+)?        # gemset
        (?:\/(.*))?      # gem
    $/x
    RUBIES    = [
        ['MRI', /^
            (?:(ruby)\-)?
            ([12]\.[890]\.[0-9])
            (?:\-(p[0-9]{1,3}|head))
        $/x],
        ['GORUBY', /^(goruby)$/],
        ['TCS',    /^(tcs)$/],
        ['JRUBY',  /^
            (jruby)
            (?:
                \-
                (1\.[0-9]\.[0-9])
                (?:\.(.*))?
            )?
        $/x]
    ]

    @@data = {}

    def self.dump
        require 'pp'
        pp @@data
    end

    def self.ruby(components)
        if components['implementation'] and components['version']
            ruby = "#{components['implementation']}-#{components['version']}"

            if components['patchlevel']
                if components['rubyname'] == 'JRUBY'
                    ruby = "#{ruby}.#{components['patchlevel']}"
                else
                    ruby = "#{ruby}-#{components['patchlevel']}"
                end
            end
        elsif components['ruby']
            ruby = components['ruby']
        else
            raise Exception, "Could not construct ruby from component parts"
        end

        ruby
    end

    def self.normalize(name)
        components = {}

        name =~ NORMALIZE

        components['environment'] = $1
        components['ruby']        = $2
        components['gemset']      = $3
        components['gem']         = $4

        ruby = $2
        RUBIES.each do |rubyname, pattern|
            if ruby =~ pattern
                components['rubymame']       = rubyname
                components['implementation'] = $1 || 'ruby'
                components['version']        = $2
                components['patchlevel']     = $3
            end
        end

        components
    end

    def self.command(environment, command, args)
        root = root(environment)
        args = args.join(' ')

        "export rvm_path=#{root} && #{root}/bin/rvm #{command} #{args}"
    end

    def self.exec(environment, ruby, args)
        root = root(environment)
        args = args.join(' ')

        "export rvm_path=#{root} && #{root}/bin/rvm #{ruby} exec #{args}"
    end

    def self.root(environment, root = nil)
        root = environment_data(environment, :root, root)

        root || (HOMEDIR % user(environment))
    end

    def self.user(environment, user = nil)
        environment_data(environment, :user, user) || environment
    end

    def self.group(environment, group = nil)
        environment_data(environment, :group, group) || user(environment)
    end

    def self.edata(environment)
        @@data[environment] ||= blankhash
    end

    def self.rdata(environment, ruby)
        edata(environment)[:subelems][ruby] ||= blankhash
    end

    def self.gdata(environment, ruby, gemset)
        rdata(environment, ruby)[:subelems][gemset] ||= blankhash
    end

    def self.environment_data(environment, key, value = nil)
        send(:data, edata(environment), key, value)
    end

    def self.ruby_data(environment, ruby, key, value = nil)
        send(:data, rdata(environment, ruby), key, value)
    end

    def self.gemset_data(environment, ruby, gemset, key, value = nil)
        send(:data, gdata(environment, ruby, gemset), key, value)
    end

    def self.blankhash
        {:data => {}, :subelems => {}}
    end

    class << self
        private

        def data(hash, key, value = nil)
            data = hash[:data]
            key  = key.to_s.to_sym

            unless value.nil?
                raise DataAlreadySetError if data.has_key?(key)

                value = nil if value == :undef
                data[key] = value
            end

            data[key]
        end
    end
end
