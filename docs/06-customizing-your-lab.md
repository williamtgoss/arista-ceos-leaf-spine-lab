# Step 6 — Customizing Your Lab

This guide walks you through how to modify the `lab.clab.yaml` file to customize and extend the example lab. All changes described here are made by **you** directly in the file — this guide only explains what to do and why.

---

## 1. Understanding the ContainerLab Topology File

The `lab.clab.yaml` file is the single source of truth for your ContainerLab environment. It tells ContainerLab which containers to create, what images to use, how to connect them, and how to manage them. Below is a breakdown of each section used in the example lab.

### `name`

```yaml
name: arista-leaf-spine
```

This is the name of the lab. ContainerLab uses this name as a prefix when it creates Docker containers. For example, a node named `spine1` in a lab named `arista-leaf-spine` will result in a container called `clab-arista-leaf-spine-spine1`. Changing the lab name will change this prefix for all containers.

---

### `mgmt`

```yaml
mgmt:
  network: clab-mgmt
  ipv4-subnet: 172.20.20.0/24
```

The `mgmt` block defines the out-of-band Docker management network that ContainerLab creates for the lab. This is separate from your data-plane links.

| Field | Description |
|-------|-------------|
| `network` | The name ContainerLab assigns to the Docker network it creates |
| `ipv4-subnet` | The IP subnet used for management connectivity to all nodes |

ContainerLab automatically assigns `.1` as the gateway for this subnet. Individual nodes can be given a fixed IP within this subnet using the `mgmt-ipv4` field (see the `nodes` section below).

---

### `topology`

The `topology` block contains all of the lab's node and link definitions.

#### `defaults`

```yaml
topology:
  defaults:
    kind: arista_ceos
    image: ceos:latest
```

Values under `defaults` are inherited by every node unless a node overrides them. In the example lab, every node defaults to the `arista_ceos` kind and the `ceos:latest` Docker image. This avoids repeating those values on every single node.

#### `nodes`

```yaml
  nodes:
    spine1:
      kind: arista_ceos
      startup-config: configs/spine1/startup-config
      mgmt-ipv4: 172.20.20.10

    host1:
      kind: linux
      image: alpine:latest
      startup-config: configs/host1/startup.sh
      mgmt-ipv4: 172.20.20.20
```

Each entry under `nodes` defines one container in the lab. The key fields used in the example lab are:

| Field | Description |
|-------|-------------|
| `kind` | The node type. Tells ContainerLab how to start and manage the container (e.g., `arista_ceos`, `linux`) |
| `image` | The Docker image to use. When omitted, the value from `defaults` is used |
| `startup-config` | A path (relative to the yaml file) to a startup configuration file applied to the node when it first boots |
| `mgmt-ipv4` | A static IP address assigned to this node on the management network |

#### `links`

```yaml
  links:
    - endpoints: ["spine1:eth1", "leaf1a:eth1"]
    - endpoints: ["leaf1a:eth3", "leaf1b:eth3"]
```

Each entry under `links` creates a virtual cable between two node interfaces. The format is:

```
- endpoints: ["<node-name>:<interface>", "<node-name>:<interface>"]
```

Interface naming follows the convention `ethN`, where N starts at 1. ContainerLab maps these to the container's internal interfaces in the order defined.

---

### Further Reading

For the full topology file reference — including all available fields, IPv6 management, node groups, and advanced options — see the official ContainerLab documentation:

