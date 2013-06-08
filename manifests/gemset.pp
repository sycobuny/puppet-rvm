define rvm::gemset(
    $environment    = undef,
    $implementation = undef,
    $version        = undef,
    $patchlevel     = undef,
    $gemset         = undef
) {
    $implied_data = rvm_normalize($name)
    $ruby         = rvm_ruby($implied_data)

    $real_environment = $environment ? {
        undef   => $implied_data['environment'],
        default => $environment,
    }

    if $real_environment == undef {
        fail("'environment' not provided and could not guess from name")
    }

    $real_gemset = $gemset ? {
        undef   => $implied_data['gemset'],
        default => $gemset,
    }

    if $real_gemset == undef {
        fail("'gemset' not provided and could not guess from name")
    }

    $user  = rvm_user ($real_environment)
    $group = rvm_group($real_environment)
    $root  = rvm_root ($real_environment)

    exec { "RVM[${real_environment}][${ruby}][${real_gemset}]: create":
        provider => 'shell',
        user     => $user,
        group    => $group,
        command  => rvm_exec($real_environment, $ruby,
                             ['rvm', 'gemset', 'create', $real_gemset]),
        unless   => "test -d ${root}/gems/${ruby}@${real_gemset}",
    } ->

    exec { "RVM[${real_environment}][${ruby}][${real_gemset}]: wrap":
        provider => 'shell',
        user     => $user,
        group    => $group,
        command  => rvm_command($real_environment, 'wrapper',
                                ["${ruby}@${real_gemset}"]),
        unless   => "test -x ${root}/wrappers/${ruby}@${real_gemset}/ruby",
    }
}
