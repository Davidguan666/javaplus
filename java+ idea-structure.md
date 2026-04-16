# java+ Programming Language Specification

## A. Language Name + Alternatives

### Primary Name: **java+** (pronounced "java plus")
**Rationale**: Builds on Java's reputation while signaling enhancement. The `+` evokes C++'s evolution story but keeps the friendly Java branding. Easy to search, type, and remember.

### Alternative Names Considered:

| Name | Rationale |
|------|-----------|
| **Quest** | Evokes adventure and game development journey. Short, memorable, and has positive connotations of achievement and exploration. |
| **Sprite** | Directly references game graphics while sounding light and approachable. Appeals to 2D game developers especially. |
| **Forge** | Suggests creation, crafting, and building games. Strong, active verb that implies powerful creation tools. |

---

## B. Full Syntax Specification

### File Extension: `.jpp` (java+ program)

### 1. Hello World

```java+
// No class wrapper required for simple scripts
import std.io;

start() {
    print("Hello, Game World!");
}
```

### 2. Basic Syntax Features

```java+
// Type inference
let playerName = "Hero";           // immutable
var score = 0;                      // mutable

// Auto-properties - no getters/setters needed
class Player {
    property name: String;          // auto-generates get/set
    property health: Int = 100;     // with default value
    
    // Computed property
    property isAlive: Bool => health > 0;
}

// Usage
let player = new Player();
player.name = "Alice";              // direct assignment
print(player.name);                 // direct access
```

### 3. Native Game Types

```java+
// Built-in vector types
let position = vec2(100, 200);      // 2D vector
let velocity = vec3(0, 9.8, 0);     // 3D vector
let color = rgb(255, 128, 64);      // RGB color
let transform = mat4.identity();    // 4x4 matrix

// Vector operations
let newPos = position + vec2(10, 20);
let distance = position.magnitude();
let normalized = velocity.normalized();

// Color operations
let transparent = color.withAlpha(128);
let mixed = color.lerp(rgb(0, 0, 0), 0.5);
```

### 4. Spawning Game Objects

```java+
import game.scene;
import game.entity;
import game.graphics;

start() {
    // Create a scene
    let mainScene = Scene.create("MainLevel");
    
    // Spawn a simple entity
    let player = mainScene.spawn("Player");
    player.position = vec2(400, 300);
    player.scale = vec2(2, 2);
    
    // Spawn with components
    let enemy = mainScene.spawn("Enemy", {
        position: vec2(100, 100),
        sprite: Sprite.load("enemy.png"),
        health: 50,
        tag: "hostile"
    });
    
    // Entity with behavior script
    let coin = mainScene.spawn("Coin", {
        position: vec2(500, 200),
        script: CoinBehavior.class
    });
}

// Entity behavior script
entity CoinBehavior {
    var rotationSpeed = 2.0;
    
    update(deltaTime) {
        this.rotation += rotationSpeed * deltaTime;
    }
    
    onCollect(player) {
        player.score += 10;
        this.destroy();
    }
}
```

### 5. Handling Player Input

```java+
import game.input;

entity PlayerController {
    var speed = 200.0;
    var jumpForce = 500.0;
    
    update(deltaTime) {
        // Keyboard input
        if (Input.isKeyDown(Key.A)) {
            this.position.x -= speed * deltaTime;
        }
        if (Input.isKeyDown(Key.D)) {
            this.position.x += speed * deltaTime;
        }
        
        // Key press (single trigger)
        if (Input.isKeyPressed(Key.Space)) {
            this.velocity.y = -jumpForce;
        }
        
        // Mouse input
        if (Input.isMouseButtonDown(MouseButton.Left)) {
            let mousePos = Input.mousePosition();
            this.lookAt(mousePos);
        }
        
        // Gamepad input
        let leftStick = Input.getGamepadAxis(0, GamepadAxis.LeftX);
        this.position.x += leftStick * speed * deltaTime;
        
        if (Input.isGamepadButtonPressed(0, GamepadButton.A)) {
            this.jump();
        }
    }
}
```

### 6. Playing Sound

```java+
import game.audio;

start() {
    // Load audio assets
    let bgm = Audio.loadMusic("background.mp3");
    let jumpSfx = Audio.loadSound("jump.wav");
    let explosionSfx = Audio.loadSound("explosion.wav");
    
    // Play music (loops by default)
    bgm.play(volume: 0.7);
    bgm.setLoop(true);
    
    // Play sound effects
    jumpSfx.play(volume: 1.0, pitch: 1.0);
    
    // 3D positional audio
    explosionSfx.playAt(vec3(10, 0, 5), volume: 0.8);
}

entity Player {
    jump() {
        // Play with variations
        Audio.play("jump.wav", {
            volume: 0.8,
            pitch: 1.0 + random(-0.1, 0.1)  // slight pitch variation
        });
    }
}
```

### 7. Loading Sprites

