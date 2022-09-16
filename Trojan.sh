#!/bin/sh

# Download and install Trojan-go
mkdir /tmp/trojan-go
wget -O /tmp/trojan-go/trojan-go.zip https://github.com/p4gefau1t/trojan-go/releases/latest/download/trojan-go-linux-amd64.zip
unzip /tmp/trojan-go/trojan-go.zip -d /tmp/trojan-go
install -m 0755 /tmp/trojan-go/trojan-go /usr/local/bin/trojan-go

# Remove temporary directory
rm -r /tmp/trojan-go

# Trojan-go new configuration
install -d /usr/local/etc/trojan-go
cat << EOF > /usr/local/etc/trojan-go/config.yaml
run-type: server
local-addr: 0.0.0.0
local-port: $PORT
remote-addr: example.com
remote-port: 80
log-level: 5
password:
    - $PASSWORD
websocket:
  enabled: true
  path: /
transport-plugin:
  enabled: true
  type: plaintext
  if [[ -z "${PASSWORD}" ]]; then
  export PASSWORD="5c301bb8-6c77-41a0-a606-4ba11bbab084"
fi
echo ${PASSWORD}
export PASSWORD_JSON="$(echo -n "$PASSWORD" | jq -Rc)"
if [[ -z "${QR_Path}" ]]; then
  export QR_Path="/qr_img"
fi
echo ${QR_Path}
bash /conf/nginx_ss.conf > /etc/nginx/conf.d/ss.conf
echo /etc/nginx/conf.d/ss.conf
cat /etc/nginx/conf.d/ss.conf


EOF

# Run Trojan-go
/usr/local/bin/trojan-go -config /usr/local/etc/trojan-go/config.yaml
cat /usr/local/etc/trojan-go/config.yaml
