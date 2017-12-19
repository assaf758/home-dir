#!/bin/bash
systemctl --user stop dynamic_dns.timer
sudo forticlientsslvpn-expect.sh
systemctl --user start dynamic_dns.timer