```java+
import game.assets;
import game.graphics;

start() {
    // Load sprite from file
    let playerSprite = Sprite.load("sprites/player.png");
    
    // Load with options
    let background = Sprite.load("bg.png", {
        filter: Filter.Linear,
        wrap: WrapMode.Repeat
    });
    
    // Load sprite sheet / animation
    let runAnimation = Animation.load("sprites/player_run.png", {
        frameWidth: 32,
        frameHeight: 32,
        frames: 8,
        fps: 12
    });
    
    // Load tilemap
    let tilemap = Tilemap.load("maps/level1.json");
    
    // Load font
    let gameFont = Font.load("fonts/retro.ttf", size: 24);
}

entity Renderable {
    var sprite: Sprite;
    
    render(renderer) {
        renderer.draw(sprite, this.position, {
            rotation: this.rotation,
            scale: this.scale,
            color: Color.white,
            origin: vec2(0.5, 0.5)  // center pivot
        });
    }
}
```

### 8. Basic Game Loop

```java+
import game.core;
import game.scene;
import game.graphics;
import game.input;

// Global game state
var gameScene: Scene;
var isPaused = false;

start() {
    // Initialize game
    Window.create("My Game", width: 1280, height: 720);
    Graphics.setVSync(true);
    
    gameScene = Scene.create("Main");
    loadLevel(gameScene);
    
    // Start the game loop
    Core.run(gameLoop);
}

// Main game loop - called every frame
func gameLoop(deltaTime: Float) {
    // Process input
    if (Input.isKeyPressed(Key.Escape)) {
        isPaused = !isPaused;
    }
    
    if (!isPaused) {
        // Update game logic
        gameScene.update(deltaTime);
        Physics.update(deltaTime);
    }
    
    // Render
    Graphics.clear(Color.black);
    gameScene.render();
    renderUI();
    Graphics.present();
}

func loadLevel(scene: Scene) {
    // Load level data
    scene.loadFromFile("levels/level1.scene");
}

func renderUI() {
    // Draw HUD
    UI.drawText("Score: " + score, vec2(10, 10), Color.white);
    UI.drawText("Health: " + player.health, vec2(10, 40), Color.red);
}
```

### 9. Lambda and Event System

```java+
// Concise lambda syntax
let onClick = (x, y) => print("Clicked at " + x + ", " + y);

// Event subscription
button.onClick += onClick;

// Inline lambda
button.onHover += () => button.scale = vec2(1.1, 1.1);
button.onLeave += () => button.scale = vec2(1.0, 1.0);

// Event with multiple listeners
collisionEvent += (entityA, entityB) => {
    Audio.play("collision.wav");
    spawnParticles(entityA.position);
};

// Async operations with callbacks
Assets.loadAsync("level2.json", (asset) => {
    nextLevel = asset;
    showReadyMessage();
});
```

### 10. Error Handling (No Checked Exceptions)

```java+
// Simplified try/catch - all exceptions are unchecked
try {
    let file = File.open("save.dat");
    let data = file.readAll();
    player.load(data);
} catch (e: FileNotFoundError) {
    print("Save file not found, starting new game");
    startNewGame();
} catch (e) {
    print("Error loading save: " + e.message);
}

// Optional type for safe operations
let result: Option<PlayerData> = tryLoadPlayer();
if (let data = result) {
    player.load(data);
}

// Result type for operations that can fail
let loadResult: Result<Texture, Error> = Texture.load("texture.png");
match loadResult {
    Ok(texture) => sprite.texture = texture,
    Err(error) => useDefaultTexture()
}
```

---

## C. Icon Design System

### Color Palette
- **Primary**: `#FF6B35` (Vibrant Orange) - Energy, creativity, fun
- **Secondary**: `#004E89` (Deep Blue) - Trust, technology, depth
- **Accent**: `#F7B801` (Golden Yellow) - Achievement, rewards, highlights
- **Background**: `#1A1A2E` (Dark Navy) - Professional, game-focused

### File Icons

#### Source Files (.jpp)
- **Shape**: Stylized document with folded corner
- **Symbol**: `J+` monogram in orange on dark background
- **Style**: Flat design with subtle gradient
- **Size**: 16x16, 32x32, 48x48, 256x256
- **Details**: Small game controller icon watermark in corner

#### Project Folders
- **Shape**: Standard folder with tab
- **Symbol**: Gamepad icon in center
- **Color**: Blue folder with orange accent stripe
- **Style**: Slightly open folder suggesting active project

#### Compiled Builds (.jpx)
- **Shape**: Gear/cog icon
- **Symbol**: Binary `01` pattern background
- **Color**: Metallic gray with orange highlights
- **Style**: 3D-ish appearance suggesting executable power

#### Asset Bundles (.jpa)
- **Shape**: Stacked layers icon
- **Symbol**: Image + Sound wave symbols
- **Color**: Purple gradient (creative assets)
- **Style**: Layered appearance showing bundle contents

#### Config Files (.jpc)
- **Shape**: Gear with document
- **Symbol**: Wrench/settings icon
- **Color**: Green (configuration/safe)
- **Style**: Clean, technical appearance