**[ContainerLab Topology Definition Reference](https://containerlab.dev/manual/topo-def-file/)**

---

## 2. Adding a New Node — leaf2c

The following steps walk you through manually adding a third leaf switch (`leaf2c`) to the existing lab. This node will connect to both `leaf2a` and `leaf2b` as an additional downstream leaf.

> **Before you begin:** Make sure the lab is stopped before making changes. See [Section 3](#3-stopping-and-redeploying-the-lab) below.

### Step 1 — Add the node definition

Open `lab.clab.yaml` in your editor. Locate the `nodes:` section, specifically the block for `leaf2b`. Add the following block directly **after** the `leaf2b` node definition, keeping consistent indentation (2 spaces):

```yaml
    leaf2c:
      kind: arista_ceos
      startup-config: configs/leaf2c/startup-config
      mgmt-ipv4: 172.20.20.16
```

After this edit, the leaf section of your `nodes:` block should look like:

```yaml
    leaf2a:
      kind: arista_ceos
      startup-config: configs/leaf2a/startup-config
      mgmt-ipv4: 172.20.20.14

    leaf2b:
      kind: arista_ceos
      startup-config: configs/leaf2b/startup-config
      mgmt-ipv4: 172.20.20.15

    leaf2c:
      kind: arista_ceos
      startup-config: configs/leaf2c/startup-config
      mgmt-ipv4: 172.20.20.16
```

> **Note:** The `startup-config` path `configs/leaf2c/startup-config` references a file that does not exist yet. You will need to create that directory and file before deploying the lab. You can start by copying an existing leaf config (e.g., `configs/leaf2a/startup-config`) and adjusting the hostname, IP addresses, and BGP settings to match your intended design for `leaf2c`.

### Step 2 — Add the links

Scroll down to the `links:` section in the same file. Add the following two entries at the end of the links list:

```yaml
    # leaf2c uplinks to leaf2a and leaf2b
    - endpoints: ["leaf2c:eth1", "leaf2a:eth5"]
    - endpoints: ["leaf2c:eth2", "leaf2b:eth5"]
```

These create two virtual cables:
- `leaf2c` interface `eth1` ↔ `leaf2a` interface `eth5`
- `leaf2c` interface `eth2` ↔ `leaf2b` interface `eth5`

### Step 3 — Save the file

Save `lab.clab.yaml`. The file is now updated with the new node and links. You are ready to redeploy.

---

## 3. Stopping and Redeploying the Lab

### Check if the lab is currently running

Before making changes and redeploying, check whether the lab is already active:

```bash
sudo containerlab inspect -t lab.clab.yaml
```

- If you see a table listing containers with a **running** state, the lab is active and must be destroyed before redeployment.
- If the command returns no containers or an error indicating nothing is deployed, the lab is already stopped and you can skip the destroy step.

### Destroy the running lab

If the lab is running, destroy it with:

```bash
sudo containerlab destroy -t lab.clab.yaml
```

This removes all containers and virtual links. The `lab.clab.yaml` file and your `configs/` directory are not affected — only the running containers are torn down.

To also clean up the ContainerLab-generated `.clab/` directory at the same time, add the `--cleanup` flag:

```bash
sudo containerlab destroy -t lab.clab.yaml --cleanup
```

### Deploy the updated lab

Once the lab is stopped and your `lab.clab.yaml` changes are saved, deploy the updated topology:

```bash
sudo containerlab deploy -t lab.clab.yaml
```

ContainerLab will read the updated file, create the new containers (including `leaf2c`), wire all the links, and apply startup configurations. When complete, a summary table will be printed listing all nodes and their management IP addresses.

Verify the new node is present and has the correct management IP:

```bash
sudo containerlab inspect -t lab.clab.yaml
```

You should see `clab-arista-leaf-spine-leaf2c` listed with management IP `172.20.20.16`.

---

## 4. Using Other Vendor Images in ContainerLab

ContainerLab is not limited to Arista EOS. It supports a broad ecosystem of containerized and virtual network operating systems from multiple vendors. As long as a Docker image or VM image is available, ContainerLab can typically run it — all you need to do is change the `kind` and `image` fields in your `lab.clab.yaml`.

Some examples of supported network operating systems:

| Vendor | Product | Kind |
|--------|---------|------|
| Nokia | SR Linux | `nokia_srlinux` |
| Juniper | vJunos-router / vJunos-switch | `juniper_vjunosrouter` / `juniper_vjunosswitch` |
| Cisco | IOS XRd | `cisco_xrd` |
| Cumulus / NVIDIA | Cumulus Linux | `cumulus_cvx` |
| VyOS | VyOS | `linux` (generic) |
| FRRouting | FRR | `linux` (generic) |
| MikroTik | RouterOS CHR | `mikrotik_ros` |

Different kinds have different requirements — some need a locally imported Docker image (like cEOS), while others can be pulled directly from a registry. Some kinds also support additional node-level fields specific to that platform.

For full documentation on all supported kinds, their requirements, and how to configure them, see:

**[ContainerLab Kinds Reference](https://containerlab.dev/manual/kinds/)**

---

## 5. Further ContainerLab Resources

| Resource | URL |
|----------|-----|
| ContainerLab Manual | [containerlab.dev/manual](https://containerlab.dev/manual) |
| Command Reference (deploy) | [containerlab.dev/cmd/deploy](https://containerlab.dev/cmd/deploy/) |
| Topology Definition Reference | [containerlab.dev/manual/topo-def-file](https://containerlab.dev/manual/topo-def-file/) |
| Kinds Reference | [containerlab.dev/manual/kinds](https://containerlab.dev/manual/kinds/) |
