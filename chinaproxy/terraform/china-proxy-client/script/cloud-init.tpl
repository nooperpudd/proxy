#cloud-config

runcmd:
   - apt-get install upgrade
   - apt-get install update -y

   - bash <(curl -L -s https://install.direct/go.sh)

    # client config file
   - cat <<EOF >/etc/v2ray/config.json
    {
      "log": {
        "access": "/var/log/v2ray/access.log",
        "error": "/var/log/v2ray/error.log",
        "loglevel": "warning"
      },
      "inbounds": [
        {
          "listen": "127.0.0.1",
          "protocol": "socks",
          "settings": {
            "ip": "",
            "userLevel": 0,
            "timeout": 360,
            "udp": false,
            "auth": "noauth"
          },
          "port": "1080"
        },
        {
          "listen": "127.0.0.1",
          "protocol": "http",
          "settings": {
            "timeout": 360
          },
          "port": "1087"
        }
      ],
      "outbounds": [
        {
          "mux": {
            "enabled": false,
            "concurrency": 8
          },
          "protocol": "vmess",
          "streamSettings": {
            "tcpSettings": {
              "header": {
                "type": "none"
              }
            },
            "tlsSettings": {
              "allowInsecure": true
            },
            "security": "none",
            "network": "tcp"
          },
          "tag": "agentout",
          "settings": {
            "vnext": [
              {
                "address": "${proxy-server-public-ip}",
                "users": [
                  {
                    "id": "f5222f46-41a8-4d3a-9b31-1e524be44121",
                    "alterId": 233,
                    "level": 0,
                    "security": "aes-128-gcm"
                  }
                ],
                "port": 555
              }
            ]
          }
        },
        {
          "tag": "direct",
          "protocol": "freedom",
          "settings": {
            "domainStrategy": "AsIs",
            "redirect": "",
            "userLevel": 0
          }
        },
        {
          "tag": "blockout",
          "protocol": "blackhole",
          "settings": {
            "response": {
              "type": "none"
            }
          }
        }
      ],
      "routing": {
        "strategy": "rules",
        "settings": {
          "domainStrategy": "IPIfNonMatch",
          "rules": [
            {
              "outboundTag": "direct",
              "type": "field",
              "ip": [
                "geoip:cn",
                "geoip:private"
              ],
              "domain": [
                "geosite:cn",
                "geosite:speedtest"
              ]
            }
          ]
        }
      },
      "transport": {}
    }
    EOF

    - service v2ray restart


    # http proxy

    - apt-get install privoxy

    # https://github.com/koalaman/shellcheck/wiki/SC2024
    - echo "forward-socks5t / 127.0.0.1:1080 ." | tee -a /etc/privoxy/config > /dev/null

    # listen-address  127.0.0.1:3128
    # listen-address  [::1]:3128
    # replace the http port
    - awk '{gsub(/8118/,"3128");}' /etc/privoxy/config

    - systemctl restart privoxy
