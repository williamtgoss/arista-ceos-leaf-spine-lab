# Step 4 — Install the VSCode ContainerLab Extension

The ContainerLab VSCode extension (by SR Linux Labs) lets you deploy, manage, and connect to ContainerLab topologies directly from VSCode — without needing to remember CLI commands.

---
# Windows 11 Install

## 1. Install Visual Studio Code

If VSCode is not already installed:

1. Download from **https://code.visualstudio.com/**
2. Run the installer and accept the defaults
3. During installation, check **Add to PATH** so you can open VSCode from the terminal with the `code` command

---

## 2. Install the ContainerLab Extension

### Connect VSCode to local WSL instance

1. In the lower left hand corner of VS Code, find the "><" icon and click on it
 
     ![great-less-icon](/images/greater-less-icon.png)

2. In the Menu, select "Connect to WSL"
 
      ![VS-Code-WSL](/images/VS-Code-WSL.png)


### Via the VS Code Extensions Marketplace

1. Open VSCode
2. Click the **Extensions** icon in the left sidebar (looks like 4 boxes with the upper left box stilted on its side) or press `Ctrl+Shift+X`
3. Search for **ContainerLab**
4. Click **Install** on the extension by **srlinux** (Extension ID: `srl-labs.vscode-containerlab`)

### Via the Terminal in Visual Studio Code
 
```bash
code --install-extension srl-labs.vscode-containerlab
```

---

# macOS Install

## 1. Install Visual Studio Code

If VSCode is not already installed:

1. Download from **https://code.visualstudio.com/**
2. Open the downloaded `.zip` file and drag **Visual Studio Code** into your **Applications** folder
3. Launch VSCode and optionally install the shell command: open the Command Palette (`Cmd+Shift+P`) → type **Shell Command: Install 'code' command in PATH**

---

## 2. Connect VSCode to Your OrbStack VM

VSCode includes the Remote-SSH extension by default, so no additional extensions are needed for this step.

1. Open the Command Palette (`Cmd+Shift+P`), type **Remote-SSH: Connect to Host** and select it
 
     ![mac-remote-ssh](/images/mac-remote-ssh-connect.png)

2. Select your OrbStack Ubuntu VM (**orb**) from the host list
 
     ![mac-select-orb](/images/mac-remote-ssh-select-orb.png)

3. A new VSCode window will open connected to the VM — the bottom-left corner will show **SSH: orb** (or your VM name)

---

## 3. Install the ContainerLab Extension

Once connected to the VM, install the ContainerLab extension so it runs on the remote host:

### Via the VS Code Extensions Marketplace

1. Click the **Extensions** icon in the left sidebar or press `Cmd+Shift+X`
2. Search for **ContainerLab**
3. Click **Install** on the extension by **srlinux** (Extension ID: `srl-labs.vscode-containerlab`)

> **Note:** When connected via Remote-SSH, you may see an **Install in SSH: orb** button instead of a plain **Install** button. Click it to install the extension on the remote VM rather than locally.

### Via the Terminal in Visual Studio Code
 
```bash
code --install-extension srl-labs.vscode-containerlab
```

---

# Extension Features (All Platforms)

Once installed, the ContainerLab extension adds a **ContainerLab** panel to the VSCode sidebar. From there you can:

| Action | How |
|--------|-----|
| Deploy a lab | Right-click a `.clab.yaml` file → **Deploy lab** |
| Destroy a lab | Right-click a running lab → **Destroy lab** |
| View node status | Expand the topology tree to see each node and its state |
| SSH into a node | Click the SSH icon next to a running node |
| Open node in browser | Click the browser icon (opens web management if available) |
| View node logs | Right-click a node → **Show logs** |

---

## 5. Open New Folder in VS Code and Clone this repo.

Create a new folder workspace to clone the example repo to stand up your first ContainerLab

### 1. Create a new folder in your Linux VM for this repo and move your terminal CLI to that location.

This can be done using the CLI terminal or your native OS. This folder can reside in either the Linux VM or on your workstation local storage. Keep note of the folders location and name for reference in the next step.

**Windows (WSL2) Examples**

- Windows mapped drives can be found in `/mnt/`. A Windows C: drive is located at `/mnt/c/`

```
mkdir /mnt/c/my-repo
cd /mnt/c/my-repo
```

Creating a folder in the WSL user home directory:
```
mkdir /home/LabUser1/my-repo
cd /home/LabUser1/my-repo
```

**macOS (OrbStack) Examples**

- macOS drives can be found in `/mnt/mac/`

```
mkdir /mnt/mac/Users/<your-mac-username>/my-repo
cd /mnt/mac/Users/<your-mac-username>/my-repo
```

Creating a folder in the OrbStack VM home directory:
```
mkdir ~/my-repo
cd ~/my-repo
```

### 2. In VS Code set your "Explorer" context to the same new folder 

Select **File -> Open Folder** and navigate to the folder created in step 1 and select "OK"
  - **Windows:** your normal Windows mapped drives can be found in `/mnt/`. A Windows C: is located at `/mnt/c/`. Users can also use the "Show Local" button for the native Windows file navigator.
  - **macOS:** your Mac filesystem is at `/mnt/mac/` inside the VM. You can also use the VM-local home directory.

### 3. Select the new folder and click "select folder" button.
### 4. Open a new Linux Terminal by selecting **View -> Terminal**
   - **Windows:** Validate the terminal window is in WSL/Linux rather than PowerShell. If needed, select the dropdown to the right of the "+" in the terminal window and select your Linux/WSL terminal.
   - **macOS:** The terminal will already be connected to the OrbStack VM via SSH.
### 5. In your Linux terminal, enter:
   ```
   git clone https://github.com/williamtgoss/arista-ceos-leaf-spine-lab.git
   ```


---


## Troubleshooting

| Symptom | Fix |
|---------|-----|
| ContainerLab panel is empty | Ensure you have a `.clab.yaml` file open in your workspace |
| "Cannot connect to Docker" error | **Windows:** Confirm Docker Desktop is running and WSL integration is enabled. **macOS:** Confirm Docker is running in the OrbStack VM with `docker ps` |
| Deploy fails with permission error | Check that `containerlab.sudoEnabled` is `true` in settings |
| Nodes show as stopped after deploy | Wait 30–60 seconds for cEOS to boot; refresh the panel |
| "Insufficient permission" error | Reboot the VM and reconnect |

---

Next: [Clone this repo and run the lab](05-running-the-lab.md)
