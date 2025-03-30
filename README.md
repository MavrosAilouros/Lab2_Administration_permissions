# Linux Administration Lab

This repository contains scripts developed for a practical lab focused on GNU/Linux system administration. Through three exercises, the lab explores topics such as permission management, process monitoring, and systemd services.

## Contents

- `ejercicio1.sh`: Manages users, groups, and file permissions.
- `ejercicio2.sh`: Monitors CPU and memory usage of a running process.
- `ejercicio3.sh`: Monitors changes in a directory using `inotifywait`.
- `monitoreo-cambios.service`: Custom service for directory monitoring.

---

## How to Run the Scripts

### Exercise 1 – User, Group, and File Permission Management

```bash
sudo bash ejercicio1.sh <user> <group> <file>
```

- Creates user and group if they do not exist.
- Assigns the user to the group.
- Changes ownership of the file.
- Applies 740 permissions if necessary.

### Exercise 2 – Resource Usage Monitoring

```bash
bash ejercicio2.sh <command>
```

- Runs the specified command in the background.
- Logs CPU and memory usage every second.
- Produces `reporte_de_uso.log` and `grafico_uso.png`.

Recommendation: Use commands like `sleep 10`, `gedit`, or `ping` that do not spawn a different PID.

### Exercise 3 – Directory Event Monitoring

```bash
bash ejercicio3.sh <directory>
```

- Monitors create, modify, and delete events.
- Appends detected events to `monitor.log`.

---

## Configuring the Service (Exercise 3)

You can install the service either as a **user-level service** (no sudo, suitable for WSL or personal use) or a **system-level service** (requires root).

### Option 1: User-level service (recommended for WSL or desktop sessions)

1. Copy the file `monitoreo-cambios.service` to:

```bash
~/.config/systemd/user/
```

2. Reload and start the service:

```bash
systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user start monitoreo-cambios.service
```

3. Check service status:

```bash
systemctl --user status monitoreo-cambios.service
```

4. View logged events:

```bash
cat ~/monitor.log
```

---

### Option 2: System-level service (requires root, recommended for native Linux setups)

1. Copy the file to the system folder:

```bash
sudo cp monitoreo-cambios.service /etc/systemd/system/
```

2. Reload and enable the service:

```bash
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable monitoreo-cambios.service
sudo systemctl start monitoreo-cambios.service
```

3. Check service status:

```bash
sudo systemctl status monitoreo-cambios.service
```

4. Log file will be stored according to the script, typically in:

```bash
/home/<user>/monitor.log
```

Note: Make sure the `ExecStart` and `WorkingDirectory` paths inside the service file are valid for the user running the service.

---

## Requirements and Notes

- These scripts are intended for GNU/Linux systems, including WSL (Windows Subsystem for Linux).
- Requires: `bash`, `ps`, `gnuplot`, `bc`, `inotify-tools`, `systemd` (user session enabled).
- Make sure you have the required permissions and dependencies installed.

---

## License

This project is provided for educational purposes.
