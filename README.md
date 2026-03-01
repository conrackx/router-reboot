# Router Control

Automated reboot script for TP-Link TL-WR941N (and similar legacy TP-Link routers) running on Termux (Android).

## Features
- Auto-detects Gateway IP on Android/Termux.
- Uses Basic Auth for HTTP-based reboot commands.
- Configurable via `.env` file.
- Designed for low-end devices (Alcatel TETRA).

## Setup
1. Instale las dependencias en Termux: `pkg install curl iproute2 dos2unix -y`
2. Clone este repositorio dentro de su gestor (ej. `$HOME/router_control`).
3. Cree el archivo `.env` tomando como base el siguiente ejemplo:
   ```env
   ROUTER_USER=admin
   ROUTER_PASS=admin
   ROUTER_IP=192.168.1.1
   ```
   ```
4. Si ha editado los archivos en Windows o usando SCP, asegure el formato UNIX y conviértalo en ejecutable: 
   ```bash
   dos2unix .env reboot_router.sh
   chmod +x reboot_router.sh
   ```
5. Ejecute: `./reboot_router.sh`

## Automation
Add to crontab:
```cron
0 3 * * * /data/data/com.termux/files/home/router_control/reboot_router.sh
```
