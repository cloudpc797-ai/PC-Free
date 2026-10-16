# PC-Free — Windows desktop in a browser

This repository configures **PC-Free**, based on the original [jephersonRD/PC-Free](https://github.com/jephersonRD/PC-Free), to try running a Windows desktop inside a GitHub Codespace and open it through a browser.

## Important limitations

- This is a best-effort experiment, **not a verified guarantee that Windows will boot in GitHub Codespaces**.
- The Windows container project expects a Linux host with KVM support and recommends at least 32 GB of free disk space. Codespaces may not expose `/dev/kvm`; without it, Windows may be very slow or fail to start. See the [upstream requirements](https://hub.docker.com/r/dockurr/windows).
- Codespaces stops idle environments and has usage/storage limits. It is not a permanently-on personal computer or a guaranteed free hosting service.
- Use this only for personal use you are authorized to do, and comply with Microsoft Windows licensing terms.
- Port 8006 is configured as **private**. Do not make it public: it is an interactive Windows desktop.

## Setup

1. Open **your** repository in GitHub: `cloudpc797-ai/PC-Free`.
2. Select **Code → Codespaces → Create codespace on main**.
3. Wait for the Dev Container build to finish. The setup attempts to start Windows automatically.
4. Open the **Ports** tab. Open port **8006** using its forwarded address and keep visibility **Private**.
5. First boot downloads the Windows installation files and may take a long time. Wait several minutes.

## Troubleshooting

Open the Codespaces terminal and run:

```bash
docker ps
docker logs --tail 150 pc-free-windows
ls -l /dev/kvm
```

If Docker says it cannot connect to the daemon, inspect the Dev Container build logs and rebuild the Codespace. If `/dev/kvm` is missing or the Windows container reports that KVM is unavailable, this host may not support this setup; changing the YAML cannot create host virtualization support.

To retry starting the Windows container:

```bash
docker compose --env-file .env -f compose.yml up -d
```

To stop Windows without deleting its saved disk:

```bash
docker stop pc-free-windows
```

Windows disk data is stored in the workspace's `windows/` folder. It is ignored by Git, along with `.env`. **Do not commit personal files, passwords, or Windows disk contents to GitHub.** Deleting the Codespace or workspace can delete this data, so make separate backups if needed.

## Files

- `.devcontainer/devcontainer.json` — Codespaces configuration, Docker-in-Docker feature, private port forwarding.
- `compose.yml` — Windows container and persistent workspace storage.
- `scripts/start-windows.sh` — startup and diagnostic messages.
- `.env.example` — optional resource settings; the setup creates a local `.env`.

## Browser access

The web viewer is served on port **8006** by the `dockurr/windows` container. Browser compatibility, including TV browsers, has not been verified. A successful Codespace build alone does not prove that Windows itself boots.
