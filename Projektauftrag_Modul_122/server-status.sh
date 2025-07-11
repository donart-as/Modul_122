# Script Name:  server-status.sh
# Beschreibung: Hauptskript zum Ausführen aller Checks
# Autor:        Donart Aslani
# Version:      1.2
# Datum:        2025-07-11
###########################################################################

#!/bin/bash

# Absolute Pfade zu benötigten Programmen (wichtig für Cron)
BC=/usr/bin/bc       # Taschenrechner für Rechenoperationen
WHO=/usr/bin/who     # Zeigt angemeldete Benutzer an
WC=/usr/bin/wc       # Zählt Zeilen, Wörter, Zeichen
GREP=/bin/grep       # Sucht Textmuster in Dateien/Texten
DATE=/bin/date       # Zeigt aktuelles Datum & Uhrzeit
DF=/bin/df           # Zeigt Speicherplatz der Festplatten
CAT=/bin/cat         # Gibt Dateiinhalt aus / verbindet Dateien

# Pfad zur Konfigurationsdatei
CONFIG="/home/donart/server-monitor/config.cfg"

# Pfade für Log- und Report-Dateien
LOGFILE="/home/donart/server-monitor/system_monitor.log"
REPORT="/home/donart/server-monitor/system_report_$($DATE '+%Y-%m-%d_%H-%M').log"

# Konfigurationsdatei einbinden, sonst abbrechen
if [ -f "$CONFIG" ]; then
  source "$CONFIG"
else
  echo "$($DATE): Konfigurationsdatei nicht gefunden!" >> "$LOGFILE"
  exit 1
fi

# Systemwerte erfassen
CPU_LOAD=$($CAT /proc/loadavg | awk '{print $1}')                                # CPU-Auslastung (1 Min)
RAM_USED=$(free -m | awk '/Mem:/ {print $3}')                                    # RAM-Verbrauch in MB
DISK_FREE=$($DF / | awk 'NR==2 {print $4}')                                      # Freier Speicherplatz auf /
USERS=$($WHO | $WC -l)                                                           # Anzahl eingeloggter Benutzer
ETH0_STATUS=$(cat /sys/class/net/eth0/operstate 2>/dev/null || echo "unknown")   # Status von eth0
WLAN0_STATUS=$(cat /sys/class/net/wlan0/operstate 2>/dev/null || echo "unknown") # Status von wlan0
FAILED_LOGINS=$($GREP "Failed password" /var/log/auth.log 2>/dev/null | $GREP "$($DATE '+%b %e %H:%M' -d '5 minutes ago')" | $WC -l) # Fehlgeschlagene Logins der letzten 5 Minuten

# Report schreiben
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

# CPU-Warnung prüfen
if (( $(echo "$CPU_LOAD > $CPU_WARN" | $BC -l) )); then # bc -l: wird verwendet, da bash mit Fliesskommazahlen nicht direkt rechnen kann.
  WARNUNG="WARNUNG: CPU-Auslastung über $CPU_WARN (aktuell: $CPU_LOAD)"
  echo "$WARNUNG" | tee -a "$REPORT"  # Nachricht wird an Konsole und Report ausgegeben (tee -a)
  {
    echo "Subject: ALARM: Hohe CPU-Auslastung auf $(hostname)"
    echo "To: $ALARM_EMAIL"
    echo
    echo "$WARNUNG am $($DATE)"
  } | /usr/bin/msmtp --from=default -t
fi

# RAM-Warnung prüfen
if (( $RAM_USED > $RAM_WARN )); then
  WARNUNG="WARNUNG: RAM-Verbrauch über $RAM_WARN MB (aktuell: $RAM_USED MB)"
  echo "$WARNUNG" | tee -a "$REPORT" # Nachricht wird an Konsole und Report ausgegeben (tee -a)
  {
    echo "Subject: ALARM: RAM-Verbrauch zu hoch auf $(hostname)"
    echo "To: $ALARM_EMAIL"
    echo
    echo "$WARNUNG am $($DATE)"
  } | /usr/bin/msmtp --from=default -t
fi

# Log-Eintrag zur Skriptausführung
echo "$($DATE '+%Y-%m-%d %H:%M:%S') - Skript ausgeführt, CPU: $CPU_LOAD, RAM: $RAM_USED MB" >> "$LOGFILE"
