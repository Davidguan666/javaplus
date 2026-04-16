#!/bin/bash
# This script generates the self-extracting install.sh

echo '#!/bin/bash'
echo '# java+ Self-Extracting Installer'
echo '# This script contains ALL files needed to build java+'
echo ''
echo 'set -e'
echo ''
echo '# Colors'
echo 'RED="\033[0;31m"'
echo 'GREEN="\033[0;32m"'
echo 'YELLOW="\033[1;33m"'
echo 'BLUE="\033[0;34m"'
echo 'NC="\033[0m"'
echo ''
echo 'INSTALL_DIR="${INSTALL_DIR:-$HOME/.javaplus"}"'
echo 'PROJECT_DIR="$HOME/Desktop/Projects/javaplus"'
echo ''
echo 'echo -e "${BLUE}=== java+ Self-Extracting Installer ===${NC}"'
echo ''
echo '# Create project directory'
echo 'echo -e "${BLUE}Creating project structure...${NC}"'
echo 'mkdir -p "$PROJECT_DIR/src/graphics"'
echo 'mkdir -p "$PROJECT_DIR/src/stdlib"'
echo 'mkdir -p "$PROJECT_DIR/examples"'
echo 'mkdir -p "$PROJECT_DIR/docs"'
echo 'mkdir -p "$PROJECT_DIR/scripts"'
echo 'mkdir -p "$PROJECT_DIR/vscode-javaplus/icons"'
echo 'mkdir -p "$PROJECT_DIR/vscode-javaplus/snippets"'
echo 'mkdir -p "$PROJECT_DIR/vscode-javaplus/syntaxes"'
echo ''

# Function to add a file
add_file() {
    local file="$1"
    local varname=$(echo "$file" | sed 's/[^a-zA-Z0-9]/_/g')
    echo "# File: $file"
    echo "cat > \"\$PROJECT_DIR/$file\" << 'EOF_$(echo $varname | tr '[:lower:]' '[:upper:]')"
    cat "$file"
    echo "EOF_$(echo $varname | tr '[:lower:]' '[:upper:]')"
    echo ''
}

# Add all source files
for file in $(find . -type f \( -name "*.rs" -o -name "*.toml" -o -name "*.jpp" -o -name "*.html" -o -name "*.md" -o -name "*.json" -o -name "*.py" -o -name "*.sh" -o -name "*.svg" -o -name "*.scpt" \) | grep -v target | grep -v ".git" | grep -v generate_installer | sort); do
    add_file "$file"
done

echo 'echo -e "${GREEN}All files extracted!${NC}"'
echo ''
echo '# Build the compiler'
echo 'echo -e "${BLUE}Building java+ compiler...${NC}"'
echo 'cd "$PROJECT_DIR"'
echo 'cargo build --release'
echo ''
echo '# Install binaries'
echo 'echo -e "${BLUE}Installing to $INSTALL_DIR...${NC}"'
echo 'mkdir -p "$INSTALL_DIR/bin"'
echo 'cp target/release/jpp "$INSTALL_DIR/bin/jp"'
echo 'chmod +x "$INSTALL_DIR/bin/jp"'
echo ''
echo '# Add to PATH'
echo 'export PATH="$INSTALL_DIR/bin:$PATH"'
echo 'if ! grep -q "javaplus/bin" "$HOME/.zshrc" 2>/dev/null; then'
echo '    echo "" >> "$HOME/.zshrc"'
echo '    echo "# java+ Compiler" >> "$HOME/.zshrc"'
echo '    echo "export PATH=\"$HOME/.javaplus/bin:\$PATH\"" >> "$HOME/.zshrc"'
echo 'fi'
echo ''
echo 'echo ""'
echo 'echo -e "${GREEN}=== Installation Complete! ===${NC}"'
echo 'echo ""'
echo 'echo "java+ installed to: $INSTALL_DIR"'
echo 'echo "Project source at: $PROJECT_DIR"'
echo 'echo ""'
echo 'echo "To use jp command, run:"'
echo 'echo "  source ~/.zshrc"'
echo 'echo ""'
echo 'echo "Try it:"'
echo 'echo "  jp run ~/Desktop/Projects/javaplus/examples/hello.jpp"'
