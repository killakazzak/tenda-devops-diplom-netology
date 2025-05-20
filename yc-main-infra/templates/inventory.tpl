[all]
${hosts_control}
${hosts_worker}

[kube_control_plane]
${list_control}

[etcd]
${list_control}

[kube_data_plane]
${list_worker}

[k8s_cluster:children]
kube_control_plane
kube_data_plane