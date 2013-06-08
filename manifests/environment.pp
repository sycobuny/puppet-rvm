define rvm::environment(
    $user      = undef,
    $group     = undef,
    $root      = undef,
    $version   = 'stable',
    $source    = 'https://get.rvm.io',
    $installer = '/bin/bash'
) {
    $environment = $name

    if $user  != undef { rvm_set_edata($environment, 'user',  $user ) }
    if $group != undef { rvm_set_edata($environment, 'group', $group) }
    if $root  != undef { rvm_set_edata($environment, 'root',  $root ) }
    rvm_set_edata($environment, 'version',   $version  )
    rvm_set_edata($environment, 'source',    $source   )
    rvm_set_edata($environment, 'installer', $installer)

    $real_user  = rvm_user ($environment)
    $real_group = rvm_group($environment)
    $real_root  = rvm_root ($environment)

    $cond = "\\! -user ${real_user} -o \\! -group ${real_group}"
    $find = "find ${real_root} ${cond}"
    $test = 'test $(wc -l) -ne 0'

    $curl = "\\curl -L ${source}"
    $inst = "${installer} -s ${version}"

    exec { "RVM[${environment}]: make_root":
        provider => 'shell',
        command  => "mkdir -p ${real_root}",
        unless   => "test -d ${real_root}",
    } ->

    exec { "RVM[${environment}]: chown_root":
        provider => 'shell',
        command  => "chown -R ${real_user}:${real_group} ${real_root}",
        onlyif   => "${find} | ${test}",
    } ->

    # gotta do the command's $rvm_path environment variable with `export`
    # instead of the "environment" parameter, cause it could have shell script
    # to execute if it's the default value. Theoretically a config could now
    # use shell script in their answer too - whether this is a vulnerability
    # or a feature is an exercise for the user to answer. (hint: it's not the
    # only place)
    exec { "RVM[${environment}]: install":
        provider => 'shell',
        user     => $real_user,
        group    => $real_group,
        command  => "export rvm_path=${real_root} && (${curl} | ${inst})",
        unless   => "test -x ${real_root}/scripts/rvm",
    }
}
