#!/bin/bash

# java+ Compiler Installation Script
# This script installs the jp (java+ compiler) command and associated tools

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
INSTALL_DIR="${INSTALL_DIR:-$HOME/.javaplus}"
BIN_DIR="$INSTALL_DIR/bin"
LIB_DIR="$INSTALL_DIR/lib"
ICON_DIR="$INSTALL_DIR/icons"
COMPLETION_DIR="$INSTALL_DIR/completions"

# Detect OS
OS="$(uname -s)"
ARCH="$(uname -m)"

echo -e "${BLUE}=== java+ Compiler Installer ===${NC}"
echo ""

# Check for Rust/Cargo
if ! command -v cargo &> /dev/null; then
    echo -e "${YELLOW}Rust/Cargo not found. Installing...${NC}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi

# Create directories
echo -e "${BLUE}Creating installation directories...${NC}"
mkdir -p "$BIN_DIR"
mkdir -p "$LIB_DIR"
mkdir -p "$ICON_DIR"
mkdir -p "$COMPLETION_DIR"

# Build the compiler
echo -e "${BLUE}Building java+ compiler...${NC}"
cd "$(dirname "$0")"
cargo build --release

# Build the compiler
echo -e "${BLUE}Building java+ compiler...${NC}"
cd "$(dirname "$0")"
cargo build --release

# Copy binary
echo -e "${BLUE}Installing jpp binary...${NC}"
cp target/release/jpp "$BIN_DIR/jpp"
chmod +x "$BIN_DIR/jpp"

# Create wrapper scripts
echo -e "${BLUE}Creating command wrappers...${NC}"

# Main jp command
cat > "$BIN_DIR/jp" << 'EOF'
#!/bin/bash
# java+ Compiler Wrapper

JAVAPLUS_HOME="${JAVAPLUS_HOME:-$HOME/.javaplus}"
JPP_BIN="$JAVAPLUS_HOME/bin/jpp"

if [ ! -f "$JPP_BIN" ]; then
    echo "Error: java+ compiler not found at $JPP_BIN"
    echo "Please run the install script first."
    exit 1
fi

# Handle subcommands
command="$1"
shift

case "$command" in
    run)
        "$JPP_BIN" run "$@"
        ;;
    build)
        "$JPP_BIN" build "$@"
        ;;
    new)
        "$JPP_BIN" new "$@"
        ;;
    repl)
        "$JPP_BIN" repl "$@"
        ;;
    fmt)
        "$JPP_BIN" fmt "$@"
        ;;
    check)
        "$JPP_BIN" check "$@"
        ;;
    doc)
        "$JPP_BIN" doc "$@"
        ;;
    test)
        "$JPP_BIN" test "$@"
        ;;
    package)
        "$JPP_BIN" package "$@"
        ;;
    clean)
        "$JPP_BIN" clean "$@"
        ;;
    update)
        "$JPP_BIN" update "$@"
        ;;
    help|--help|-h)
        cat << 'HELP'
java+ Compiler (jp) - A game development programming language

Usage: jp <command> [options]

Commands:
  run <file.jpp>       Run a java+ program
  build [options]      Build project (compile to executable)
  new <project-name>   Create a new java+ project
  repl                 Start interactive REPL
  fmt [files]          Format java+ source files
  check <file.jpp>     Check for errors without running
  doc [options]        Generate documentation
  test [options]       Run tests
  package [options]    Package project for distribution
  clean                Clean build artifacts
  update               Update to latest version
  help                 Show this help message

Examples:
  jp run hello.jpp              Run a single file
  jp new MyGame                 Create new project
  jp build --release            Build optimized executable
  jp repl                       Start interactive session

Environment Variables:
  JAVAPLUS_HOME        Installation directory (default: ~/.javaplus)
  JAVAPLUS_PATH        Additional library search path

For more information: https://javaplus.dev/docs
HELP
        ;;
    *)
        # If no command specified but argument is a .jpp file, run it
        if [ -f "$command" ] && [[ "$command" == *.jpp ]]; then
            "$JPP_BIN" run "$command" "$@"
        else
            "$JPP_BIN" "$command" "$@"
        fi
        ;;
esac
EOF
chmod +x "$BIN_DIR/jp"

# jp-new: Create new project
cat > "$BIN_DIR/jp-new" << 'EOF'
#!/bin/bash
# Create a new java+ project

PROJECT_NAME="$1"
if [ -z "$PROJECT_NAME" ]; then
    echo "Usage: jp new <project-name>"
    exit 1
fi

if [ -d "$PROJECT_NAME" ]; then
    echo "Error: Directory '$PROJECT_NAME' already exists"
    exit 1
fi

echo "Creating new java+ project: $PROJECT_NAME"
mkdir -p "$PROJECT_NAME/src"
mkdir -p "$PROJECT_NAME/assets/sprites"
mkdir -p "$PROJECT_NAME/assets/sounds"
mkdir -p "$PROJECT_NAME/assets/fonts"
mkdir -p "$PROJECT_NAME/build"

