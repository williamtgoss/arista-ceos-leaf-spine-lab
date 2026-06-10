# Step 2 — Install ContainerLab

ContainerLab is installed inside your Linux VM environment. All commands in this guide are run in an Ubuntu terminal unless otherwise noted.

---

## 1. Open an Ubuntu Terminal

### Windows (WSL2)
1. In the lower left hand corner of VS Code, find the "><" icon and click on it

     ![great-less-icon](/images/greater-less-icon.png)

2. In the Menu, select "Connect to WSL"
 
      ![VS-Code-WSL](/images/VS-Code-WSL.png)

3. On the VS Code top menu, select Terminal -> New Terminal. This will open a new Terminal window in the lower half of the VS Code.

### macOS (OrbStack)
1. In VS Code, open the Command Palette (`Cmd+Shift+P`), type **Remote-SSH: Connect to Host** and select it
 
     ![mac-remote-ssh](/images/mac-remote-ssh-connect.png)

2. Select your OrbStack Ubuntu VM (**orb**) from the host list

     ![mac-select-orb](/images/mac-remote-ssh-select-orb.png)

3. Once connected, the bottom-left corner of VS Code will show **SSH: orb** (or your VM name)
4. On the VS Code top menu, select Terminal -> New Terminal. This will open a terminal inside the OrbStack VM.

---

## 2. Install ContainerLab

Run the official one-line installer:

```bash
bash -c "$(curl -sL https://get.containerlab.dev)"
```

This script will:
- Detect your Linux distribution and architecture
- Download the latest ContainerLab release
- Install it to `/usr/bin/containerlab`
- Install the `containerlab` bash completion

If you prefer to install a specific version, you can pass the version tag:

```bash
bash -c "$(curl -sL https://get.containerlab.dev)" -- -v 0.57.0
```

> **Note:** ContainerLab requires `sudo` to create network namespaces and manage container networking. You do not need to run the installer as root.

---

## 3. Verify the Installation

```bash
containerlab version
```

Expected output (version numbers will vary):

![Containerlab](/images/containerLab.png)


---

## 4. (Optional) Enable Bash Completion

If the installer did not automatically set up bash completion:

```bash
echo 'source <(containerlab completion bash)' >> ~/.bashrc
source ~/.bashrc
```

You can now press Tab to autocomplete ContainerLab commands and flags.

---

## 5. Check Docker Connectivity

ContainerLab uses Docker to manage node containers. Confirm ContainerLab can reach Docker:

```bash
sudo containerlab version
docker ps
```

Both commands should return without errors and appear as shown below.

![DockerandContainerlab](/images/DockerContainerLab-validate.png)

If `docker ps` fails, revisit Step 1: [Windows (WSL2)](01-wsl-docker.md) or [macOS (OrbStack)](01-mac-orbstack-docker.md).

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `curl: command not found` | `sudo apt-get install -y curl` |
| `containerlab: command not found` after install | Close and reopen the terminal; or run `source ~/.bashrc` |
| `permission denied` when running `containerlab deploy` | Always prefix ContainerLab deploy/destroy commands with `sudo` |
| ContainerLab can't find Docker socket | **Windows:** Confirm Docker Desktop WSL integration is enabled for Ubuntu (see Step 1). **macOS:** Confirm Docker is running inside the OrbStack VM with `docker ps` |

---

Next: [Download and import the cEOS 4.35.4M image](03-ceos-image.md)
