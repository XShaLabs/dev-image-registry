# Dev Environment Image Registry

This repository contains an automated Docker image building and publishing system that uses GitHub Actions to read the list of images to be built from a `registry.json` file.

## Workflow

### 1. Image Registration

Add image information to be built in the `registry.json` file:

```json
{
  "waiting": [
    {
      "name": "claude-code",
      "tag": "node-18-claude-code-1.0.67",
      "file": "claude-code/Dockerfile.node18_1_0_67"
    },
    {
      "name": "claude-code",
      "tag": "node-20-claude-code-1.0.67",
      "file": "claude-code/Dockerfile.node20_1_0_67"
    }
  ],
  "completed": []
}
```

Fields:

- `name`: The base name of the image
- `tag`: The specific tag of the image
- `file`: The path to the Dockerfile

### 2. Automatic Build

When code is pushed to the main/master branch, GitHub Actions will:

- Read the `waiting` array from `registry.json`
- Build all images in parallel
- Push to GitHub Container Registry (GHCR)
- Move the project from `waiting` to `completed` after successful build

### 3. Image Tags

Each image will automatically generate the following tags:

- `<tag>` (The primary tag defined in `registry.json`)
- `<branch-name>-<tag>` (Branch name - tag)
- `<branch-name>-<tag>-<commit-sha>` (Branch name - tag - commit hash)
- `latest-<tag>` (Only on the default branch)

## Usage

### Add a New Image

1. Prepare the Dockerfile
2. Add image information to the `waiting` array in `registry.json`:
   ```json
   {
     "name": "your-image-name",
     "tag": "your-custom-tag",
     "file": "path/to/Dockerfile"
   }
   ```
3. Commit and push to the repository
4. GitHub Actions will automatically build and push the image

### Manually Trigger a Build

You can manually trigger the workflow execution in the GitHub Actions page.

### Access the Image

After the build is complete, the image will be pushed to:

```
ghcr.io/XShaLabs/dev-image-registry/<image-name>:<tag>
```

For example:

```bash
# Pull the primary tag
docker pull ghcr.io/XShaLabs/dev-image-registry/claude-code:node-18-claude-code-1.0.67

# Pull the latest tag (only on the main branch)
docker pull ghcr.io/XShaLabs/dev-image-registry/claude-code:latest-node-18-claude-code-1.0.67
```

## Permissions

Ensure the repository settings have the following permissions enabled:

- `Actions` -> `General` -> `Workflow permissions` -> `Read and write permissions`
- `Settings` -> `Packages` -> Allow GitHub Actions to access packages

## File Structure

```
.
├── .github/workflows/build-images.yml  # GitHub Actions workflow
├── registry.json                       # Image registry
├── claude-code/                        # Image folder
│   ├── Dockerfile.node18_1_0_67        # Node.js 18 Dockerfile
│   └── Dockerfile.node20_1_0_67        # Node.js 20 Dockerfile
└── README.md                           # README
```

## Environment Variables

You can customize the following environment variables in the workflow:

- `REGISTRY`: Image registry address (default: ghcr.io)
- `IMAGE_NAME`: Image name prefix (default: repository name)
