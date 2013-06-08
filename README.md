Puppet::RVM
-----------

Manage RVM installations using the Puppet configuration management system.

Basic Usage
-----------

```puppet
node rvmbox {
    rvm::environment { 'apache':                        } ->
    rvm::ruby        { 'apache:ruby-1.9.3-head':        } ->
    rvm::gemset      { 'apache:ruby-1.9.3-head@gollum': }
}
```

Caveats
-------

It is not fully tested or documented yet. Also, it does not have any way to
force the uninstallation of an RVM environment/ruby/gemset. Both of these
things are coming.

License
-------

Free to use and modify with attribution under an MIT/BSD-style license. See
the LICENSE file for more details.

Authors
-------

Stephen Belcher (@sycobuny)

Credits
-------

A similar module exists at https://github.com/blt04/puppet-rvm. However, it
installs a copy as a global package and users must be added to the appropriate
group to access it. While this set of resource types manages things
differently, several of the ideas were taken from there, including some of the
shell scripts to execute.

Justin King (@jufineath) found an alternate way to specify home directories
which was more portable and invaluable to crossing a few hurdles during the
installation step.
