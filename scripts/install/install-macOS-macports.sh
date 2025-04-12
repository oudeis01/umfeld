#!/bin/bash
# Using MacPorts for better backward compatibility for older macOS versions

set -e

echo "+++ Setting up umfeld with MacPorts +++"

# Check for MacPorts
check_macports() {
    if command -v port &>/dev/null; then
        echo "MacPorts is already installed."
    else
        echo "MacPorts not found. Installing..."
        install_macports
    fi
}

# Install MacPorts
install_macports() {
    # Get macOS version
    OS_VERSION=$(sw_vers -productVersion)
    ARCH=$(uname -m)
    
    # Download appropriate installer
    case "${ARCH}" in
        "arm64")
            PKG="MacPorts-2.8.1-13-Ventura.pkg"
            ;;
        "x86_64")
            case "${OS_VERSION}" in
                12.*) PKG="MacPorts-2.8.1-12-Monterey.pkg" ;;
                13.*) PKG="MacPorts-2.8.1-13-Ventura.pkg" ;;
                14.*) PKG="MacPorts-2.8.1-14-Sonoma.pkg" ;;
                *)    PKG="MacPorts-2.8.1-13-Ventura.pkg" ;;
            esac
            ;;
        *)
            echo "Unsupported architecture: ${ARCH}"
            echo "Please download the appropriate MacPorts installer from:"
            echo "https://www.macports.org/install.php"
            echo "and install it manually."
            echo "Exiting..."
            exit 1
            ;;
    esac

    INSTALLER_URL="https://github.com/macports/macports-base/releases/download/v2.8.1/${PKG}"
    
    echo "Downloading MacPorts installer..."
    curl -LO ${INSTALLER_URL}
    
    echo "Installing MacPorts (requires sudo)..."
    sudo installer -pkg ${PKG} -target /
    
    # Add MacPorts to PATH
    export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
    echo 'export PATH="/opt/local/bin:/opt/local/sbin:$PATH"' >> ~/.zshrc
}

# Main installation routine
check_macports

echo "+++ Updating MacPorts +++"
sudo port -v selfupdate

echo "+++ Installing packages +++"
sudo port -N install \
    cmake \
    pkgconfig \
    libsdl3 \
    glew \
    glm \
    harfbuzz \
    freetype \
    ffmpeg \
    rtmidi \
    dylibbundler \
    portaudio

echo "+++ Cleaning up +++"
sudo port -v clean --all installed

echo "+++ Installation complete +++"
echo "Note: You may need to restart your terminal or run:"
echo "  source ~/.zshrc"