# Use the host's `/run/user/1000` directory
export XDG_RUNTIME_DIR=$HOME/.xdg_runtime_dir

# Use the host's Wayland socket
export WAYLAND_DISPLAY=wayland-0

# Make applications respect that
export DISPLAY=:0.0
export QT_QPA_PLATFORM=wayland