### Visual Style Guidelines
- Flat design with subtle depth shadows
- Rounded corners (2-3px radius)
- Consistent 2px stroke width for outlines
- High contrast for accessibility
- Dark mode optimized

---

## D. Script Type Definitions

### 1. Scene Scripts (.scene)
Define scene layout, entities, and initial state.

```java+
// level1.scene
scene MainLevel {
    background: Color.skyBlue,
    gravity: vec2(0, 980),
    
    entities: [
        Player {
            position: vec2(100, 500),
            controller: PlayerController
        },
        Platform {
            position: vec2(400, 600),
            size: vec2(800, 50),
            sprite: "ground.png"
        },
        Enemy {
            position: vec2(600, 400),
            patrolPath: [vec2(500, 400), vec2(700, 400)]
        } spawn(5)
    ],
    
    cameras: [
        MainCamera {
            follow: Player,
            smoothness: 0.1,
            bounds: Rect(0, 0, 2000, 1000)
        }
    ],
    
    onLoad() {
        Audio.playMusic("level1_bgm.mp3");
    }
}
```

### 2. Entity Scripts (.entity)
Define reusable entity behaviors and components.

```java+
// player.entity
entity Player {
    // Properties
    property health: Int = 100;
    property speed: Float = 200.0;
    property jumpForce: Float = 500.0;
    
    // Components
    component sprite: Sprite = Sprite.load("player.png");
    component collider: BoxCollider = BoxCollider(size: vec2(32, 48));
    component rigidbody: RigidBody = RigidBody(mass: 1.0);
    
    // Lifecycle methods
    start() {
        this.position = spawnPoint;
    }
    
    update(deltaTime) {
        handleInput();
        updateAnimation();
    }
    
    // Custom methods
    func handleInput() {
        let moveInput = Input.getAxis("Horizontal");
        rigidbody.velocity.x = moveInput * speed;
        
        if (Input.isButtonPressed("Jump") && isGrounded) {
            rigidbody.velocity.y = -jumpForce;
        }
    }
    
    // Event handlers
    onCollisionEnter(other) {
        if (other.tag == "Enemy") {
            takeDamage(10);
        }
    }
    
    func takeDamage(amount: Int) {
        health -= amount;
        if (health <= 0) {
            die();
        }
    }
}
```

### 3. UI Scripts (.ui)
Define HUD, menus, and interface elements.

```java+
// hud.ui
ui HUD {
    anchor: Anchor.TopLeft,
    
    // Health bar
    panel HealthBar {
        position: vec2(20, 20),
        size: vec2(200, 30),
        background: Color.darkGray,
        
        bar HealthFill {
            fill: Color.red,
            value: bind(player.health / player.maxHealth)
        }
        
        text HealthText {
            content: bind(player.health + "/" + player.maxHealth),
            font: "ui.ttf",
            size: 16,
            color: Color.white,
            align: TextAlign.Center
        }
    }
    
    // Score display
    text ScoreText {
        position: vec2(20, 60),
        content: bind("Score: " + game.score),
        font: "ui.ttf",
        size: 24,
        color: Color.yellow
    }
    
    // Minimap
    panel Minimap {
        position: vec2(Screen.width - 150, 20),
        size: vec2(128, 128),
        background: Color.black.withAlpha(128),
        
        render(canvas) {
            canvas.drawMap(game.worldMap, player.position);
            canvas.drawDot(player.position, Color.green);
        }
    }
    
    // Pause menu
    panel PauseMenu {
        visible: bind(game.isPaused),
        position: vec2.center,
        size: vec2(300, 400),
        
        button Resume {
            text: "Resume",
            onClick: () => game.resume()
        }
        
        button Quit {
            text: "Quit to Menu",
            onClick: () => Scene.load("MainMenu")
        }
    }
}
```

### 4. Network Scripts (.net)
Define multiplayer networking logic.

```java+
// multiplayer.net
net MultiplayerGame {
    maxPlayers: 4,
    tickRate: 60,
    
    // Server-side
    server {
        onPlayerConnect(player) {
            broadcast(player.name + " joined the game");
            spawnPlayer(player);
        }
        
        onPlayerDisconnect(player) {
            broadcast(player.name + " left the game");
            despawnPlayer(player);
        }
        
        update(deltaTime) {
            // Server authoritative game state
            syncGameState();
        }
    }
    
    // Client-side
    client {
        onConnect() {
            UI.show("Connected to server");
        }
        
        onDisconnect(reason) {
            UI.show("Disconnected: " + reason);
            Scene.load("MainMenu");
        }
        
        // Input prediction
        sendInput(inputState) {
            rpc("PlayerInput", inputState);
            predictMovement(inputState);
        }
        
        // Receive server state
        rpc onGameStateUpdate(state) {
            reconcile(state);
        }
    }
    
    // RPC definitions
    rpc spawnPlayer(playerData);
    rpc updateTransform(entityId, transform);
    rpc playerShoot(playerId, direction);
    rpc takeDamage(entityId, amount);
}
```

### 5. Shader Scripts (.shader)
Define custom GPU shaders.

