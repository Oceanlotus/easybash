yum -y install haproxy
mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.bak
read -p "Input source address:" ip
echo -e "${Info} Enter the accelerator server source address"
read -p "(If the input is wrong, please go to /etc/haproxy/haproxy.cfg to modify):" ip
                for port in ${ip}
                do echo -e " global
defaults
  log global 
  mode    tcp
  option  dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
listen  website
mode tcp     
  frontend open-in
         bind *:80
         default_backend open-out
backend open-out
          server server1  ${ip}:80 maxconn 20480" >> /etc/haproxy/haproxy.cfg
		  
 done

service haproxy stop
service haproxy start

