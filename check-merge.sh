#!/bin/bash

echo "Checking critical lines..."
echo ""

# Check init.lua
if grep -q "require 'custom'" init.lua; then
    echo "✅ init.lua: Custom loader present"
else
    echo "❌ init.lua: Custom loader MISSING!"
    exit 1
fi

# Check lazy.lua
if grep -q "{ import = 'custom.plugins' }" lua/config/lazy.lua; then
    echo "✅ lazy.lua: Custom plugins import present"
else
    echo "❌ lazy.lua: Custom plugins import MISSING!"
    exit 1
fi

# Test load
if nvim --headless "+lua require('custom')" "+lua print('OK')" +qa 2>&1 | grep -q "OK"; then
    echo "✅ Custom config loads successfully"
else
    echo "❌ Custom config FAILED to load!"
    exit 1
fi

echo ""
echo "All checks passed! ✅"
echo ""
echo "Your custom configuration is properly integrated."
