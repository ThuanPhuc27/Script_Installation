cd /opt
git clone https://github.com/nginx/nginx.git
git clone https://github.com/vozlt/nginx-module-vts.git

sudo apt update
sudo apt -y install gcc make build-essential libpcre3-dev libssl-dev zlib1g-dev libgd-dev

cd nginx
./auto/configure --prefix=/var/www/html \
  --sbin-path=/usr/sbin/nginx \
  --conf-path=/etc/nginx/nginx.conf \
  --http-log-path=/var/log/nginx/access.log \
  --error-log-path=/var/log/nginx/error.log \
  --with-pcre \
  --pid-path=/var/run/nginx.pid \
  --lock-path=/var/lock/nginx.lock \
  --with-http_ssl_module \
  --with-http_v2_module \
  --with-http_mp4_module \
  --with-http_addition_module \
  --with-http_image_filter_module=dynamic \
  --with-stream=dynamic \
  --add-module=/opt/nginx-module-vts

sudo make
sudo make install


# kiểm tra cấu hình nginx:
nginx -v


cat << 'EOF' > /etc/nginx/nginx.conf
user www-data;
worker_processes auto;
pid /var/run/nginx.pid;

include /etc/nginx/modules-enabled/*.conf;

events {
    worker_connections 768;
}

http {
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    # SSL protocol
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
    ssl_prefer_server_ciphers on;

    # Log format
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    # Gzip Settings
    gzip on;
    gzip_disable "msie6";

    # Nginx VTS
    vhost_traffic_status_zone;

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;

    # Default server configuration
    server {
        listen 80;
        server_name host.default.com;
        root /usr/share/nginx/html;
        index index.html;

        location / {
            try_files \$uri \$uri/ =404;
        }

        if (\$time_iso8601 ~ "^(\d{4})-(\d{2})-(\d{2})") {
            set \$year \$1;
            set \$month \$2;
            set \$day \$3;
        }

        vhost_traffic_status_filter_by_set_key \$year year::\$server_name;
        vhost_traffic_status_filter_by_set_key \$year-\$month month::\$server_name;
        vhost_traffic_status_filter_by_set_key \$year-\$month-\$day day::\$server_name;

        location /status {
            vhost_traffic_status_bypass_limit on;
            vhost_traffic_status_bypass_stats on;
            vhost_traffic_status_display;
            vhost_traffic_status_display_format html;
            allow 127.0.0.1;
            deny all;
        }
    }
}
EOF



# khởi tạo thư mục, sao chép các file cần thiết
sudo mkdir -p /etc/nginx/{conf.d,sites-available,sites-enabled,modules-available,modules-enabled,modules,snippets,ssl}
cp -v nginx.conf /etc/nginx/nginx.conf
cp -v conf/fastcgi.conf /etc/nginx/
cp -v conf/fastcgi_params /etc/nginx/
cp -v conf/koi-utf /etc/nginx/
cp -v conf/koi-win /etc/nginx/
cp -v conf/mime.types /etc/nginx/
cp -v conf/scgi_params /etc/nginx/
cp -v conf/uwsgi_params /etc/nginx/
cp -v conf/win-utf /etc/nginx/

sudo chown -R root:root /etc/nginx
sudo chmod -R 755 /etc/nginx

cat << EOF > /etc/systemd/system/nginx.service
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/var/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx
ExecReload=/usr/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT \$MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF
