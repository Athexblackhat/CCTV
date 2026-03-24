# 📹 AutoCCTVPenTest Toolkit v4.0

<div align="center">

![Version](https://img.shields.io/badge/version-4.0-red)
![License](https://img.shields.io/badge/license-educational-blue)
![Platform](https://img.shields.io/badge/platform-Linux-green)
![Bash](https://img.shields.io/badge/bash-4.0+-yellow)

### Ultimate CCTV Security Assessment & Penetration Testing Framework

**Created by: ATHEX BL4CK H4T**  
*Pakistani Cyber Security Researcher | Web Developer | Security Expert*

</div>

---

## 📋 Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Tool Components](#tool-components)
- [Detailed Usage](#detailed-usage)
- [Modules Explained](#modules-explained)
- [Configuration](#configuration)
- [Output Structure](#output-structure)
- [Supported Cameras](#supported-cameras)
- [Ethical Guidelines](#ethical-guidelines)
- [Troubleshooting](#troubleshooting)
- [Legal Disclaimer](#legal-disclaimer)

---

## 🔍 Overview

**AutoCCTVPenTest Toolkit** is a comprehensive, automated security assessment framework designed for authorized penetration testing of CCTV/IP camera systems. It provides a complete suite of tools for discovering, analyzing, and reporting vulnerabilities in surveillance infrastructure.

### What This Tool Does:
- 🔎 Discovers CCTV devices on networks
- 🎯 Identifies camera manufacturers (Hikvision, Dahua, Axis, etc.)
- 🔓 Tests for default credentials and weak passwords
- 📡 Finds and captures RTSP video streams
- ⚠️ Detects known vulnerabilities (CVEs)
- 📊 Generates professional HTML reports
- 🎨 Features animated terminal interface

### What This Tool Does NOT Do:
- ❌ Perform illegal surveillance
- ❌ Attack systems without permission
- ❌ Steal or distribute footage
- ❌ Cause damage to equipment

---

## ✨ Features

### Core Capabilities
| Feature | Description |
|---------|-------------|
| **Network Discovery** | Fast port scanning for CCTV-specific ports (80, 443, 554, 37777, etc.) |
| **Service Fingerprinting** | Identifies CCTV brands and models |
| **Vulnerability Scanner** | Checks for known CVE exploits |
| **Credential Attacks** | Tests default passwords and brute forces logins |
| **RTSP Stream Hunter** | Discovers and tests RTSP video streams |
| **Live Stream Capture** | Records accessible video feeds |
| **Config Extraction** | Downloads configuration files from compromised devices |
| **HTML Reporting** | Generates professional penetration test reports |

### Animation Effects
- Matrix digital rain
- CCTV camera sweep animation
- Hacking terminal simulation
- Progress spinners and bars
- Explosion/glitch effects
- Typewriter text effects
- Security shield animation

---

## 🚀 Installation

### System Requirements
- **OS**: Linux (Kali Linux, Ubuntu, Debian, Parrot OS recommended)
- **RAM**: Minimum 2GB (4GB+ recommended)
- **Disk**: 500MB free space
- **Network**: LAN access for scanning

### Clone the Repository
```
git clone https://github.com/Athexblackhat/CCTV.git
cd CCTV
chmod +x *.sh
```
### Install required packages
```
sudo apt update
sudo apt install -y nmap curl ffmpeg python3 python3-pip openssl
```
### Install optional tools for advanced features
```
sudo apt install -y hydra nikto whatweb dirb masscan parallel
```
### Install Python Modules
```
pip3 install requests urllib3 colorama bs4

```
## 🎮 Quick Start

### Launch the main toolkit menu
./run.sh

### 🛠️ Tool Components

Network discovery

Service fingerprinting

Vulnerability scanning

Credential attacks

RTSP stream hunting

Configuration extraction

Report generation



### 📊 Sample Report Output

html
📹 CCTV Penetration Test Report
================================

*Executive Summary:*
- Systems Found: 12
- Credentials: 3
- Streams: 5
- Vulnerabilities: 8

*Discovered Systems:*
• 192.168.1.10 - Hikvision DS-2CD2032
• 192.168.1.11 - Dahua IPC-HFW4300S

*Found Credentials:*
• 192.168.1.10:80:admin:12345 (Default)
• 192.168.1.11:80:admin:admin (Default)

*Accessible Streams:*
• rtsp://192.168.1.10:554/stream1
• rtsp://admin:12345@192.168.1.10:554/main

*Vulnerabilities Found:*
• CVE-2017-7921 on 192.168.1.10:80
• Default credentials on 192.168.1.11:80



## ⚠️ IMPORTANT LEGAL NOTICE ⚠️

This tool is provided for EDUCATIONAL and AUTHORIZED SECURITY TESTING purposes only.

By using this software, you agree to:
1. Use only on systems you own or have explicit permission to test
2. Comply with all applicable laws and regulations
3. Accept full responsibility for your actions
4. Not use for any illegal activities

The author (ATHEX BL4CK H4T) assumes no liability for:
- Misuse of this tool
- Damage caused by unauthorized testing
- Violation of laws or regulations
- Any legal consequences resulting from use

UNAUTHORIZED ACCESS TO COMPUTER SYSTEMS IS ILLEGAL.
This tool is designed for security professionals and researchers
to improve the security of their own systems.


## 📜 Version History
Version		Changes
4.0		   Ultimate Edition - Added animations, improved detection, enhanced reporting
3.0		   Added RTSP stream capture, configuration extraction
2.0		   Added vulnerability scanning, credential attacks
1.0		   Initial release with basic discovery


<div align="center">
"Securing the Digital World, One Line at a Time"
Made with 🔐 by ATHEX BL4CK H4T
</div>
T
