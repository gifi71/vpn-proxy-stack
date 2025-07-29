<!-- markdownlint-disable MD033 -->

<h1 align="center">🛡️ vpn-proxy-stack</h1>

<!-- markdownlint-enable MD033 -->

## 📦 Overview

**vpn-proxy-stack** is a comprehensive Docker-based VPN and proxy solution integrating:

* 🔒 **OpenConnect VPN server (ocserv)** with camouflage support
* 🛠️ **3x-ui** panel for proxy management (Reality proxy)
* 🌐 **Nginx** acting as a TLS SNI multiplexer and reverse proxy
* 🔐 **acme.sh** for automated Let's Encrypt certificate management

After setup, you get a fully functional VPN and proxy stack with ease of deployment, management UI, and automatic TLS certificate handling.

---

## 🚀 Getting Started

### Clone the repository

```bash
git clone https://github.com/gifi71/vpn-proxy-stack.git /opt/vpn-proxy-stack
cd /opt/vpn-proxy-stack
```

### Install Docker

If Docker is not installed yet, install it via the official script:

```bash
curl -sSL https://get.docker.com | sh
```

### Configure environment variables

Edit the `.env` file with your settings. Below is a description of variables and an example:

| Variable            | Description                                                                             | Example               |
| ------------------- | --------------------------------------------------------------------------------------- | --------------------- |
| `DEFAULT_HTTPS`     | Default path for HTTPS traffic fallback                                                 | `default.example.com` |
| `DEFAULT_HTTP`      | Default path for HTTP traffic fallback                                                  | `default.example.com` |
| `CAMOUFLAGE_SECRET` | Secret string used for ocserv camouflage                                                | `secret`              |
| `OCERV_DOMAIN`      | Domain name used for OpenConnect VPN                                                    | `vpn.example.com`     |
| `REALITY_DOMAIN`    | Domain name used for Reality proxy                                                      | `reality.example.com` |
| `PORTS`             | 🔧 (Optional) Firewall port mappings (`<container_port>:<client_ip>:<client_port> ...`) | Not set               |
| `EXPORTER_ENABLED`  | 📊 (Optional) Enable ocserv-exporter (`1` = enable, `0` = disable)                      | `0`                   |
| `EXPORTER_INTERVAL` | ⏱️ (Optional) Interval for ocserv-exporter scrape requests                              | `30s`                 |
| `EXPORTER_BIND`     | 📡 (Optional) IP and port where ocserv-exporter listens                                 | `0.0.0.0:8000`        |

> 💡 **Note:** ocserv-exporter metrics by default are only available inside the `ocserv` container.

---

### ⚙️ Generate configuration files

```bash
./gen_conf.sh
```

---

### 🧾 (Optional) Customize OpenConnect server configuration

* Main config: `volumes/ocserv/ocserv.conf`
* Per-user configs: put files in `volumes/ocserv/config-per-user/`

**Example per-user config:**

```ini
# Assign static IP to user
explicit-ipv4 = 10.10.0.50

# Route all client traffic through VPN
route = default
```

Or:

```ini
explicit-ipv4 = 10.10.0.100
route = 10.0.1.0/24
# Optional - notify server that client handles this subnet
# iroute = 10.0.1.0/24
```

---

### 🐳 Start the stack with Docker Compose

```bash
docker compose up -d
```

---

### 🔏 Generate SSL certificates

```bash
./get_cert.sh
```

---

### 🔥 Configure firewall

Example UFW rules:

```bash
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable
```

---

### 👥 Add OpenConnect VPN users

```bash
docker exec ocserv ocpasswd -c /etc/ocserv/ocpasswd <username>
```

---

## 🌍 Connecting to OpenConnect VPN

* **Linux:**

```bash
sudo openconnect "https://<OCERV_DOMAIN>/?<CAMOUFLAGE_SECRET>"
```

* **Windows & Android:**
  Use Cisco AnyConnect VPN client.

---

## 💻 Accessing 3x-ui Web Interface

Create SSH tunnel:

```bash
ssh -L 2053:localhost:2053 <your_user>@<your_server_ip>
```

Then open in browser:

```url
http://localhost:2053
```

---

## 🔮 Creating a Reality Proxy and Users in 3x-ui

* Use **TCP** protocol on port **443**
* Enable **Proxy Protocol**
* Set:

  ```plain
  Destination: <REALITY_DOMAIN>:443
  SNI:         <REALITY_DOMAIN>
  Flow:        xtls-rprx-vision
  ```

---

## 📲 Connecting to Reality Proxy

* **Linux & Windows:** Hiddify or NekoBox
* **Android:** husi or NekoBox
* **iOS:** FoXray

---

## 📄 License

This project is licensed under the **GPLv3 License**.
