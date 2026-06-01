# Step 5 — Clone the Repo and Run the Lab

With WSL2, Docker, ContainerLab, and the cEOS image all set up, you're ready to deploy the lab.

---

## 1. Clone the Repository

Open your **Ubuntu terminal** and clone the repo into your WSL2 home directory:

```bash
git clone https://github.com/williamtgoss/arista-ceos-leaf-spine-lab.git arista-leaf-spine
cd arista-leaf-spine
```

> **Work inside WSL2:** Always clone and run the lab from within the WSL2 filesystem (e.g., `~/arista-leaf-spine`), not from a Windows path like `/mnt/c/...`. ContainerLab performance and file permissions work correctly only on the native Linux filesystem.

---

## 2. Deploy the Lab from the Terminal

```bash
sudo containerlab deploy -t lab.clab.yaml
```

ContainerLab will:
1. Pull/verify the `ceos:4.35.4M` Docker image
2. Create a Docker network (`clab`) for management access
3. Start 6 containers (spine1, spine2, leaf1a, leaf1b, leaf2a, leaf2b)
4. Wire the virtual links between containers
5. Apply each node's startup configuration

**First boot takes 60–90 seconds** per node as cEOS initializes. ContainerLab waits for all nodes to be ready before returning.

When complete you will see a summary table like:

```
+----+---------------------------------------+--------------+---------+------+---------+
| #  |                 Name                  |  Kind/Image  |  State  | IPv4 |   IPv6  |
+----+---------------------------------------+--------------+---------+------+---------+
|  1 | clab-arista-leaf-spine-leaf1a         | ceos         | running | ...  | N/A     |
|  2 | clab-arista-leaf-spine-leaf1b         | ceos         | running | ...  | N/A     |
|  3 | clab-arista-leaf-spine-leaf2a         | ceos         | running | ...  | N/A     |
|  4 | clab-arista-leaf-spine-leaf2b         | ceos         | running | ...  | N/A     |
|  5 | clab-arista-leaf-spine-spine1         | ceos         | running | ...  | N/A     |
|  6 | clab-arista-leaf-spine-spine2         | ceos         | running | ...  | N/A     |
+----+---------------------------------------+--------------+---------+------+---------+
```

---

## 3. Deploy the Lab from VSCode

If you opened the repo in VSCode with the Remote - WSL extension:

1. In the VSCode Explorer, right-click `lab.clab.yaml`
2. Select **ContainerLab: Deploy lab**

The terminal pane will show the same output as the CLI deploy above. The **ContainerLab** sidebar panel will populate with the running nodes once they are up.

---

## 4. Connect to a Node

### Via Docker exec (CLI)

```bash
# Open an EOS CLI session on spine1
docker exec -it clab-arista-leaf-spine-spine1 Cli

# Or run a single command non-interactively
docker exec -it clab-arista-leaf-spine-spine1 Cli -c "show version"
```

### Via SSH

```bash
ssh admin@<management-ip>
# Password: admin
```

Management IPs are shown in the deploy summary table, or you can find them with:

```bash
sudo containerlab inspect -t lab.clab.yaml
```

### Via VSCode ContainerLab Extension

Click the SSH icon next to any running node in the ContainerLab sidebar.

---

## 5. Verify BGP Sessions

After the lab has been running for 60–90 seconds, verify BGP is established.

### On spine1 (should have 4 eBGP neighbors)

```bash
docker exec -it clab-arista-leaf-spine-spine1 Cli -c "show bgp summary"
```

Expected output — all 4 neighbors in **Estab** state:

```
BGP summary information for VRF default
Router identifier 10.255.0.1, local AS number 65001
...
Neighbor         AS       MsgRcvd MsgSent  InQ OutQ  Up/Down State  PfxRcd PfxAcc
10.0.0.1      65011         ...     ...    0    0  00:00:xx Estab       1      1
10.0.0.3      65011         ...     ...    0    0  00:00:xx Estab       1      1
10.0.0.5      65012         ...     ...    0    0  00:00:xx Estab       1      1
10.0.0.7      65012         ...     ...    0    0  00:00:xx Estab       1      1

(spine2 output will be identical — both spines run AS 65001)
```