```java+
// glow.shader
shader GlowEffect {
    // Vertex shader
    vertex {
        input {
            vec3 position;
            vec2 texCoord;
            vec4 color;
        }
        
        output {
            vec2 uv;
            vec4 tint;
        }
        
        uniform mat4 mvpMatrix;
        
        main() {
            gl_Position = mvpMatrix * vec4(position, 1.0);
            uv = texCoord;
            tint = color;
        }
    }
    
    // Fragment shader
    fragment {
        input {
            vec2 uv;
            vec4 tint;
        }
        
        output vec4 fragColor;
        
        uniform sampler2D mainTexture;
        uniform float glowIntensity;
        uniform vec3 glowColor;
        
        main() {
            vec4 texColor = texture(mainTexture, uv);
            
            // Simple glow effect
            float brightness = dot(texColor.rgb, vec3(0.299, 0.587, 0.114));
            vec3 glow = glowColor * brightness * glowIntensity;
            
            fragColor = vec4(texColor.rgb + glow, texColor.a) * tint;
        }
    }
}
```

### 6. Config Scripts (.cfg)
Define game settings and configuration.

```java+
// game.cfg
cfg GameSettings {
    // Display settings
    display {
        resolution: vec2(1920, 1080),
        fullscreen: false,
        vsync: true,
        targetFps: 60
    }
    
    // Audio settings
    audio {
        masterVolume: 1.0,
        musicVolume: 0.7,
        sfxVolume: 1.0,
        spatialAudio: true
    }
    
    // Input settings
    input {
        // Key bindings
        keybindings {
            moveLeft: Key.A,
            moveRight: Key.D,
            jump: Key.Space,
            attack: MouseButton.Left,
            pause: Key.Escape
        }
        
        // Gamepad bindings
        gamepad {
            move: GamepadAxis.LeftStick,
            jump: GamepadButton.A,
            attack: GamepadButton.RT
        }
        
        mouseSensitivity: 1.0
    }
    
    // Gameplay settings
    gameplay {
        difficulty: Difficulty.Normal,
        permadeath: false,
        autoSave: true,
        saveInterval: 300  // seconds
    }
    
    // Network settings
    network {
        serverPort: 7777,
        maxPlayers: 8,
        tickRate: 60
    }
}
```

---

## E. Standard Library Overview

### Core Module (`std`)
```java+
import std.io;        // Console I/O, file operations
import std.math;      // Math functions, random
import std.string;    // String manipulation
import std.array;     // Array/List operations
import std.map;       // Dictionary/HashMap
import std.time;      // DateTime, timers
import std.json;      // JSON parsing/serialization
```

### Game Module (`game`)
```java+
import game.core;       // Window, game loop, timing
import game.scene;      // Scene management
import game.entity;     // Entity component system
import game.graphics;   // 2D/3D rendering
import game.physics;    // Physics engine
import game.input;      // Input handling
import game.audio;      // Sound and music
import game.assets;     // Asset loading
import game.collision;  // Collision detection
import game.ui;         // UI system
import game.network;    // Multiplayer networking
import game.math;       // Game math (vectors, matrices)
```

### Graphics Module (`game.graphics`)
```java+
// Core types
class Window;           // Window creation and management
class Renderer;         // 2D rendering context
class Camera;           // View/camera control
class Sprite;           // 2D sprite
class Texture;          // GPU texture
class Shader;           // Shader program
class Material;         // Render material
class Mesh;             // 3D mesh
class Model;            // 3D model
class Animation;        // Sprite animation
class ParticleSystem;   // Particle effects
class Tilemap;          // Tilemap rendering
class Font;             // Text rendering
class Canvas;           // Immediate mode drawing

// Key functions
func clear(color: Color);
func present();
func setVSync(enabled: Bool);
func setTargetFps(fps: Int);
func screenshot(): Image;
```

### Physics Module (`game.physics`)
```java+
// Core types
class RigidBody;        // Physics body
class Collider;         // Base collider
class BoxCollider;      // Box shape
class CircleCollider;   // Circle shape
class PolygonCollider;  // Polygon shape
class PhysicsWorld;     // Physics simulation
class RaycastHit;       // Raycast result

// Key functions
func update(deltaTime: Float);
func raycast(start: Vec2, end: Vec2): Option<RaycastHit>;
func overlapCircle(center: Vec2, radius: Float): Array<Entity>;
func setGravity(gravity: Vec2);
```

### Input Module (`game.input`)
```java+
// Key functions
func isKeyDown(key: Key): Bool;
func isKeyPressed(key: Key): Bool;
func isKeyReleased(key: Key): Bool;
func isMouseButtonDown(button: MouseButton): Bool;
func mousePosition(): Vec2;
func mouseDelta(): Vec2;
func getAxis(name: String): Float;
func getGamepadAxis(player: Int, axis: GamepadAxis): Float;
func isGamepadButtonDown(player: Int, button: GamepadButton): Bool;
```

