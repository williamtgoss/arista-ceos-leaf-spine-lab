# Step 3 — Download and Import the cEOS 4.35.4M Image

Arista's cEOS-lab image is a containerized version of EOS. It requires a free Arista support account to download. The image is not publicly available and must be imported into Docker manually.

---

## 1. Create an Arista Account

If you or your organization already has an Arista support contract, use your existing account. If you do not have one:

1. Go to **https://www.arista.com/en/user-registration**
2. Fill in your details and submit the registration form
3. Verify your email address (Generic email domains like Hotmail.com, Yahoo.com or others are restricted)



---

## 2. Download the cEOS Image

Arista provides vEOS (virtualized) and cEOS (containerized) images to non-customers with a registered arista.com account. If you are an existing Arista customer, you will have access to all licensed software through your organization's account in addition to the vEOS and cEOS images.

### 2.1 Windows Instructions

1. Log in at **https://www.arista.com/en/support/software-download**
2. In the left navigation, select **EOS** → **Active Releases** → **4.35** → **EOS-4.35.4M**
3. Under the **cEOS-lab** section, download:

   ```
   cEOS-lab-4.35.4M.tar.xz
   ```

  **Save the file to a location you can easily find later. Make a note of the file's location on your local C: drive.**

> **File size:** approximately 600–800 MB. Download time will depend on your connection speed.


### 2.2 macOS Instructions

1. Log in at **https://www.arista.com/en/support/software-download**
2. In the left navigation, select **EOS** → **Active Releases** → **4.35** → **EOS-4.35.4M**
3. Under the **cEOS-lab** section, download the **ARM64** image:

   ```
   cEOSarm-lab-4.35.4M.tar.xz
   ```

   > **Important:** Apple Silicon Macs require the ARM-based image (`cEOSarm`), not the standard `cEOS-lab` image. Downloading the wrong image will result in containers that fail to start.

  **Save the file to a location you can easily find later, such as your Downloads folder.**

> **File size:** approximately 600–800 MB. Download time will depend on your connection speed.

---

## 3. Import the Image into Docker

### 3.1 Windows Instructions

You can import the image directly from its Windows path in your WSL2 terminal — no need to copy the file.

Open your **Ubuntu terminal** and run:
```
docker import /mnt/c/**location where you saved your cEOS-lab-4.35.4M.tar.xz** ceos:4.35.4M
```

Explanation:
- `/mnt/c/` is how WSL2 accesses `C:\` on Windows
- `ceos:4.35.4M` is the Docker image name and tag ContainerLab expects

The import will take 1–3 minutes. When complete, you will see a SHA256 digest printed.

### 3.2 macOS Instructions

You can import the image directly from its macOS path in your OrbStack Ubuntu VM — no need to copy the file into the VM.

Open your **Ubuntu terminal** (via `orb shell ubuntu` or the VS Code Remote-SSH terminal) and run:

```
docker import /mnt/mac/Users/<your-mac-username>/Downloads/cEOSarm-lab-4.35.4M.tar.xz ceos:4.35.4M
```

Explanation:
- `/mnt/mac/` is how the OrbStack Ubuntu VM accesses the macOS filesystem (similar to WSL2's `/mnt/c/`)
- Replace `<your-mac-username>` with your macOS username
- `ceos:4.35.4M` is the Docker image name and tag ContainerLab expects

The import will take 1–3 minutes. When complete, you will see a SHA256 digest printed.

---

## 4. Verify the Image

```bash
docker images ceos
```

Expected output:

```
REPOSITORY   TAG        IMAGE ID       CREATED          SIZE
ceos         4.35.4M    <image-id>     X minutes ago    ~1.7GB
```

---

## 5. Tag Shorthand

To be able to reference the cEOS image as just `ceos:latest`, a tag will need to be created. This will allow us to define the image as `ceos:latest` in our ContainerLab yaml files and then we can change the latest image to whatever we install in the future and reapply this tag to that new cEOS image. This will save us from having to update each ContainerLab yaml file in the future when an updated image is installed. 

```bash
docker tag ceos:4.35.4M ceos:latest
```

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `docker: permission denied` | Run with `sudo`: `sudo docker import ...` |
| Import hangs for more than 10 minutes | The `.tar.xz` decompression is CPU-intensive; wait it out. Check progress with `docker images` in another terminal — the image will appear when done |
| Wrong image tag | Re-run `docker import` with the correct tag; remove the old one with `docker rmi <wrong-tag>` |

---

Next: [Install the VSCode ContainerLab extension](04-vscode-extension.md)
