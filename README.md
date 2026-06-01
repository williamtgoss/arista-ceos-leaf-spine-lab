# Arista cEOS Leaf-Spine Lab — ContainerLab on Windows

A complete ContainerLab topology running Arista cEOS 4.35.4M in a 2-spine / 2-leaf-pair (MLAG) architecture, with step-by-step Windows setup instructions.

---

## Topology

```
                     ┌────────────┐          ┌────────────┐
                     │   spine1   │          │   spine2   │
                     │  AS:65001  │          │  AS:65002  │
                     │ 10.255.0.1 │          │ 10.255.0.2 │
                     └─┬──┬──┬──┬─┘          └─┬──┬──┬──┬─┘
                       │  │  │  │              │  │  │  │
          10.0.0.0/31  │  │  │  │10.0.0.6/31  │  │  │  │
          10.0.0.2/31  │  │  │  │  10.0.0.8/31│  │  │  │10.0.0.14/31
          10.0.0.4/31  │  │  │  │  10.0.0.10/31   │  │10.0.0.12/31
                       │  │  │  │              │  │  │  │
                ┌──────┘  │  │  └──────┐  ┌───┘  │  │  └───┐
                │    ┌────┘  └────┐    │  │  ┌───┘  └───┐  │
                │    │            │    │  │  │           │  │
           ┌────▼────┴┐        ┌──┴────▼──▼──┴┐       ┌─┴──▼────┐
           │  leaf1a  │        │    leaf2a    │       │  leaf2b  │
           │ AS:65011 │        │   AS:65012   │       │ AS:65012 │
           │10.255.0.11        │  10.255.0.21 │       │10.255.0.22
           └────┬─────┘        └──────┬───────┘       └─────┬────┘
                │ Po1 (MLAG            │ Po1 (MLAG           │
                │ peer-link)           │ peer-link)          │
           ┌────┴─────┐        ┌──────┴───────┐       ┌─────┴────┐
           │  leaf1b  │        │    leaf2b    │       └──leaf2a──┘
           │ AS:65011 │        │   AS:65012   │         (see above)
           │10.255.0.12        │  10.255.0.22 │
           └──────────┘        └──────────────┘
              MLAG Pair 1           MLAG Pair 2
```

### Address Summary

| Device  | Loopback0       | BGP AS |
|---------|-----------------|--------|
| spine1  | 10.255.0.1/32   | 65001  |
| spine2  | 10.255.0.2/32   | 65002  |
| leaf1a  | 10.255.0.11/32  | 65011  |
| leaf1b  | 10.255.0.12/32  | 65011  |
| leaf2a  | 10.255.0.21/32  | 65012  |
| leaf2b  | 10.255.0.22/32  | 65012  |

| Link               | Subnet         | Addresses             |
|--------------------|----------------|-----------------------|
| spine1 ↔ leaf1a    | 10.0.0.0/31    | .0 / .1               |
| spine1 ↔ leaf1b    | 10.0.0.2/31    | .2 / .3               |
| spine1 ↔ leaf2a    | 10.0.0.4/31    | .4 / .5               |
| spine1 ↔ leaf2b    | 10.0.0.6/31    | .6 / .7               |
| spine2 ↔ leaf1a    | 10.0.0.8/31    | .8 / .9               |
| spine2 ↔ leaf1b    | 10.0.0.10/31   | .10 / .11             |
| spine2 ↔ leaf2a    | 10.0.0.12/31   | .12 / .13             |
| spine2 ↔ leaf2b    | 10.0.0.14/31   | .14 / .15             |
| leaf1a ↔ leaf1b    | 10.0.1.0/31    | MLAG peer (Po1)       |
| leaf2a ↔ leaf2b    | 10.0.1.2/31    | MLAG peer (Po1)       |

---

## Prerequisites

- Windows 11 (64-bit) with virtualization enabled in BIOS
- 16 GB RAM minimum (6 cEOS nodes × ~1.5 GB each)
- 20 GB free disk space
- An [Arista support account](https://www.arista.com/en/user-registration) to download cEOS

---

## Setup Guide

Follow these guides in order:

1. [Install WSL2 and Docker Desktop](docs/01-wsl-docker.md)
2. [Install ContainerLab](docs/02-containerlab-install.md)
3. [Download and import the cEOS 4.35.4M image](docs/03-ceos-image.md)
4. [Install the VSCode ContainerLab extension](docs/04-vscode-extension.md)
5. [Clone this repo and run the lab](docs/05-running-the-lab.md)

---

## Quick Start (after setup)

```bash
# In your WSL2 Ubuntu terminal
git clone <this-repo-url> arista-leaf-spine
cd arista-leaf-spine

# Deploy the lab
sudo containerlab deploy -t lab.clab.yaml

# Verify BGP on spine1
docker exec -it clab-arista-leaf-spine-spine1 Cli -c "show bgp summary"

# Verify MLAG on leaf1a
docker exec -it clab-arista-leaf-spine-leaf1a Cli -c "show mlag"

# Destroy the lab when done
sudo containerlab destroy -t lab.clab.yaml
```

---

## Default Credentials

| Username | Password |
|----------|----------|
| admin    | admin    |

---

## Repository Structure

```
.
├── lab.clab.yaml          # ContainerLab topology definition
├── configs/
│   ├── spine1/startup-config
│   ├── spine2/startup-config
│   ├── leaf1a/startup-config
│   ├── leaf1b/startup-config
│   ├── leaf2a/startup-config
│   └── leaf2b/startup-config
└── docs/
    ├── 01-wsl-docker.md
    ├── 02-containerlab-install.md
    ├── 03-ceos-image.md
    ├── 04-vscode-extension.md
    └── 05-running-the-lab.md
```
