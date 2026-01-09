#!/usr/bin/env bash
set -euEo pipefail
trap 'echo "${BASH_SOURCE:-unknown}:${LINENO:-unknown}: $BASH_COMMAND";' ERR

extensions=(
    "amazonwebservices.aws-toolkit-vscode" # AWS Toolkit
    "ms-dotnettools.vscode-dotnet-pack" # .NET Extension Pack
    "ms-dotnettools.vscode-dotnet-runtime" # .NET Install Tool
    "ms-dotnettools.dotnet-maui" # .NET MAUI
    "vscode-aws-console.vscode-aws-console" # AWS Console EC2 Manager
    "ms-dotnettools.csharp" # C#
    "ms-dotnettools.csdevkit" # C# Dev Kit
    "firefox-devtools.vscode-firefox-debug" # Debugger for Firefox
    "VisualStudioExptTeam.vscodeintellicode" # IntelliCode
    "VisualStudioExptTeam.intellicode-api-usage-examples" # IntelliCode API Usage Examples
    "ms-dotnettools.vscodeintellicode-csharp" # IntelliCode for C# Dev Kit
    "christian-kohler.path-intellisense" # Path Intellisense
    "mohsen1.prettify-json" # Prettify JSON
    "foxundermoon.shell-format" # shell-format
    "ms-vscode.test-adapter-converter" # Test Adapter Converter
    "Gruntfuggly.todo-tree" # Todo Tree
    "shardulm94.trailing-spaces" # Trailing Spaces
    "ms-vscode.vs-keybindings" # Visual Studio Keymap
    "vscode-icons-team.vscode-icons" # vscode-icons
)

for extension in "${extensions[@]}"
do
    code --install-extension "$extension" --force
done