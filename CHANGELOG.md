# 🔖 1.3.0 (2025-02-05)

## Docker Image

```bash
# Latest version
docker pull ghcr.io/imamik/consistent-character:1.3.0

# Or use latest tag
docker pull ghcr.io/imamik/consistent-character:latest
```

## Changes

### 🚀 Features

* Add InvokeAI to Docker image and startup scripts ([834e93d](https://github.com/imamik/consistent-character/commit/834e93d1f04276803cb07f9a12bed44f80d4debf))

### 🐛 Bug Fixes

* remove unnecessary system libraries from Dockerfile ([f690f05](https://github.com/imamik/consistent-character/commit/f690f05eaa58636881c0004218d9e73260ad6bb5))

### 🔧 Maintenance

* Simplify Dockerfile installation steps for Filebrowser and uv ([cba1532](https://github.com/imamik/consistent-character/commit/cba1532a18a386d9df61c76f2d3a70488466bae2))

# 🔖 1.2.0 (2025-02-04)

## Docker Image

```bash
# Latest version
docker pull ghcr.io/imamik/consistent-character:1.2.0

# Or use latest tag
docker pull ghcr.io/imamik/consistent-character:latest
```

## Changes

### 🚀 Features

* download ClearReality upscale models instead of embedding ([54d0439](https://github.com/imamik/consistent-character/commit/54d043928f0589f206c4f458d3aecbd2534e7bc8))

### 📚 Documentation

* Update README with Jupyter Notebook and model volume mount instructions ([191c680](https://github.com/imamik/consistent-character/commit/191c680128284b5ff1e484a8308b31ac3690e331))

### ♻️ Refactor

* add input directory support for ComfyUI and Dockerfile ([9588c23](https://github.com/imamik/consistent-character/commit/9588c234e6e17a0df03e045539c060dee32cdeb2))

# 🔖 1.1.0 (2025-02-04)

## Docker Image

```bash
# Latest version
docker pull ghcr.io/imamik/consistent-character:1.1.0

# Or use latest tag
docker pull ghcr.io/imamik/consistent-character:latest
```

## Changes

### 🚀 Features

* Add Jupyter Notebook support to Docker image and startup scripts ([eeb52e4](https://github.com/imamik/consistent-character/commit/eeb52e41f62ee77413f4378ae22ac673a8453e45))

### 🐛 Bug Fixes

* update CUDA and PyTorch versions to 12.1.0 to increase compatibility ([dc2e07f](https://github.com/imamik/consistent-character/commit/dc2e07f6a5684cba882e60a794f6adf9235a934f))

# 🔖 1.0.1 (2025-02-04)

## Docker Image

```bash
# Latest version
docker pull ghcr.io/imamik/consistent-character:1.0.1

# Or use latest tag
docker pull ghcr.io/imamik/consistent-character:latest
```

## Changes

### 🐛 Bug Fixes

* remove deprecated Jupyter startup from start script (made startup crash) ([aa9f11f](https://github.com/imamik/consistent-character/commit/aa9f11ff1f589ff465d7d15ed225cbca03cd7e8a))

### ♻️ Refactor

* GitHub Actions workflow to separate version determination and release creation ([953162f](https://github.com/imamik/consistent-character/commit/953162fc27f3d4f6cfeb09232aa1d77406ebca8d))

# 🔖 1.0.0 (2025-02-03)

## Docker Image

```bash
# Latest version
docker pull ghcr.io/imamik/consistent-character:1.0.0

# Or use latest tag
docker pull ghcr.io/imamik/consistent-character:latest
```

## Changes

### 🚀 Features

* Add welcome message and text formatting functions to start script ([828ec9b](https://github.com/imamik/consistent-character/commit/828ec9bc89afd5345c3a04cdffae2a843594c63e))

### ♻️ Refactor

* Remove unused workflow, snapshot, and Jupyter startup script ([b8797c9](https://github.com/imamik/consistent-character/commit/b8797c9ca55d1174e1027dc6ebec5dc84d3e5579))
