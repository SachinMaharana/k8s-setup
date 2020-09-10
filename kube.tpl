[masters]
%{ for index,ip in list_master ~}
${ip}
%{ endfor ~}


[workers]
%{ for index,ip in list_worker ~}
${ip}
%{ endfor }

[etcd]
%{ for index,ip in list_etcd ~}
${ip}
%{ endfor } 