### Audio Module (`game.audio`)
```java+
// Core types
class Sound;            // Short sound effect
class Music;            // Streaming music
class AudioSource;      // 3D audio source
class AudioMixer;       // Audio mixing groups

// Key functions
func loadSound(path: String): Sound;
func loadMusic(path: String): Music;
func play(sound: Sound, options: SoundOptions);
func playAt(sound: Sound, position: Vec3, options: SoundOptions);
func setMasterVolume(volume: Float);
func setListenerPosition(position: Vec3, forward: Vec3, up: Vec3);
```

### Assets Module (`game.assets`)
```java+
// Core types
class AssetManager;     // Asset loading and caching
class Asset<T>;         // Typed asset reference

// Key functions
func load<T>(path: String): T;
func loadAsync<T>(path: String, callback: (T) -> void);
func preload(paths: Array<String>);
func unload(path: String);
func unloadAll();
func getProgress(): Float;
```

### UI Module (`game.ui`)
```java+
// Core types
class UIElement;        // Base UI element
class Panel;            // Container panel
class Button;           // Clickable button
class Label;            // Text label
class Image;            // UI image
class Slider;           // Value slider
class TextField;        // Input field
class Dropdown;         // Selection dropdown
class ScrollView;       // Scrollable container
class Canvas;           // UI canvas/root

// Key functions
func drawText(text: String, position: Vec2, color: Color);
func drawRect(rect: Rect, color: Color);
func drawLine(start: Vec2, end: Vec2, color: Color, thickness: Float);
func measureText(text: String, font: Font): Vec2;
```

### Network Module (`game.network`)
```java+
// Core types
class NetworkManager;   // Network management
class Client;           // Client connection
class Server;           // Server host
class NetworkPlayer;    // Connected player
class RpcChannel;       // RPC communication

// Key functions
func connect(address: String, port: Int): Client;
func host(port: Int, maxPlayers: Int): Server;
func disconnect();
func rpc(name: String, ...args);
func sync(variable: var);
```

### Math Module (`game.math`)
```java+
// Vector types
struct Vec2 { x: Float; y: Float; }
struct Vec3 { x: Float; y: Float; z: Float; }
struct Vec4 { x: Float; y: Float; z: Float; w: Float; }

// Matrix types
struct Mat2;
struct Mat3;
struct Mat4;

// Color type
struct Color { r: Int; g: Int; b: Int; a: Int; }

// Rectangle
struct Rect { x: Float; y: Float; width: Float; height: Float; }

// Quaternion
struct Quaternion;

// Key functions
func lerp(a: Float, b: Float, t: Float): Float;
func clamp(value: Float, min: Float, max: Float): Float;
func random(min: Float, max: Float): Float;
func randomInt(min: Int, max: Int): Int;
func distance(a: Vec2, b: Vec2): Float;
func angle(from: Vec2, to: Vec2): Float;
```

---

## F. Compiler/Runtime Architecture

### Compilation Pipeline

```
Source (.jpp)
    |
    v
[Lexer] → Tokens
    |
    v
[Parser] → AST (Abstract Syntax Tree)
    |
    v
[Semantic Analyzer] → Validated AST
    |
    v
[Type Checker] → Typed AST
    |
    v
[IR Generator] → Intermediate Representation
    |
    v
[Optimizer] → Optimized IR
    |
    +---> [JIT Compiler] → Native Machine Code (Development)
    |
    +---> [Bytecode Compiler] → .jpx files (Distribution)
    |
    v
[Runtime] → Execution
```

### Runtime Architecture

```
+---------------------+
|    Application      |
+---------------------+
|    java+ Runtime    |
+---------------------+
|  Memory Manager     |
|  - Garbage Collector|
|  - Object Pool      |
+---------------------+
|  Execution Engine   |
|  - Interpreter      |
|  - JIT Compiler     |
+---------------------+
|  Standard Library   |
|  - std module       |
|  - game module      |
+---------------------+
|  Platform Layer     |
|  - OS Abstraction   |
|  - Graphics API     |
|  - Audio API        |
|  - Input API        |
+---------------------+
```

### Cross-Platform Support

| Platform | Status | Backend |
|----------|--------|---------|
| Windows | Full | DirectX 11/12, Vulkan |
| macOS | Full | Metal, Vulkan (MoltenVK) |
| Linux | Full | Vulkan, OpenGL |
| iOS | Full | Metal |
| Android | Full | Vulkan, OpenGL ES |
| Web (WASM) | Full | WebGL, WebGPU |
| Nintendo Switch | Partner | Vulkan |
| PlayStation | Partner | Proprietary |
| Xbox | Partner | DirectX |

### Garbage Collection

- **Algorithm**: Incremental Generational GC
- **Young Generation**: Copying collector for short-lived objects
- **Old Generation**: Mark-sweep-compact for long-lived objects
- **Pause Time**: Target < 1ms per frame at 60fps
- **Manual Control**: `GC.collect()` for explicit collection
- **Weak References**: Supported for caches and listeners

### Performance Optimizations

