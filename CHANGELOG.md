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
