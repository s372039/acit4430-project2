class users {
group_account{ 'kubernetes-users-group':
group_name => "kubernetes-users",
sudoer => true
}

account { 'rich':
user_name => "rich",
user_groups => ["kubernetes-users"]
}

account { 'kirk':
user_name => "kirk",
user_groups => ["kubernetes-users"]
}
}
