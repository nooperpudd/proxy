#cloud-config

runcmd:
    - apt-get install upgrade
    - apt-get install update -y

    # open system TCP BBR
    # https://github.com/koalaman/shellcheck/wiki/SC2024
    - echo "net.core.default_qdisc=fq" | tee -a /etc/sysctl.conf  > /dev/null
    - echo "net.ipv4.tcp_congestion_control=bbr" | tee -a /etc/sysctl.conf > /dev/null
    - sysctl -p

    # install proxy server
    - bash <(curl -L -s https://install.direct/go.sh)

    - cat <<EOF >/etc/v2ray/config.json
        {
          "log": {
            "access": "/var/log/v2ray/access.log",
            "error": "/var/log/v2ray/error.log",
            "loglevel": "warning"
          },
          "inbounds": [
            {
              "port": 555,
              "protocol": "vmess",
              "settings": {
                "clients": [
                  {
                    "id": "f5222f46-41a8-4d3a-9b31-1e524be44121",
                    "level": 1,
                    "alterId": 233
                  }
                ]
              },
              "streamSettings": {
                "network": "tcp"
              },
              "sniffing": {
                "enabled": true,
                "destOverride": [
                  "http",
                  "tls"
                ]
              }
            }
          ],
          "outbounds": [
            {
              "protocol": "freedom",
              "settings": {}
            },
            {
              "protocol": "blackhole",
              "settings": {},
              "tag": "blocked"
            },
            {
              "protocol": "freedom",
              "settings": {},
              "tag": "direct"
            },
            {
              "protocol": "mtproto",
              "settings": {},
              "tag": "tg-out"
            }

          ],
          "dns": {
            "server": [
              "1.1.1.1",
              "1.0.0.1",
              "8.8.8.8",
              "8.8.4.4",
              "localhost"
            ]
          },
          "routing": {
            "domainStrategy": "IPOnDemand",
            "rules": [
              {
                "type": "field",
                "inboundTag": [
                  "tg-in"
                ],
                "outboundTag": "tg-out"
              }
            ]
          },
          "transport": {
            "kcpSettings": {
              "uplinkCapacity": 100,
              "downlinkCapacity": 100,
              "congestion": true
            },
            "sockopt": {
              "tcpFastOpen": true
            }
          }
        }
        EOF
    - service v2ray restart