# Create jpp.json
cat > "$PROJECT_NAME/jpp.json" << PROJECTCONFIG
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "description": "A java+ game project",
  "author": "Your Name",
  "source": "src",
  "output": "build",
  "entry": "main.jpp",
  "window": {
    "width": 1280,
    "height": 720,
    "title": "$PROJECT_NAME",
    "resizable": true
  },
  "assets": {
    "path": "assets",
    "include": ["**/*.png", "**/*.jpg", "**/*.wav", "**/*.mp3", "**/*.ttf", "**/*.json"]
  }
}
PROJECTCONFIG

# Create main.jpp
cat > "$PROJECT_NAME/src/main.jpp" << 'MAINFILE'
import std.io;

start() {
    print("Welcome to $PROJECT_NAME!");
    print("Built with java+ - Game Development Made Simple");
    
    // Your game code here
    let running = true;
    while (running) {
        // Game loop
        break; // Remove this when ready
    }
}
MAINFILE

# Create .gitignore
cat > "$PROJECT_NAME/.gitignore" << 'GITIGNORE'
# Build artifacts
/build/
/dist/
*.jpx

# IDE
.idea/
.vscode/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
GITIGNORE

echo "Project '$PROJECT_NAME' created successfully!"
echo ""
echo "To get started:"
echo "  cd $PROJECT_NAME"
echo "  jp run"
EOF
chmod +x "$BIN_DIR/jp-new"

# jp-repl: Interactive REPL
cat > "$BIN_DIR/jp-repl" << 'EOF'
#!/bin/bash
# java+ Interactive REPL

echo "java+ REPL (Read-Eval-Print Loop)"
echo "Type 'exit' or 'quit' to exit, 'help' for commands"
echo ""

JAVAPLUS_HOME="${JAVAPLUS_HOME:-$HOME/.javaplus}"
JPP_BIN="$JAVAPLUS_HOME/bin/jpp"

while true; do
    echo -n "jp> "
    read -r line
    
    case "$line" in
        exit|quit)
            echo "Goodbye!"
            exit 0
            ;;
        help)
            echo "REPL Commands:"
            echo "  exit, quit    - Exit the REPL"
            echo "  help          - Show this help"
            echo "  clear         - Clear the screen"
            ;;
        clear)
            clear
            ;;
        "")
            continue
            ;;
        *)
            # Create temporary file and run it
            TMPFILE=$(mktemp /tmp/jp_repl_XXXXXX.jpp)
            echo "start() { $line }" > "$TMPFILE"
            "$JPP_BIN" run "$TMPFILE" 2>&1 || true
            rm -f "$TMPFILE"
            ;;
    esac
done
EOF
chmod +x "$BIN_DIR/jp-repl"

# jp-fmt: Code formatter
cat > "$BIN_DIR/jp-fmt" << 'EOF'
#!/bin/bash
# java+ Code Formatter

echo "java+ Formatter - Coming soon!"
echo "This will format .jpp files according to style guidelines"
EOF
chmod +x "$BIN_DIR/jp-fmt"

# jp-check: Static analysis
cat > "$BIN_DIR/jp-check" << 'EOF'
#!/bin/bash
# java+ Static Checker

echo "java+ Static Checker - Coming soon!"
echo "This will check code for errors without running it"
EOF
chmod +x "$BIN_DIR/jp-check"

# jp-clean: Clean build artifacts
cat > "$BIN_DIR/jp-clean" << 'EOF'
#!/bin/bash
# Clean java+ build artifacts

echo "Cleaning build artifacts..."
rm -rf build/
rm -rf dist/
find . -name "*.jpx" -delete
echo "Done!"
EOF
chmod +x "$BIN_DIR/jp-clean"

# Setup shell integration
echo -e "${BLUE}Setting up shell integration...${NC}"

# Detect shell and setup accordingly
SHELL_NAME=$(basename "$SHELL")

case "$SHELL_NAME" in
    bash)
        SHELL_RC="$HOME/.bashrc"
        ;;
    zsh)
        SHELL_RC="$HOME/.zshrc"
        ;;
    fish)
        SHELL_RC="$HOME/.config/fish/config.fish"
        ;;
    *)
        SHELL_RC="$HOME/.profile"
        ;;
esac

# Add to PATH if not already present
if ! grep -q "$BIN_DIR" "$SHELL_RC" 2>/dev/null; then
    echo -e "${BLUE}Adding jp to your PATH in $SHELL_RC${NC}"
    echo "" >> "$SHELL_RC"
    echo "# java+ Compiler" >> "$SHELL_RC"
    echo "export JAVAPLUS_HOME=\"$INSTALL_DIR\"" >> "$SHELL_RC"
    echo 'export PATH="$JAVAPLUS_HOME/bin:$PATH"' >> "$SHELL_RC"
    
    # Add completion support
    if [ "$SHELL_NAME" = "bash" ] || [ "$SHELL_NAME" = "zsh" ]; then
        echo 'source "$JAVAPLUS_HOME/completions/jp.completion.bash" 2>/dev/null || true' >> "$SHELL_RC"
    fi
