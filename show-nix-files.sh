#!/usr/bin/env bash

# Print all .nix files with clear separators
find . -type f -name "*.nix" | while read -r file; do
    echo ""
    echo "===== FILE: $file ====="
    echo ""
    cat "$file"
    echo ""
    echo "===== END OF $file ====="
    echo ""
done