1. **JIT Compilation**: Hot paths compiled to native code
2. **Object Pooling**: Built-in pooling for game objects
3. **SIMD**: Vector operations use SSE/AVX/NEON
4. **Cache Friendly**: ECS architecture for data locality
5. **Async Loading**: Non-blocking asset loading
6. **Multi-threading**: Job system for parallel tasks

---

## G. IDE Integration Plan

### Supported IDEs
- **java+ Studio** (Official IDE - based on VS Code)
- **VS Code** (via extension)
- **IntelliJ IDEA** (via plugin)
- **Vim/Neovim** (via LSP)

### Syntax Highlighting

```json
{
  "keywords": [
    "start", "import", "class", "entity", "scene", "ui", "net",
    "shader", "cfg", "if", "else", "for", "while", "match",
    "return", "break", "continue", "try", "catch", "property",
    "component", "func", "let", "var", "new", "this", "super",
    "true", "false", "null"
  ],
  "types": [
    "Int", "Float", "Bool", "String", "Vec2", "Vec3", "Vec4",
    "Mat4", "Color", "Array", "Map", "Option", "Result"
  ],
  "comments": {
    "line": "//",
    "block": ["/*", "*/"]
  }
}
```

### Language Server Protocol (LSP) Features

| Feature | Status |
|---------|--------|
| Syntax Validation | Full |
| Type Checking | Full |
| Autocomplete | Full |
| Go to Definition | Full |
| Find References | Full |
| Rename Refactoring | Full |
| Code Formatting | Full |
| Hover Information | Full |
| Signature Help | Full |
| Document Symbols | Full |
| Code Actions | Partial |

### Autocomplete Categories

1. **Keywords**: Language keywords and constructs
2. **Types**: Built-in and user-defined types
3. **Variables**: Local and global variables
4. **Functions**: Available functions with signatures
5. **Modules**: Import suggestions
6. **Snippets**: Common code patterns

### Debugger Protocol

```
Debug Adapter Protocol (DAP) Support:
- Breakpoints (line, conditional, function)
- Step over/into/out
- Variable inspection
- Call stack navigation
- Watch expressions
- Hot reload (code changes without restart)
```

### Build System Integration

```json
// jpp.json - Project configuration
{
  "name": "MyGame",
  "version": "1.0.0",
  "source": "src",
  "output": "build",
  "entry": "main.jpp",
  
  "dependencies": {
    "std": "1.0.0",
    "tiled": "2.1.0",
    "particles": "1.5.0"
  },
  
  "assets": {
    "path": "assets",
    "include": ["**/*.png", "**/*.wav", "**/*.json"]
  },
  
  "build": {
    "target": "desktop",
    "optimize": "release",
    "compress": true
  }
}
```

### CLI Tool: `jpp`

```bash
# Create new project
jpp new MyGame

# Build project
jpp build
jpp build --release
jpp build --target=web

# Run project
jpp run
jpp run --debug

# Package for distribution
jpp package

# Install dependencies
jpp install <package>
jpp update

# Run tests
jpp test
```

---

## H. Sample Mini-Game: Pong

### Project Structure
```
pong/
├── jpp.json
├── src/
│   ├── main.jpp
│   ├── entities/
│   │   ├── Paddle.jpp
│   │   └── Ball.jpp
│   └── ui/
│       └── HUD.jpp
└── assets/
    ├── sounds/
    │   ├── paddle_hit.wav
    │   └── score.wav
    └── fonts/
        └── retro.ttf
```

