#!/bin/bash
#--------supress most of userinteraction------------#
export DEBIAN_FRONTEND=noninteractive

#----------------server ip getter-------------------#
wget https://rawgit.com/rsp/scripts/master/internalip
chmod a+x internalip
serverip = $(internalip)
echo $serverip

#------supress userinteraction in mail, slapd--------#
echo "postfix postfix/mailname string $serverip" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections
echo "slapd/root_password password 123" | debconf-set-selections
echo "slapd/root_password_again 123" | debconf-set-selections
echo "graphite-carbon graphite-carbon/postrm_remove_databases boolean false" | sudo debconf-set-selections

echo Activating the Initiative protocols Hades

sudo add-apt-repository -q -y --force-yes ppa:linrunner/tlp
echo "deb https://packagecloud.io/grafana/stable/debian/ stretch main" | sudo tee -a /etc/apt/sources.list #grafana
GET https://s3-eu-west-1.amazonaws.com/deb.robustperception.io/41EFC99D.gpg | apt-key add -
curl https://packagecloud.io/gpg.key | sudo apt-key add - #grafana
sudo apt-get update -q -y
/bin/bash -c "$(curl -sL https://git.io/vokNn)" #apt-fast install
sudo apt-fast install -q -y --force-yes preload tlp tlp-rdw indicator-cpufreq collectd collectd-utils zsh  git-core
sudo tlp start

echo Activating the Initiative protocols Gaia
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh #zsh install

sudo apt-fast install -q -y --force-yes grafana apt-transport-https slapd ldap-utils sendmail mc uwsgi uwsgi-plugin-python nginx postgresql libpq-dev python-psycopg2 prometheus prometheus-node-exporter prometheus-pushgateway prometheus-alertmanager cadvisor apache2-utils

sudo useradd --no-create-home --shell /bin/false prometheus
sudo useradd --no-create-home --shell /bin/false node_exporter
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus
echo "global:
scrape_interval: 15s
scrape_configs:
- job_name: 'prometheus'
scrape_interval: 5s
static_configs:
- targets: ['localhost:9090']
- job_name: 'node_exporter'
scrape_interval: 5s
static_configs:
- targets: ['localhost:9100']" > /etc/prometheus/prometheus.yml
sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml
sudo -u prometheus /usr/local/bin/prometheus \
-config.file /etc/prometheus/prometheus.yml \
-storage.local.path /var/lib/prometheus/
sudo systemctl enable prometheus
echo "Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/node_exporter.service
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter
sudo systemctl restart prometheus

sudo htpasswd -c /etc/nginx/.htpasswd 8host
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/prometheus
sudo systemctl reload nginx

sudo service grafana-server start

sudo update-rc.d grafana-server defaults
sudo systemctl enable grafana-server.service
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable grafana-server

grafana-cli plugins install raintank-worldping-app
grafana-cli plugins install ns1-app
grafana-cli plugins install raintank-snap-app
grafana-cli plugins install grafana-example-app
grafana-cli plugins install grafana-worldmap-panel
grafana-cli plugins install grafana-clock-panel
grafana-cli plugins install grafana-piechart-panel
grafana-cli plugins install alexanderzobnin-zabbix-app
grafana-cli plugins install kentik-app
grafana-cli plugins install percona-percona-app
grafana-cli plugins install ryantxu-ajax-panel
grafana-cli plugins install novalabs-annotations-panel
grafana-cli plugins install ayoungprogrammer-finance-datasource
grafana-cli plugins install mtanda-google-calendar-datasource
grafana-cli plugins install natel-plotly-panel
grafana-cli plugins install jasonlashua-prtg-datasource

echo Dashboard avaliable now on $(internalip) and 3000 port

chsh -s `which zsh` #choose zsh as default shell
sudo shutdown -r 0
