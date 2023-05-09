define account (String $user_name, Array[String] $user_groups) {
user { "${user_name}":
ensure => 'present',
managehome => true,
home => "/home/${user_name}",
groups => $user_groups,
purge_ssh_keys => true
}
file{"/home/${user_name}/.ssh":
    require => User["${user_name}"],
    ensure  =>  directory,
    mode    =>  '0700',
    owner   =>  $user_name
}
ssh_authorized_key { "master-project-${user_name}":
  ensure => 'present',
  require => File["/home/${user_name}/.ssh"],
  user   => $user_name,
  type   => 'ssh-rsa',
  key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABgQDGzah1D9QmV/y2i73wW/oLi2wmeBqAPS1L3Q6I7+fyTsenOzWm6QyHjek/YIYZENVyb7xwjcrcCI2NAmFCPzrqWkhTaVwTFhnxjqtYTXl266KSwsHG7euWID0SQaSfYH4tdmfj3KdfjW3BRoHNgmnySdWSTa/ZLYsp0A7fm2hOI38Yyb0RcY3Dd3gY6lAbkPfvxHmYigJCnPHArNh4CwvsPQS6yv+fRcGZaoSwL9PIWjtP7Tba21x5BN+8IcAelg62pQ79ZE7enlJ5yHvMSHwATg+tr0xf1GE+YIVhDtGJUAXQ+YmxUzR2O0QpsPZbNem6PLBzrK5+SMwS2QukVfAjLRZW+bav6WeOOGYfzo6xchpvHjDTTTdZtXZMCmCSEyYTfQyBma1maFXfn9lJrgnxFm2wZe3LByfzx70hR5a1gvIMY8B1hIOukkEojeu0MYclgrOQwLTCWZ1krr897YlHEBb7ps38LQp2kHWG5W3F8LkVTxk6PGXl2eg7O0eGnwM='
}
}