### main.jpp
```java+
import game.core;
import game.scene;
import game.graphics;
import game.input;
import game.audio;
import game.ui;

// Game constants
const SCREEN_WIDTH = 800;
const SCREEN_HEIGHT = 600;
const PADDLE_WIDTH = 20;
const PADDLE_HEIGHT = 100;
const BALL_SIZE = 15;
const PADDLE_SPEED = 400;
const BALL_SPEED = 300;

// Game state
var gameScene: Scene;
var playerScore = 0;
var aiScore = 0;
var isGameOver = false;

start() {
    // Initialize window
    Window.create("Pong", width: SCREEN_WIDTH, height: SCREEN_HEIGHT);
    Graphics.setVSync(true);
    
    // Load assets
    Audio.preload([
        "assets/sounds/paddle_hit.wav",
        "assets/sounds/score.wav"
    ]);
    
    // Create scene
    gameScene = Scene.create("Game");
    setupGame();
    
    // Start game loop
    Core.run(gameLoop);
}

func setupGame() {
    // Create player paddle
    let playerPaddle = gameScene.spawn("PlayerPaddle", {
        position: vec2(50, SCREEN_HEIGHT / 2),
        size: vec2(PADDLE_WIDTH, PADDLE_HEIGHT),
        isPlayer: true
    });
    
    // Create AI paddle
    let aiPaddle = gameScene.spawn("AIPaddle", {
        position: vec2(SCREEN_WIDTH - 50, SCREEN_HEIGHT / 2),
        size: vec2(PADDLE_WIDTH, PADDLE_HEIGHT),
        isPlayer: false
    });
    
    // Create ball
    let ball = gameScene.spawn("Ball", {
        position: vec2(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2),
        size: vec2(BALL_SIZE, BALL_SIZE)
    });
    
    // Store references for easy access
    gameScene.setData("playerPaddle", playerPaddle);
    gameScene.setData("aiPaddle", aiPaddle);
    gameScene.setData("ball", ball);
}

func gameLoop(deltaTime: Float) {
    // Handle input
    if (Input.isKeyPressed(Key.R)) {
        resetGame();
    }
    if (Input.isKeyPressed(Key.Escape)) {
        Core.quit();
    }
    
    // Update game logic
    if (!isGameOver) {
        gameScene.update(deltaTime);
        checkWinCondition();
    }
    
    // Render
    Graphics.clear(Color.black);
    
    // Draw center line
    for (let i = 0; i < SCREEN_HEIGHT; i += 20) {
        Graphics.drawRect(
            Rect(SCREEN_WIDTH / 2 - 2, i, 4, 10),
            Color.white.withAlpha(128)
        );
    }
    
    // Draw entities
    gameScene.render();
    
    // Draw UI
    renderUI();
    
    Graphics.present();
}

func renderUI() {
    let font = Font.load("assets/fonts/retro.ttf", size: 48);
    
    // Draw scores
    UI.drawText(
        playerScore.toString(),
        vec2(SCREEN_WIDTH / 4, 50),
        Color.white,
        font: font,
        align: TextAlign.Center
    );
    
    UI.drawText(
        aiScore.toString(),
        vec2(SCREEN_WIDTH * 3 / 4, 50),
        Color.white,
        font: font,
        align: TextAlign.Center
    );
    
    // Draw game over message
    if (isGameOver) {
        let winner = playerScore >= 10 ? "Player Wins!" : "AI Wins!";
        UI.drawText(
            winner,
            vec2(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 - 50),
            Color.yellow,
            font: Font.load("assets/fonts/retro.ttf", size: 36),
            align: TextAlign.Center
        );
        
        UI.drawText(
            "Press R to restart",
            vec2(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 + 20),
            Color.white,
            font: Font.load("assets/fonts/retro.ttf", size: 20),
            align: TextAlign.Center
        );
    }
}

func checkWinCondition() {
    if (playerScore >= 10 || aiScore >= 10) {
        isGameOver = true;
    }
}

func resetGame() {
    playerScore = 0;
    aiScore = 0;
    isGameOver = false;
    
    // Reset ball
    let ball = gameScene.getData<Ball>("ball");
    ball.reset();
}

func onScore(playerScored: Bool) {
    if (playerScored) {
        playerScore++;
    } else {
        aiScore++;
    }
    
    Audio.play("assets/sounds/score.wav");
}
```

### entities/Paddle.jpp
```java+
import game.entity;
import game.input;
import game.graphics;

entity Paddle {
    // Properties
    property size: Vec2;
    property isPlayer: Bool;
    property speed: Float = PADDLE_SPEED;
    
    // Internal state
    var velocity = vec2(0, 0);
    
    start() {
        // Ensure paddle stays within bounds
        clampPosition();
    }
    
    update(deltaTime) {
        if (isPlayer) {
            handlePlayerInput();
        } else {
            handleAI();
        }
        
        // Apply movement
        this.position += velocity * deltaTime;
        clampPosition();
        
        // Reset velocity
        velocity = vec2(0, 0);
    }
    
    func handlePlayerInput() {
        if (Input.isKeyDown(Key.W) || Input.isKeyDown(Key.Up)) {
            velocity.y = -speed;
        }
        if (Input.isKeyDown(Key.S) || Input.isKeyDown(Key.Down)) {
            velocity.y = speed;
        }
    }
    
    func handleAI() {
        let ball = this.scene.getData<Ball>("ball");
        let ballY = ball.position.y;
        let paddleCenter = this.position.y;
        
        // Simple AI: follow ball with some delay
        let diff = ballY - paddleCenter;
        if (Math.abs(diff) > 10) {
            velocity.y = Math.sign(diff) * speed * 0.8;  // Slightly slower than player
        }
    }
    
    func clampPosition() {
        let halfHeight = size.y / 2;
        this.position.y = Math.clamp(
            this.position.y,
            halfHeight,
            SCREEN_HEIGHT - halfHeight
        );
    }
    
    render(renderer) {
        let rect = Rect(
            this.position.x - size.x / 2,
            this.position.y - size.y / 2,
            size.x,
            size.y
        );
        renderer.drawRect(rect, Color.white);
    }
    
    // Get the collision bounds
    func getBounds(): Rect {
        return Rect(
            this.position.x - size.x / 2,
            this.position.y - size.y / 2,
            size.x,
            size.y
        );
    }
}
```

