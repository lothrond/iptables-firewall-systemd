BIN_DIR := /usr/sbin
SYSTEMD_DIR := /etc/systemd/system

.PHONY: install
install: iptables-firewall.sh iptables-firewall.service iptables-firewall-test.service
	cp iptables-firewall.sh $(BIN_DIR)
	chown root:root $(BIN_DIR)/iptables-firewall.sh
	chmod 750 $(BIN_DIR)/iptables-firewall.sh
	cp iptables-firewall.service $(SYSTEMD_DIR)
	cp iptables-firewall-test.service $(SYSTEMD_DIR)
	systemctl daemon-reload
	systemctl enable iptables-firewall.service
	systemctl start iptables-firewall.service

.PHONY: remove
remove:
	systemctl stop iptables-firewall.service
	systemctl disable iptables-firewall.service
	rm $(BIN_DIR)/iptables-firewall.sh
	rm $(SYSTEMD_DIR)/iptables-firewall.service
	rm $(SYSTEMD_DIR)/iptables-firewall-test.service
