import os
import time
import shutil

SOURCE = "."
BACKUP = "../Nuvyra-backup"

IGNORE = {
    "node_modules",
    ".git",
    "dist",
    ".vite"
}

def backup():
    for root, dirs, files in os.walk(SOURCE):

        dirs[:] = [d for d in dirs if d not in IGNORE]

        for file in files:
            src = os.path.join(root, file)

            if src == "./auto_backup.py":
                continue

            relative = os.path.relpath(src, SOURCE)
            dest = os.path.join(BACKUP, relative)

            os.makedirs(os.path.dirname(dest), exist_ok=True)

            try:
                shutil.copy2(src, dest)
            except:
                pass

while True:
    backup()
    print("Backup Nuvyra synchronisé")
    time.sleep(10)