### entities/Ball.jpp
```java+
import game.entity;
import game.graphics;
import game.audio;
import game.math;

entity Ball {
    property size: Vec2;
    property speed: Float = BALL_SPEED;
    
    var velocity = vec2(0, 0);
    var initialPosition: Vec2;
    
    start() {
        initialPosition = this.position;
        launch();
    }
    
    func launch() {
        // Random starting direction
        let direction = random() > 0.5 ? 1 : -1;
        let angle = random(-Math.PI / 4, Math.PI / 4);
        
        velocity = vec2(
            Math.cos(angle) * speed * direction,
            Math.sin(angle) * speed
        );
    }
    
    func reset() {
        this.position = initialPosition;
        launch();
    }
    
    update(deltaTime) {
        // Move ball
        this.position += velocity * deltaTime;
        
        // Wall collision (top/bottom)
        if (this.position.y - size.y / 2 <= 0 || 
            this.position.y + size.y / 2 >= SCREEN_HEIGHT) {
            velocity.y = -velocity.y;
            this.position.y = Math.clamp(
                this.position.y,
                size.y / 2,
                SCREEN_HEIGHT - size.y / 2
            );
        }
        
        // Check paddle collisions
        checkPaddleCollision();
        
        // Score detection
        if (this.position.x < 0) {
            onScore(false);  // AI scores
            reset();
        } else if (this.position.x > SCREEN_WIDTH) {
            onScore(true);   // Player scores
            reset();
        }
    }
    
    func checkPaddleCollision() {
        let ballRect = Rect(
            this.position.x - size.x / 2,
            this.position.y - size.y / 2,
            size.x,
            size.y
        );
        
        // Check player paddle
        let playerPaddle = this.scene.getData<Paddle>("playerPaddle");
        if (ballRect.intersects(playerPaddle.getBounds())) {
            bounceOffPaddle(playerPaddle);
        }
        
        // Check AI paddle
        let aiPaddle = this.scene.getData<Paddle>("aiPaddle");
        if (ballRect.intersects(aiPaddle.getBounds())) {
            bounceOffPaddle(aiPaddle);
        }
    }
    
    func bounceOffPaddle(paddle: Paddle) {
        // Calculate relative hit position
        let relativeY = (this.position.y - paddle.position.y) / (paddle.size.y / 2);
        
        // Calculate bounce angle (max 60 degrees)
        let bounceAngle = relativeY * (Math.PI / 3);
        
        // Increase speed slightly on each hit
        let newSpeed = velocity.magnitude() * 1.05;
        let maxSpeed = BALL_SPEED * 2;
        newSpeed = Math.min(newSpeed, maxSpeed);
        
        // Set new velocity
        let direction = paddle.isPlayer ? 1 : -1;
        velocity = vec2(
            Math.cos(bounceAngle) * newSpeed * direction,
            Math.sin(bounceAngle) * newSpeed
        );
        
        // Play sound
        Audio.play("assets/sounds/paddle_hit.wav", {
            pitch: 1.0 + random(-0.1, 0.1)
        });
        
        // Push ball out of paddle to prevent sticking
        if (paddle.isPlayer) {
            this.position.x = paddle.position.x + paddle.size.x / 2 + size.x / 2 + 1;
        } else {
            this.position.x = paddle.position.x - paddle.size.x / 2 - size.x / 2 - 1;
        }
    }
    
    render(renderer) {
        let rect = Rect(
            this.position.x - size.x / 2,
            this.position.y - size.y / 2,
            size.x,
            size.y
        );
        renderer.drawRect(rect, Color.white);
    }
}
```

### jpp.json
```json
{
  "name": "Pong",
  "version": "1.0.0",
  "description": "Classic Pong game in java+",
  "author": "Game Developer",
  
  "source": "src",
  "output": "build",
  "entry": "main.jpp",
  
  "window": {
    "width": 800,
    "height": 600,
    "title": "Pong",
    "resizable": false
  },
  
  "assets": {
    "path": "assets",
    "include": ["**/*.wav", "**/*.ttf"]
  },
  
  "build": {
    "target": "desktop",
    "optimize": "release"
  }
}
```

---

## Constraints Compliance Summary

| Constraint | Implementation |
|------------|----------------|
| **Learnable in < 2 weeks** | Simple syntax, minimal boilerplate, excellent documentation, interactive tutorials |
| **2D and 3D support** | Built-in 2D renderer + 3D pipeline, unified entity system |
| **Performance** | JIT compilation, SIMD, object pooling, generational GC with <1ms pauses |
| **Open-source** | MIT License, GitHub repository, community contributions welcome |
| **Package manager** | `jpp` CLI with dependency resolution, semantic versioning, registry at jpp.dev |

---

## Quick Reference Card

```java+
// Variables
let x = 5;              // immutable
var y = 10;             // mutable

// Functions
func add(a: Int, b: Int): Int => a + b;

// Classes
class Player {
    property health: Int = 100;
    func damage(amount: Int) { health -= amount; }
}

// Entities
entity Enemy {
    update(deltaTime) { /* ... */ }
}

// Vectors
let pos = vec2(100, 200);
let dir = (target - pos).normalized();

// Input
if (Input.isKeyDown(Key.Space)) { jump(); }

// Audio
Audio.play("sound.wav");

// Spawning
let enemy = scene.spawn("Enemy", { position: vec2(100, 100) });
```

---

*java+ - Game Development Made Simple*