#!/bin/bash

# ==============================================================================
# Router Auto-Reboot Script (TP-Link TL-WR941N)
# ==============================================================================
# Este script reinicia el router enviando un comando HTTP autenticado.
# ==============================================================================

PROJECT_DIR="$(dirname "$0")"
LOG_FILE="$PROJECT_DIR/reboot.log"

# Cargar variables de entorno
if [ -f "$PROJECT_DIR/.env" ]; then
    set -a
    source "$PROJECT_DIR/.env"
    set +a
fi

ROUTER_USER="${ROUTER_USER:-admin}"
ROUTER_PASS="${ROUTER_PASS:-admin}"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

get_gateway_ip() {
    export PATH="/data/data/com.termux/files/usr/bin:/system/bin:$PATH"
    
    # 1. Try standard ip route
    local gw=$(ip route show 2>/dev/null | grep default | awk '{print $3}' | head -n 1)
    
    # 2. Try all tables
    if [ -z "$gw" ]; then
        gw=$(ip route show table all 2>/dev/null | grep default | awk '{print $3}' | head -n 1)
    fi
    
    # 3. Try getprop
    if [ -z "$gw" ]; then
        gw=$(getprop dhcp.wlan0.gateway 2>/dev/null)
    fi

    # 4. Fallback detection
    if [ -z "$gw" ]; then
        if ping -c 1 -W 1 192.168.1.1 >/dev/null 2>&1; then gw="192.168.1.1";
        elif ping -c 1 -W 1 192.168.0.1 >/dev/null 2>&1; then gw="192.168.0.1"; fi
    fi
    
    echo "$gw"
}

R_IP="$ROUTER_IP"
if [ -z "$R_IP" ]; then
    R_IP=$(get_gateway_ip)
fi

if [ -z "$R_IP" ]; then
    log_message "Error: No se pudo detectar la IP del router y ROUTER_IP está vacía."
    exit 1
fi

log_message "Intentando reiniciar router en $R_IP..."

# Comando específico para TP-Link TL-WR941N
# Note: Referer is often required by TP-Link firmware
REBOOT_URL="http://$R_IP/userRpm/SysRebootRpm.htm?Reboot=Reboot"
REFERER="http://$R_IP/userRpm/SysRebootRpm.htm"

RESPONSE=$(curl -s -u "$ROUTER_USER:$ROUTER_PASS" \
     -e "$REFERER" \
     "$REBOOT_URL")

if [[ "$RESPONSE" == *"Restarting"* ]] || [ $? -eq 0 ]; then
    log_message "Comando de reinicio enviado con éxito."
else
    log_message "Error al enviar comando de reinicio. Verifique credenciales e IP."
fi
