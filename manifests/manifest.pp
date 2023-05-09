node /^kubernetesnode(\d+)server\.project$/ {
include users
}


node 'kubernetesmasterserver.project' {
include users
}
