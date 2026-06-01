# Step 1 — Install WSL2 and Docker Desktop

ContainerLab runs on Linux. On Windows, we use WSL2 (Windows Subsystem for Linux 2) to provide the Linux environment, and Docker Desktop to manage containers.

---

## 1. Verify Virtualization is Enabled

Open **Task Manager** → **Performance** → **CPU**. Confirm **Virtualization: Enabled** appears at the bottom right. If it shows Disabled, reboot and enable it in your BIOS/UEFI firmware settings (look for "Intel VT-x" or "AMD-V / SVM").

---

## 2. Install WSL2

By default, WSL will install the latest LTS image of Ubuntu. If you want to install a different distro, all support distros can be listed by entering 

```powershell
wsl -- list --online
```

Open **PowerShell as Administrator** (right-click Start → Windows Terminal (Admin)) and run:

```powershell
wsl --install
```

This command:
- Enables the WSL and Virtual Machine Platform Windows features
- Installs the WSL2 Linux kernel
- Sets WSL2 as the default version
- Installs Ubuntu (latest LTS) as the default distribution

* Restart your computer, if prompted.

*** Setting up Username and password for your WSL account ***
Ubuntu will open automatically and ask you to create a UNIX username and password. Choose a username and password — these will be your credentials inside WSL.

### Verify WSL2 is running

Open PowerShell and confirm the version:

```powershell
wsl --list --verbose
```

Expected output:

```
  NAME      STATE           VERSION
* Ubuntu    Running         2
```

If Ubuntu shows VERSION 1, upgrade it:

```powershell
wsl --set-version Ubuntu 2
wsl --set-default-version 2
```

---

## 3. Install Docker on WSL 

Below is a simplifed one line bash script to install doxker on your WSL linux VM
```
bash -c "$(curl https://raw.githubusercontent.com/williamtgoss/arista-ceos-leaf-spine-lab/refs/heads/master/docs/Scripts/installdocker.sh)"
```

---

## 4. Verify Docker Works in WSL

In your **Ubuntu** terminal (search "Ubuntu" in the Start menu or use Windows Terminal → Ubuntu tab) and run:

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

If you receive a permission error, try:

```bash
sudo usermod -aG docker $USER
```

Then close and reopen the Ubuntu terminal and retry.

---

## Continue to 02-Containerlab-install.md


Next: [Install ContainerLab](02-containerlab-install.md)

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `wsl --install` fails with "feature not enabled" | Run PowerShell as Administrator |
| Ubuntu shows as WSL version 1 | Run `wsl --set-version Ubuntu 2` |
| Docker Desktop won't start | Ensure virtualization is enabled in BIOS; check Windows features: "Virtual Machine Platform" and "Windows Subsystem for Linux" are both enabled |
| `docker: permission denied` in WSL | Add user to docker group: `sudo usermod -aG docker $USER`, then restart terminal |

---

