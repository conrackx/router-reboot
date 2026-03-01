# Router Control

Script de reinicio automatizado para routers TP-Link TL-WR941N (y modelos antiguos similares) ejecutándose en Termux (Android).

## Características

* **Detección automática:** Identifica la IP del Gateway en Android/Termux.
* **Autenticación:** Utiliza autenticación básica (*Basic Auth*) para los comandos de reinicio vía HTTP.
* **Configuración sencilla:** Gestión de parámetros mediante un archivo `.env`.
* **Optimizado:** Diseñado para funcionar en dispositivos de gama baja (como el Alcatel TETRA).

## Configuración

1. **Instale las dependencias** en Termux:
```bash
pkg install curl iproute2 dos2unix -y

```


2. **Clone este repositorio** dentro de su directorio de usuario (ej. `$HOME/router_control`).
3. **Cree el archivo `.env**` basándose en el siguiente ejemplo:
```env
ROUTER_USER=admin
ROUTER_PASS=admin
ROUTER_IP=192.168.1.1

```


4. **Prepare los permisos:** Si editó los archivos en Windows o usó SCP, asegure el formato UNIX y conviértalos en ejecutables:
```bash
dos2unix .env reboot_router.sh
chmod +x reboot_router.sh

```


5. **Ejecute el script:** `./reboot_router.sh`

## Automatización

Para programar reinicios automáticos, añada la siguiente línea a su `crontab`:

```cron
0 3 * * * /data/data/com.termux/files/home/router_control/reboot_router.sh

```
