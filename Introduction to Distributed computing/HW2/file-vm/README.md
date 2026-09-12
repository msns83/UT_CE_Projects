# File Service (VM3)

## Overview
This service securely acts as an internal file repository, providing files only when explicitly requested through the RPC network by the Web Service.

## Step-by-Step Deployment Guide

Follow this guide to deploy these microservices from scratch on an Apple Silicon Mac or Linux system using **Multipass**.

### Step 1: Install Multipass
**On macOS (using Homebrew):**
```bash
brew install --cask multipass
```
**On Linux:**
```bash
sudo snap install multipass
```

### Step 2: Create the VMs
Spin up the three separate VMs (Nodes):
```bash
multipass launch --name node-1
multipass launch --name node-2
multipass launch --name node-3
multipass list
```
*(Note down the IP addresses from the list command)*

### Step 3: Compile the Go Code (Cross-Compilation)
Run this on your host machine to build the Linux executables.
*(Note: If your host is an x86_64 system, replace `GOARCH=arm64` with `GOARCH=amd64`)*
```bash
# Compile Auth Service
cd auth-vm && GOOS=linux GOARCH=arm64 go build -o auth-server main.go && cd ..

# Compile File Service
cd file-vm && GOOS=linux GOARCH=arm64 go build -o file-server main.go && cd ..

# Compile Web Service
cd web-vm && GOOS=linux GOARCH=arm64 go build -o web-server main.go && cd ..
```

### Step 4: Transfer Files to the VMs

**For Node 2 (Auth Service):**
```bash
multipass transfer auth-vm/auth-server node-2:auth-server
multipass transfer auth-vm/users.json node-2:users.json
```

**For Node 3 (File Service):**
```bash
multipass exec node-3 -- mkdir -p file-vm/files file-vm/images
multipass transfer file-vm/file-server node-3:file-vm/file-server
multipass transfer file-vm/images/logo.png node-3:file-vm/images/logo.png
```

**For Node 1 (Web Service):**
```bash
multipass exec node-1 -- mkdir -p web-vm/templates
multipass transfer web-vm/web-server node-1:web-vm/web-server
multipass transfer web-vm/templates/login.html node-1:web-vm/templates/login.html
multipass transfer web-vm/templates/welcome.html node-1:web-vm/templates/welcome.html
```

### Step 5: Start the Services!
Open three separate terminal windows to start each service.

**Terminal 1 (VM2 - Auth Service):**
```bash
multipass shell node-2
./auth-server
```

**Terminal 2 (VM3 - File Service):**
```bash
multipass shell node-3
cd file-vm
./file-server
```

**Terminal 3 (VM1 - Web Service):**
```bash
multipass shell node-1
cd web-vm

# Replace these IPs with the ACTUAL IPs assigned to your node-2 and node-3!
export AUTH_VM_IP="192.168.x.x:8002"
export FILE_VM_IP="192.168.x.x:8003"

./web-server
```

### Step 6: Test the System
Find the IP address of `node-1`. Open your web browser and go to:
**http://<node-1-ip>:8000/login**

Login Credentials:
- **alice** / **alice123**
- **bob** / **bob123**
- **admin** / **admin123**

### Step 7: Clean Environment
in order to stop your VMs you can run:
```bash
multipass stop --all
```
or you can stop them one by one using:
```bash
multipass stop node-1 # use your VM name
```
to start them again use:
```bash
multipass start --all
```
and to completely delete them, use:
```bash
multipass delete --all
multipass purge
```

## How it works
- It exposes an RPC server using `net/rpc` on port `8003`.
- It registers `FileService` which has a method `GetFile`.
- When called remotely by VM1, it verifies that the requested directory is strictly `files` or `images` to prevent unwanted path-traversal hacks.
- If safe, it statically reads the requested file from the disk into a byte array, and transmits those bytes back across the network through the RPC reply object structure.