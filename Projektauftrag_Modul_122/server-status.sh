# Script Name:  server-status.sh
# Beschreibung: Hauptskript zum Ausführen aller Checks
# Autor:        Donart Aslani
# Version:      1.2
# Datum:        2025-07-11
###########################################################################

#!/bin/bash

# Absolute Pfade für Befehle (damit Cron sie findet)
BC=/usr/bin/bc
WHO=/usr/bin/who
WC=/usr/bin/wc
GREP=/bin/grep
DATE=/bin/date
DF=/bin/df
CAT=/bin/cat

# Pfad zu deinem config file (immer absolut!)
CONFIG="/home/donart/server-monitor/config.cfg"

# Log- und Report-Dateien
LOGFILE="/home/donart/server-monitor/system_monitor.log"
REPORT="/home/donart/server-monitor/system_report_$($DATE '+%Y-%m-%d_%H-%M').log"

# Config laden (mit vollem Pfad)
if [ -f "$CONFIG" ]; then
  source "$CONFIG"
else
  echo "$($DATE): Konfigurationsdatei nicht gefunden!" >> "$LOGFILE"
  exit 1
fi

# Systemwerte ermitteln
CPU_LOAD=$($CAT /proc/loadavg | awk '{print $1}')
RAM_USED=$(free -m | awk '/Mem:/ {print $3}')
DISK_FREE=$($DF / | awk 'NR==2 {print $4}')
USERS=$($WHO | $WC -l)
ETH0_STATUS=$(cat /sys/class/net/eth0/operstate 2>/dev/null || echo "unknown")
WLAN0_STATUS=$(cat /sys/class/net/wlan0/operstate 2>/dev/null || echo "unknown")
FAILED_LOGINS=$($GREP "Failed password" /var/log/auth.log 2>/dev/null | $GREP "$($DATE '+%b %e %H:%M' -d '5 minutes ago')" | $WC -l)

# Bericht schreiben
{
  echo "CPU-Auslastung (1 min): $CPU_LOAD"
  echo "RAM-Verbrauch (MB): $RAM_USED"
  echo "Freier Speicherplatz auf / : $DISK_FREE"
  echo "Anzahl angemeldete Benutzer: $USERS"
  echo "Netzwerkstatus eth0: $ETH0_STATUS"
  echo "Netzwerkstatus wlan0: $WLAN0_STATUS"
   echo "Fehlgeschlagene Loginversuche (letzte 5 min): $FAILED_LOGINS"
  echo "-------------------------------"
} > "$REPORT"

# Warnung prüfen und Mail senden
# Warnungen prüfen und ggf. E-Mail senden

# CPU-Last
if (( $(echo "$CPU_LOAD > $CPU_WARN" | $BC -l) )); then
  WARNUNG="WARNUNG: CPU-Auslastung über $CPU_WARN (aktuell: $CPU_LOAD)"
  echo "$WARNUNG" | tee -a "$REPORT"
  {
    echo "Subject: ALARM: Hohe CPU-Auslastung auf $(hostname)"
    echo "To: $ALARM_EMAIL"
    echo
    echo "$WARNUNG am $($DATE)"
  } | /usr/bin/msmtp --from=default -t
fi

# RAM-Verbrauch
if (( $RAM_USED > $RAM_WARN )); then
  WARNUNG="WARNUNG: RAM-Verbrauch über $RAM_WARN MB (aktuell: $RAM_USED MB)"
  echo "$WARNUNG" | tee -a "$REPORT"
  {
    echo "Subject: ALARM: RAM-Verbrauch zu hoch auf $(hostname)"
    echo "To: $ALARM_EMAIL"
    echo
    echo "$WARNUNG am $($DATE)"
  } | /usr/bin/msmtp --from=default -t
fi


# Skript-Ausführung protokollieren
echo "$($DATE '+%Y-%m-%d %H:%M:%S') - Skript ausgeführt, CPU: $CPU_LOAD, RAM: $RAM_USED MB" >> "$LOGFILE"