fi

# Create bash completion
cat > "$COMPLETION_DIR/jp.completion.bash" << 'EOF'
#!/bin/bash
# Bash completion for jp command

_jp_complete() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    opts="run build new repl fmt check doc test package clean update help"
    
    case "${prev}" in
        run|check)
            local files=$(ls *.jpp 2>/dev/null)
            COMPREPLY=( $(compgen -W "${files}" -- ${cur}) )
            return 0
            ;;
        jp)
            COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
            return 0
            ;;
    esac
}

complete -F _jp_complete jp
EOF

# Create icon files
echo -e "${BLUE}Installing file type icons...${NC}"

# macOS icon installation
if [ "$OS" = "Darwin" ]; then
    # Create iconset for macOS
    ICONSET_DIR="$ICON_DIR/jpp.iconset"
    mkdir -p "$ICONSET_DIR"
    
    # Generate simple icons using Python/Pillow if available
    if command -v python3 &> /dev/null; then
        python3 "$(dirname "$0")/scripts/generate_icons.py" "$ICON_DIR"
    fi
    
    # Register file type (requires admin privileges)
    echo -e "${YELLOW}To register .jpp file icons on macOS, run:${NC}"
    echo "  sudo $INSTALL_DIR/scripts/install_icons_macos.sh"
fi

# Linux icon installation
if [ "$OS" = "Linux" ]; then
    # Create icon directories
    mkdir -p "$HOME/.local/share/icons/hicolor/256x256/mimetypes"
    mkdir -p "$HOME/.local/share/mime/packages"
    
    # Generate icons
    if command -v python3 &> /dev/null; then
        python3 "$(dirname "$0")/scripts/generate_icons.py" "$ICON_DIR"
    fi
    
    echo -e "${YELLOW}To register .jpp file icons on Linux, run:${NC}"
    echo "  $INSTALL_DIR/scripts/install_icons_linux.sh"
fi

# Copy icon scripts
cp -r "$(dirname "$0")/scripts" "$INSTALL_DIR/" 2>/dev/null || true

# Create uninstall script
cat > "$INSTALL_DIR/uninstall.sh" << UNINSTALL
#!/bin/bash
# Uninstall java+ Compiler

echo "Uninstalling java+ Compiler..."

# Remove from PATH
sed -i.bak '/# java+ Compiler/d' "\$HOME/.bashrc" 2>/dev/null || true
sed -i.bak '/JAVAPLUS_HOME/d' "\$HOME/.bashrc" 2>/dev/null || true
sed -i.bak '/javaplus\/bin/d' "\$HOME/.bashrc" 2>/dev/null || true

sed -i.bak '/# java+ Compiler/d' "\$HOME/.zshrc" 2>/dev/null || true
sed -i.bak '/JAVAPLUS_HOME/d' "\$HOME/.zshrc" 2>/dev/null || true
sed -i.bak '/javaplus\/bin/d' "\$HOME/.zshrc" 2>/dev/null || true

# Remove installation directory
rm -rf "$INSTALL_DIR"

echo "java+ Compiler has been uninstalled."
echo "Please restart your terminal or run: source ~/.bashrc (or ~/.zshrc)"
UNINSTALL
chmod +x "$INSTALL_DIR/uninstall.sh"

# Add to current session PATH immediately
export PATH="$BIN_DIR:$PATH"

# Generate icons if Python and Pillow are available
if command -v python3 &> /dev/null; then
    if python3 -c "import PIL" 2>/dev/null; then
        echo -e "${BLUE}Generating icons...${NC}"
        python3 "$(dirname "$0")/scripts/generate_icons.py" "$ICON_DIR" 2>/dev/null || echo -e "${YELLOW}Icon generation skipped${NC}"
    else
        echo -e "${YELLOW}Pillow not installed. Icons not generated.${NC}"
        echo "Install with: pip3 install Pillow"
    fi
fi

# Summary
echo ""
echo -e "${GREEN}=== Installation Complete! ===${NC}"
echo ""
echo -e "${GREEN}java+ Compiler has been installed to:${NC} $INSTALL_DIR"
echo ""
echo "Available commands:"
echo "  jp <file.jpp>        - Run a java+ program"
echo "  jp run <file.jpp>    - Run a java+ program"
echo "  jp new <name>        - Create new project"
echo "  jp repl              - Interactive REPL"
echo "  jp build             - Build project"
echo "  jp fmt               - Format code"
echo "  jp check             - Static analysis"
echo "  jp clean             - Clean build artifacts"
echo "  jp help              - Show help"
echo ""
echo -e "${YELLOW}To start using jp, please run:${NC}"
echo "  source $SHELL_RC"
echo ""
echo "Or restart your terminal."
echo ""
echo -e "${BLUE}Try it out now:${NC}"
echo "  jp help"
echo "  jp new MyFirstGame"
