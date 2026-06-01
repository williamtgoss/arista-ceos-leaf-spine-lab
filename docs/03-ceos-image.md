# Step 3 — Download and Import the cEOS 4.35.4M Image

Arista's cEOS-lab image is a containerized version of EOS. It requires a free Arista support account to download. The image is not publicly available and must be imported into Docker manually.

---

## 1. Create an Arista Account

If you do not already have one:

1. Go to **https://www.arista.com/en/user-registration**
2. Fill in your details and submit the registration form
3. Verify your email address

If your organization already has an Arista support contract, contact your account team to have your account associated with the contract for full software access.

---

## 2. Download the cEOS Image

1. Log in at **https://www.arista.com/en/support/software-download**
2. In the left navigation, select **EOS** → **Active Releases** → **4.35** → **EOS-4.35.4M**
3. Under the **cEOS-lab** section, download:

   ```
   cEOS-lab-4.35.4M.tar.xz
   ```

   Save the file to a location you can easily find, such as `C:\Downloads\`.

> **File size:** approximately 600–800 MB. Download time will depend on your connection speed.

---

## 3. Import the Image into Docker

You can import the image directly from its Windows path in your WSL2 terminal — no need to copy the file.

Open your **Ubuntu terminal** and run:

```bash
docker import /mnt/c/Downloads/cEOS-lab-4.35.4M.tar.xz ceos:4.35.4M
```

Explanation:
- `/mnt/c/Downloads/` is how WSL2 accesses `C:\Downloads\` on Windows
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

## 5. (Optional) Tag Shorthand

If you want to be able to reference the image as just `ceos:latest`:

```bash
docker tag ceos:4.35.4M ceos:latest
```

The topology file in this repo uses `ceos:4.35.4M` explicitly, so this step is optional.

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `/mnt/c/Downloads/...` file not found | Confirm the exact filename: `ls /mnt/c/Downloads/ | grep cEOS` |
| `docker: permission denied` | Run with `sudo`: `sudo docker import ...` |
| Import hangs for more than 10 minutes | The `.tar.xz` decompression is CPU-intensive; wait it out. Check progress with `docker images` in another terminal — the image will appear when done |
| Wrong image tag | Re-run `docker import` with the correct tag; remove the old one with `docker rmi <wrong-tag>` |

---

Next: [Install the VSCode ContainerLab extension](04-vscode-extension.md)
