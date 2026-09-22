# Adding a machine

1. Choose a stable lowercase machine ID, such as `rig-03`. It becomes the URL
   prefix and NFS folder name.
2. On the server create `/srv/testbenchdaq/rig-03` and export it over NFS only
   to that machine's fixed IP address.
3. On the acquisition machine mount that export as `/mnt/testbench-results`.
4. Set `machine_name` and `output_root` in its local TestbenchDAQ `config.json`.
5. Run a short acquisition and verify the data appears under the server folder.

No Nginx change is needed for data browsing. The generic route already accepts
`/data/rig-03/`; the portal returns a useful empty state until that
machine has session manifests.

For future status/telemetry, add the machine to the central registry service
when that service exists. Do not expose SSH or arbitrary command execution.
