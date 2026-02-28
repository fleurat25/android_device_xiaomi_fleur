# Define the patch directory relative to the ROM root
PATCH_DIR="device/xiaomi/fleur/patches"

if [ -d "$PATCH_DIR" ]; then
    echo "fleur: Checking for device-specific patches..."

    # Loop through all .patch files in the directory
    for patch_file in "$PATCH_DIR"/*.patch; do
        [ -e "$patch_file" ] || continue # skip if no patches exist

        # Extract the target directory from the first line of the patch
        # Assumes patches are created from the ROM root or have a standard header
        # We use 'patch -p1' which expects to be in the root of the repo being patched

        echo "fleur: Applying $(basename "$patch_file")..."

        # Check if patch can be applied (to avoid double-patching errors)
        if patch -p1 --dry-run < "$patch_file" > /dev/null 2>&1; then
            patch -p1 < "$patch_file"
            echo "fleur: Patch applied successfully."
        else
            echo "fleur: Patch already applied or mismatch, skipping."
        fi
    done
fi
