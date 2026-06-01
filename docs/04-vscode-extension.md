# Step 4 — Install the VSCode ContainerLab Extension

The ContainerLab VSCode extension (by SR Linux Labs) lets you deploy, manage, and connect to ContainerLab topologies directly from VSCode — without needing to remember CLI commands.

---
# Window 11 Install

## 1. Install Visual Studio Code

If VSCode is not already installed:

1. Download from **https://code.visualstudio.com/**
2. Run the installer and accept the defaults
3. During installation, check **Add to PATH** so you can open VSCode from the terminal with the `code` command

---

## 2. Install the ContainerLab Extension

### Via the Extensions Marketplace (recommended)

1. Open VSCode
2. Click the **Extensions** icon in the left sidebar (or press `Ctrl+Shift+X`)
3. Search for **ContainerLab**
4. Click **Install** on the extension by **srlinux** (Extension ID: `srl-labs.vscode-containerlab`)

### Via the Terminal in Virtual Studio Code

1. In VS Code, from the top menu, select View --> Terminal
2. VS Code may or maynot have not provided a Windows "Powershell" by default (you may be in your WSL instance). Open a new powershell terminal by:
   - In the "Terminal Window" in VS Code, find "+" button and select the drop to the right and select "Powershell"
![vscode-powershell](/images/powershell-vcCode.png)
   - Once a new Powershell CLI terminal is opened, enter the following
 
```bash
code --install-extension srl-labs.vscode-containerlab
```

---

## 3. Extension Features

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

## 4. Open new Folder in VScode and Clone this repo.

The easiest way to work with this repo is to open it from WSL2 using the **Remote - WSL** extension.

1. In VS Code, select **File-> Open Folder**
2. Navigate to a file location in which you want you host your repository
3. Right-click and create a new Folder named 
```
arista-ceos-leaf-spine-lab
```
4. Select the new folder and click "select folder" button.
5. Open a new WSL "Linux" Terminal by selecting **View -> Terminal**
   - Validate Terinal window is in WSL/Linux, rather than PowerShell
   - if needed, select the dropdown to the right of the "+" in the terminal window and select your Linix/WSL terminal 
6. In WSL, enter
   ```
   git clone https://github.com/williamtgoss/arista-ceos-leaf-spine-lab.git
   ```


---

## 5. Configure the Extension (Optional)

The extension works out of the box with no configuration needed. Optional settings can be found in VSCode's settings (`Ctrl+,`) by searching for `containerlab`.

Common settings:

| Setting | Default | Description |
|---------|---------|-------------|
| `containerlab.sudoEnabled` | `true` | Run ContainerLab commands with sudo |
| `containerlab.dockerHost` | (auto) | Custom Docker socket path |

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| ContainerLab panel is empty | Ensure you have a `.clab.yaml` file open in your workspace |
| "Cannot connect to Docker" error | Confirm Docker Desktop is running and WSL integration is enabled |
| Deploy fails with permission error | Check that `containerlab.sudoEnabled` is `true` in settings |
| Nodes show as stopped after deploy | Wait 30–60 seconds for cEOS to boot; refresh the panel |

---

Next: [Clone this repo and run the lab](05-running-the-lab.md)
