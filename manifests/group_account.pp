define group_account (String $group_name, Boolean $sudoer) {

group { "${group_name}":
ensure => 'present'
}
if $sudoer == true {
augeas { "sudo-${group_name}":
context => "/files/etc/sudoers",
changes => [
"set spec[last() + 1]/user '%${group_name}'",
"set spec[last()]/host_group/host ALL",
"set spec[last()]/host_group/command ALL",
"set spec[last()]/host_group/command/runas_user ALL",
"set spec[last()]/host_group/command/tag NOPASSWD",
]
}
}
}
