all:
    children:
        kang:
            hosts:
            %{ for index, ip in master_ips }
                master-ka-${index}:
                    ansible_host: ${ip}
                    ansible_user: root
                    mode: 'master'
                    init_master: ${index == 0 ? "'true'" : "'false'"}
            %{ endfor }
            %{ for index, ip in worker_ips }
                worker-ka-${index}:
                    ansible_host: ${ip}
                    ansible_user: root
                    mode: 'worker'
                    init_master: 'false'
            %{ endfor }
                haproxy:
                    ansible_host: ${haproxy_ip}
                    ansible_user: root
                    mode: 'haproxy'
                    init_master: 'false'