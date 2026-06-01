# Step 4 — Install the VSCode ContainerLab Extension

The ContainerLab VSCode extension (by SR Linux Labs) lets you deploy, manage, and connect to ContainerLab topologies directly from VSCode — without needing to remember CLI commands.

---

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

### Via the command line

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

## 4. Open This Repository in VSCode

The easiest way to work with this repo is to open it from WSL2 using the **Remote - WSL** extension.

### Install Remote - WSL

1. In the Extensions panel, search for **Remote - WSL**
2. Install the extension by **Microsoft** (Extension ID: `ms-vscode-remote.remote-wsl`)

### Open the Repo

In your Ubuntu terminal, navigate to where you cloned this repo and open it in VSCode:

```bash
cd ~/arista-leaf-spine
code .
```

VSCode will open a new window connected to your WSL2 environment. A green **WSL: Ubuntu** badge will appear in the bottom-left corner confirming the remote connection.

> **Why use Remote - WSL?** ContainerLab files and Docker images live in the WSL filesystem. Editing them from WSL-connected VSCode avoids cross-filesystem performance issues and ensures ContainerLab can access all paths correctly.

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
