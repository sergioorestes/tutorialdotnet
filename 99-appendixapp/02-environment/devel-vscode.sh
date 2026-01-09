# VS Code
code --help

code --version
code --list-extensions

# Install Extensions
chmod 755 scripts/01-install-extensions.sh
./scripts/01-install-extensions.sh

# Install .NET on Linux
# Debian
wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb \
-O packages-microsoft-prod.deb

sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

# Install Sdk 8.0
sudo apt update && \
sudo apt install -y dotnet-sdk-8.0

dotnet --help

dotnet --info
dotnet --version
dotnet --list-runtimes
dotnet --list-sdks
