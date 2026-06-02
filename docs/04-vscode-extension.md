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

### Connect VSCode to local WSL instance

1. In the lower left hand corner of VS code, find the "><" icon and click on it
     [great-less-icon](/images/greater-less-icon.png)
2. In the Menu, select "Connect to WSL"
      [VS-Code-WSL](/images/VS-Code-WSL.png)


### Via the VS Code Extensions Marketplace

1. Open VSCode
2. Click the **Extensions** icon in the left sidebar (looks like 4 boxes with the upper left box stilted on its side) or press `Ctrl+Shift+X`
3. Search for **ContainerLab**
4. Click **Install** on the extension by **srlinux** (Extension ID: `srl-labs.vscode-containerlab`)

### Via the Terminal in Virtual Studio Code
 
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

## 4. Open New Folder in VS Code and Clone this repo.

Create a new folder workspace to clone the example repo to stand up your first ContainerLab

### 1. Create a new folder in your ideal local workstation for this repo and move your terminal CLI to that location.

This can be one using CLI terminal or your native OS. This folder can reside in ether the WSL/Linux VM or on your workstation local storage. Keep note of the folders location and name for reference in the next step.

- remember that for WSL, your normal windows mapped drives can be found in "/mnt/". A windows C: is located at /mnt/c/


**Examples**
Using WSL Terminal CLI to create a folder to a Windows C: drive named "my-repo"
``
mkdir /mnt/c/my-repo
cd /mnt/c/my-repo
``

Using WSL Terminal CLI to create folder named "my-repo" in WSL user home directory for user name "LabUser1"
``
mkdir /home/LabUser1/my-repo
cd /home/LabUser1/my-repo
``

### 2. In VS Code set your "Explorer" context to the same new folder 

select **File-> Open Folder** and navigate to the folder created in step 1 and select "OK"
  - remember that for WSL, your normal windows mapped drives can be found in "/mnt/". A windows C: is located at /mnt/c/
  - users can also use "Show Local" button to see the native Window Navigator style of file navigation and click "Select Folder" button

### 3. Select the new folder and click "select folder" button.
### 5. Open a new WSL "Linux" Terminal by selecting **View -> Terminal**
   - Validate Terinal window is in WSL/Linux, rather than PowerShell
   - if needed, select the dropdown to the right of the "+" in the terminal window and select your Linix/WSL terminal 
### 6. In WSL, enter
   ```
   git clone https://github.com/williamtgoss/arista-ceos-leaf-spine-lab.git
   ```


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
