#!/bin/sh
set -eu

echo "==> Installing site config and content"
install -m 0644 /tmp/nginx-site.conf /etc/nginx/sites-available/default
install -m 0644 /tmp/index.html /var/www/html/index.html
rm -f /var/www/html/index.nginx-debian.html

echo "==> Protecting /nginx_status with basic auth"
printf 'admin:%s\n' "$(openssl passwd -6 "$STATUS_PASSWORD")" > /etc/nginx/.htpasswd
chown root:www-data /etc/nginx/.htpasswd
chmod 0640 /etc/nginx/.htpasswd

nginx -t

if [ -d /etc/ssh/sshd_config.d ]; then
  echo "==> Hardening SSH"
  cat > /etc/ssh/sshd_config.d/99-hardening.conf <<'EOF'
PermitRootLogin no
PasswordAuthentication no
X11Forwarding no
EOF
fi

echo "==> Cleaning up"
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/index.html /tmp/nginx-site.conf