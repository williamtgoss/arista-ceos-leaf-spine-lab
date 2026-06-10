# Step 1 — Install OrbStack and Docker (macOS)

ContainerLab runs on Linux. On macOS, we use OrbStack to create a lightweight Ubuntu virtual machine that provides the Linux environment. Docker is then installed inside the VM to manage containers.

> **Requirements:** macOS on Apple Silicon (M1 / M2 / M3 / M4).

---

## 1. Install OrbStack

OrbStack is a lightweight alternative to Docker Desktop that can run Linux virtual machines on macOS.

1. Download OrbStack from **https://orbstack.dev/download**
2. Open the downloaded `.dmg` file and drag **OrbStack** into your **Applications** folder
3. Launch OrbStack from Applications
4. Follow the on-screen prompts to complete the initial setup

> **Note:** OrbStack can also be installed via Homebrew: `brew install orbstack`

---

## 2. Create an Ubuntu Virtual Machine

### Via the OrbStack UI

1. Open OrbStack
2. Click on **Linux Machines** in the sidebar (or select the **Machines** tab)
3. Click **New Machine** (or the **+** button)
4. Select **Ubuntu** as the distribution
5. Leave the default name or enter a name of your choice (e.g., `ubuntu`)
6. Click **Create**

### Via the Terminal

Open **Terminal** on your Mac and run:

```bash
orb create ubuntu
```

This creates and starts an Ubuntu VM. To enter the VM shell at any time:

```bash
orb shell
```

---

## 3. Install Docker Inside the Ubuntu VM

Enter your Ubuntu VM:

```bash
orb shell
```

Run the automated Docker installation script from this repository:

```bash
bash -c "$(curl https://raw.githubusercontent.com/williamtgoss/arista-ceos-leaf-spine-lab/refs/heads/master/docs/Scripts/installdocker.sh)"
```

The script will:
- Update package lists
- Install Docker CE and its dependencies
- Add your user to the `docker` group

After the script completes, **exit and re-enter the VM** to pick up the new group membership:

```bash
exit
orb shell ubuntu
```

---

## 4. Verify Docker Works

Inside your Ubuntu VM, run:

```bash
docker run hello-world
```

You should see:

```
Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took ...

-Message truncated-
```

If you receive a permission error, confirm your user is in the docker group:

```bash
sudo usermod -aG docker $USER
```

Then exit and re-enter the VM (`exit`, then `orb shell ubuntu`) and retry.

---

## 5. Verify macOS Filesystem Access

OrbStack mounts your macOS filesystem inside the VM at `/mnt/mac/`. This is how you will access files downloaded on your Mac (such as the cEOS image) from within the VM.

Verify the mount is working:

```bash
ls /mnt/mac/Users/
```

You should see your macOS username listed. This path is the equivalent of WSL2's `/mnt/c/` on Windows.

---

## Continue to 02-containerlab-install.md


Next: [Install ContainerLab](02-containerlab-install.md)

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| OrbStack won't install | Ensure you are running macOS 13 (Ventura) or later on Apple Silicon |
| `orb create ubuntu` fails | Check that OrbStack is running (look for the OrbStack icon in the menu bar) |
| `docker: permission denied` in VM | Add user to docker group: `sudo usermod -aG docker $USER`, then exit and re-enter the VM |
| `/mnt/mac/` is empty or missing | Ensure OrbStack has file access permissions in macOS System Settings → Privacy & Security → Files and Folders |
| VM is slow or unresponsive | Close other VMs in OrbStack; ensure you have at least 16 GB RAM available |

---
