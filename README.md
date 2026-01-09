# 🛡️ Security Sentry & Intrusion Prevention

A real-time Linux security suite designed to monitor, alert, and defend against unauthorized SSH access.

## 🛠️ Current Setup
- **Hardware:** Headless Laptop (Lid-Closed Mode)
- **OS:** Ubuntu 24.04 LTS
- **Monitoring:** Real-time Discord Webhook Integration

## ✅ Completed Foundations
- [x] Initial OS install and update.
- [x] **Key-based SSH Authentication:** Disabled password logins for a "Zero-Trust" baseline.
- [x] **PAM Integration:** Hooked into the Linux Pluggable Authentication Modules for instant login alerts.
- [x] **Intrusion Prevention System:** Strike-based IP banning using `iptables` and log-parsing.
- [x] **Hardware Patch:** Resolved CMOS Checksum failure via software NTP synchronization.

## 🧩 Implementation Challenges & Solutions

| Challenge | Technical Solution | Why it matters |
| :--- | :--- | :--- |
| **Hardware Time Drift** | Integrated `systemd-timesyncd` for NTP sync. | Prevents SSL/TLS handshake failures during Git operations. (Laptop server has dead CMOS) |
| **Headless Stability** | Modified `logind.conf` to handle `LidSwitchIgnore`. | Allows the server to remain active in a compact, lid-closed form factor. |
| **Login Latency** | Implemented **Asynchronous execution** using `&` in Bash. | Ensures security scripts don't block user access during network delays. |
| **Brute-Force Noise** | Built a strike-based ban system with `iptables`. | Reduces log clutter and system resource usage by dropping malicious traffic. |

## 📝 Engineering Log

### Jan 9, 2026
- **Asynchronous Execution:** Refactored the Sentry script with backgrounding (`&`) and timeouts (`-m 2`) to fix SSH login hangs.
- **Bot-Catcher Service:** Architected a `systemd` background service to parse `/var/log/auth.log` for brute-force patterns.
- **Automated Defensive Action:** Implemented a "3-strike" warning and "5-strike" ban policy. Malicious IPs are now dynamically added to the `iptables` DROP list.
- **Stealth Strategy:** Configured the firewall to "Drop" rather than "Reject" banned traffic, making the server appear offline to malicious scanners.

### Jan 7, 2026
- Initialized GitHub repository and established modular directory structure.
- Successfully configured `logind.conf` for headless lid-closed operation.
- Verified system thermal stability at 28°C under idle server load.
