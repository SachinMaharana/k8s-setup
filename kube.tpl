[masters]
%{ for index,ip in list_master ~}
${ip}
%{ endfor ~}

%{ for index,ip in list_master_private ~}
${ip} 
%{ endfor ~}


[workers]
%{ for index,ip in list_worker ~}
${ip}
%{ endfor }
%{ for index,ip in list_worker_private ~}
${ip}
%{ endfor ~}

[etcd]
%{ for index,ip in list_etcd ~}
${ip} 
%{ endfor } 
%{ for index,ip in list_etcd_private ~}
${ip}
%{ endfor ~}

[lb]
%{ for index,ip in list_lb ~}
${ip} instance-${index}-public 
%{ endfor } 
%{ for index,ip in list_lb_private ~}
${ip} instance-${index}-private 
%{ endfor ~}
