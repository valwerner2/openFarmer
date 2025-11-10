# scripts/copy_folder.py
import shutil
import os
import sys
from SCons.Script import Import

Import("env")

# === CONFIGURATION ===
SRC_DIR = "../shared/embedded"          # Folder to copy
DST_DIR = "lib/shared"    # Destination folder (relative to project dir)
# ======================

def copy_folder(src, dst):
    if not os.path.exists(src):
        print(f"❌ Source folder does not exist: {src}")
        return

    os.makedirs(dst, exist_ok=True)

    for item in os.listdir(src):
        s = os.path.join(src, item)
        d = os.path.join(dst, item)
        if os.path.isdir(s):
            shutil.copytree(s, d, dirs_exist_ok=True)
        else:
            shutil.copy2(s, d)

    print(f"✅ Copied '{src}' → '{dst}'")

copy_folder(SRC_DIR, DST_DIR)