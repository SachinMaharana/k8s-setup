[masters]
%{ for index,ip in list_master ~}
master_${index} = ${ip}
%{ endfor ~}
%{ for index,ip in list_master_private ~}
master_${index}_p = "${ip}"
%{ endfor ~}


[workers]
%{ for index,ip in list_worker ~}
worker_${index} = ${ip}
%{ endfor ~}
%{ for index,ip in list_worker_private ~}
worker_${index}_p = ${ip}
%{ endfor ~}

[etcd]
%{ for index,ip in list_etcd ~}
etcd_${index} = ${ip}
%{ endfor ~} 
%{ for index,ip in list_etcd_private ~}
etcd_${index}_p = ${ip}
%{ endfor ~}

[lb]
%{ for index,ip in list_lb ~}
lb_${index} = ${ip}
%{ endfor ~} 
%{ for index,ip in list_lb_private ~}
lb_${index}_p = ${ip}
%{ endfor ~}
