# Legacy TLS Proxy for Retro Unix Systems

**Secure HTTPS Downloads for Legacy Machines (SunOS, IRIX, Ultrix, etc.)**

This project provides a modern TLS reverse proxy using [Caddy](https://caddyserver.com/) and a simple Bourne shell script to allow ancient `wget` clients to download files from modern HTTPS servers.

Originally built and tested on a Sun Microsystems SPARCstation 20 running **SunOS 4.1.4**.

---

## Why?

Old UNIX systems (like SunOS 4.1.4, IRIX, Ultrix, AIX) cannot speak modern HTTPS:
- Their SSL libraries are obsolete
- Their `wget` clients are too old
- Their `/bin/sh` shells are non-POSIX

This project creates a local HTTPS-capable proxy server that bridges the gap.

---

## Tested Environment

| Component | Details |
|:----------|:--------|
| Host machine | SPARCstation 20 |
| OS | SunOS 4.1.4 |
| Compiler | gcc 2.95.3 with binutils 2.13.2.1 |
| Shell | /bin/sh (classic Bourne shell) |
| `wget` | 1.5.3 (renamed for proxy script convenience) |
| Proxy server | Caddy 2.7.6 (via Docker) |

✅ Proven working on real hardware.

---

## How it Works

- Caddy acts as an HTTPS reverse proxy, downgrading modern HTTPS to plain HTTP locally.
- The `wget` shell wrapper transparently rewrites URLs to use the proxy.
- Legacy `wget` believes it is talking to plain HTTP servers.

---

## Install Instructions

### 1. On Your Modern Host (Proxy Server)

- Install Docker.

- Deploy the proxy with:

```bash
docker-compose up -d
```

This launches Caddy listening on **port 8081**.

---

### 2. On Your Retro UNIX Machine

- Backup your original `wget` binary:

```sh
mv /usr/local/bin/wget /usr/local/bin/wget.bin
```

- Install the provided `wgetproxy.sh` as `wget`:

```sh
cp wgetproxy.sh /usr/local/bin/wget
chmod +x /usr/local/bin/wget
```

- Ensure `/usr/local/bin` is early in your `$PATH`.

✅ Now `wget` can fetch modern HTTPS URLs automatically.

---

## Quick Example

```sh
wget https://ftp.gnu.org/gnu/gzip/gzip-1.2.4.tar.gz
```

Internally, it is rewritten to:

```sh
http://your-proxy-ip:8081/https/ftp.gnu.org/gnu/gzip/gzip-1.2.4.tar.gz
```

Caddy connects securely using TLS 1.2/1.3 behind the scenes.


---

## Tested Proxy Server Environment

| Component | Details |
|:----------|:--------|
| Host machine | Modern PC |
| OS | Ubuntu 22.04 LTS |
| Docker version | 27.3.1 |
| Caddy container | Caddy 2.7.6 (via Docker) |

✅ Proven working on a secure local network.

---

## Full Instructions

### Setting up the Proxy on Ubuntu 22.04

1. Install Docker:
   ```bash
   sudo apt update
   sudo apt install docker.io docker-compose
   ```

2. Clone or copy this repository:
   ```bash
   git clone https://github.com/yourusername/legacy-tls-proxy.git
   cd legacy-tls-proxy
   ```

3. Start the Caddy proxy server:
   ```bash
   docker-compose up -d
   ```

4. Caddy will now listen on port **8081**.

---

### Setting up the Client on SunOS 4.1.4

1. Move the original wget:
   ```sh
   mv /usr/local/bin/wget /usr/local/bin/wget.bin
   ```

2. Install the proxy script:
   ```sh
   cp wgetproxy.sh /usr/local/bin/wget
   chmod +x /usr/local/bin/wget
   ```

3. Ensure `/usr/local/bin` is early in your `$PATH`.

✅ Now you can use wget transparently to fetch HTTPS URLs.

---


---

## License

This project is licensed under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).