### Check the BGP routing table

```bash
docker exec -it clab-arista-leaf-spine-spine1 Cli -c "show ip bgp"
```

You should see loopback routes from all 4 leaf switches (`10.255.0.11`, `.12`, `.21`, `.22`).

### Test reachability across the fabric

```bash
docker exec -it clab-arista-leaf-spine-spine1 Cli -c "ping 10.255.0.21 source 10.255.0.1 repeat 5"
```

---

## 6. Verify MLAG

Check MLAG state on leaf1a (should be Active) and leaf1b (should be Standby):

```bash
docker exec -it clab-arista-leaf-spine-leaf1a Cli -c "show mlag"
```

Expected output:

```
MLAG Configuration:
domain-id                          :              MLAG_PAIR1
local-interface                    :            Vlan4094
peer-address                       :         10.255.255.2
peer-link                          :        Port-Channel100
peer-config                        :          consistent

MLAG Status:
state                              :              Active
negotiation status                 :           Connected
peer-link status                   :                 Up
local-int status                   :                 Up
system-id                          :   xx:xx:xx:xx:xx:xx
dual-primary detection status      :         Disabled
dual-primary interface errdisabled :            False
```

```bash
docker exec -it clab-arista-leaf-spine-leaf1b Cli -c "show mlag"
```

leaf1b should show `state: Standby` and `negotiation status: Connected`.

Check the MLAG peer-link Port-Channel:

```bash
docker exec -it clab-arista-leaf-spine-leaf1a Cli -c "show port-channel 100"
```

---

## 7. Useful Verification Commands

| Command | Purpose |
|---------|---------|
| `show bgp summary` | BGP neighbor states and prefix counts |
| `show ip bgp` | Full BGP RIB |
| `show ip route bgp` | BGP-learned routes in the routing table |
| `show mlag` | MLAG domain state and peer status |
| `show mlag interfaces` | MLAG-member interfaces |
| `show port-channel 100` | Port-Channel100 (MLAG peer-link) member status (eth3+eth4) |
| `show interface Ethernet3` | Physical state of MLAG peer-link member 1 |
| `show interface Ethernet4` | Physical state of MLAG peer-link member 2 |
| `show bgp neighbors 10.255.255.2` | iBGP MLAG-PEER session detail (on "a" switches) |
| `show bgp neighbors 10.255.255.1` | iBGP MLAG-PEER session detail (on "b" switches) |
| `ping <ip> source <loopback>` | End-to-end reachability test |

---

## 8. Save Running Config (Optional)

If you make changes inside a node and want to preserve them:

```bash
docker exec -it clab-arista-leaf-spine-spine1 Cli -c "copy running-config startup-config"
```

Note: this saves to the container's internal flash. Changes are lost when the lab is destroyed. To make permanent changes, edit the corresponding file in `configs/<node>/startup-config` and redeploy.

---

## 9. Destroy the Lab

When you're done, tear down all containers and virtual links:

```bash
sudo containerlab destroy -t lab.clab.yaml
```

Add `--cleanup` to also remove the ContainerLab-generated `.clab/` directory:

```bash
sudo containerlab destroy -t lab.clab.yaml --cleanup
```

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| Container exits immediately after deploy | cEOS failed to start — check logs: `docker logs clab-arista-leaf-spine-spine1` |
| BGP neighbors stuck in `Active` state after 2+ minutes | Verify IP addressing in startup-configs; check interface is up: `show interface Ethernet1` |
| MLAG state shows `Inactive` | Ensure Port-Channel100 is up on both peers; check Vlan4094 SVI is up with `no autostate` |
| `docker exec` returns "No such container" | Lab isn't deployed; run `sudo containerlab deploy -t lab.clab.yaml` |
| Out of memory — containers crash | Close other applications; 16 GB RAM is the minimum for this 6-node lab |
