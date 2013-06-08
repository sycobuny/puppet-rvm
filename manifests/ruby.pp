define rvm::ruby(
    $environment    = undef,
    $implementation = undef,
    $version        = undef,
    $patchlevel     = undef
) {
    $implied_data = rvm_normalize($name)
    $ruby         = rvm_ruby($implied_data)
    $ruby_name    = $implied_data['ruby']

    $real_environment = $environment ? {
        undef   => $implied_data['environment'],
        default => $environment,
    }

    if $real_environment == undef {
        fail("'environment' not provided and could not guess from name")
    }

    $user  = rvm_user ($real_environment)
    $group = rvm_group($real_environment)
    $root  = rvm_root ($real_environment)

    exec { "RVM[${real_environment}][${ruby_name}]: install":
        provider => 'shell',
        user     => $user,
        group    => $group,
        command  => rvm_command($real_environment, 'install', [$ruby]),
        unless   => "test -x ${root}/rubies/${ruby}/bin/ruby",
    }
}
