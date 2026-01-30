# Fix for Multi-Architecture Docker Build Issue

## Problem Statement

Reference: https://github.com/xpipe-io/xpipe-webtop/actions/runs/20578223451/job/59099982309

The Docker build fails when building for `linux/arm64` architecture because the Dockerfile downloads the amd64 version of AWS Session Manager Plugin instead of the architecture-appropriate version.

### Error Message
```
dpkg: error processing archive /tmp/session-manager-plugin.deb (--install):
 package architecture (amd64) does not match system (arm64)
```

## Root Cause

The Dockerfile hardcodes the `ubuntu_64bit` (amd64) package URL:
```dockerfile
RUN curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "/tmp/session-manager-plugin.deb"
```

This URL is correct for amd64 but fails for arm64 builds.

## Solution

Use Docker's `TARGETARCH` build argument to dynamically select the correct package based on the target architecture.

### Fixed Dockerfile Code

```dockerfile
# Use build arguments to get target architecture
ARG TARGETARCH

# Install AWS Session Manager Plugin with architecture detection
RUN echo "**** aws ssm ****" && \
  if [ "$TARGETARCH" = "amd64" ]; then \
    ARCH_SUFFIX="ubuntu_64bit"; \
  elif [ "$TARGETARCH" = "arm64" ]; then \
    ARCH_SUFFIX="ubuntu_arm64"; \
  else \
    echo "Unsupported architecture: $TARGETARCH"; \
    exit 1; \
  fi && \
  curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/${ARCH_SUFFIX}/session-manager-plugin.deb" -o "/tmp/session-manager-plugin.deb" && \
  sudo dpkg -i "/tmp/session-manager-plugin.deb" && \
  rm -rf "/tmp/aws" "/tmp/session-manager-plugin.deb"
```

## Explanation

1. **TARGETARCH Variable**: Docker automatically provides `TARGETARCH` when building with `--platform` flag
2. **Architecture Mapping**: 
   - `amd64` → `ubuntu_64bit`
   - `arm64` → `ubuntu_arm64`
3. **Dynamic URL Construction**: Uses the mapped architecture suffix in the download URL
4. **Error Handling**: Exits with error for unsupported architectures

## Alternative Solutions

### Option 1: Using TARGETPLATFORM

```dockerfile
ARG TARGETPLATFORM

RUN echo "**** aws ssm ****" && \
  case "$TARGETPLATFORM" in \
    "linux/amd64") ARCH_SUFFIX="ubuntu_64bit" ;; \
    "linux/arm64") ARCH_SUFFIX="ubuntu_arm64" ;; \
    *) echo "Unsupported platform: $TARGETPLATFORM"; exit 1 ;; \
  esac && \
  curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/${ARCH_SUFFIX}/session-manager-plugin.deb" -o "/tmp/session-manager-plugin.deb" && \
  sudo dpkg -i "/tmp/session-manager-plugin.deb" && \
  rm -rf "/tmp/aws" "/tmp/session-manager-plugin.deb"
```

### Option 2: Using dpkg --print-architecture

```dockerfile
RUN echo "**** aws ssm ****" && \
  ARCH=$(dpkg --print-architecture) && \
  if [ "$ARCH" = "amd64" ]; then \
    ARCH_SUFFIX="ubuntu_64bit"; \
  elif [ "$ARCH" = "arm64" ]; then \
    ARCH_SUFFIX="ubuntu_arm64"; \
  else \
    echo "Unsupported architecture: $ARCH"; \
    exit 1; \
  fi && \
  curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/${ARCH_SUFFIX}/session-manager-plugin.deb" -o "/tmp/session-manager-plugin.deb" && \
  sudo dpkg -i "/tmp/session-manager-plugin.deb" && \
  rm -rf "/tmp/aws" "/tmp/session-manager-plugin.deb"
```

## Building Multi-Architecture Images

When building the image, use Docker buildx:

```bash
# Build for multiple platforms
docker buildx build --platform linux/amd64,linux/arm64 -t myimage:latest .

# Or build and push
docker buildx build --platform linux/amd64,linux/arm64 -t myimage:latest --push .
```

## Testing

### Test amd64 build:
```bash
docker buildx build --platform linux/amd64 -t test:amd64 .
```

### Test arm64 build:
```bash
docker buildx build --platform linux/arm64 -t test:arm64 .
```

### Verify installation:
```bash
# For amd64
docker run --rm test:amd64 session-manager-plugin --version

# For arm64
docker run --rm test:arm64 session-manager-plugin --version
```

## Best Practices

1. **Always use TARGETARCH/TARGETPLATFORM** for multi-arch builds
2. **Test both architectures** before merging
3. **Document supported architectures** in README
4. **Use explicit platform flags** in CI/CD workflows
5. **Add architecture validation** for unsupported platforms

## Related Resources

- [Docker Buildx Documentation](https://docs.docker.com/buildx/working-with-buildx/)
- [Multi-platform images](https://docs.docker.com/build/building/multi-platform/)
- [AWS Session Manager Plugin Downloads](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html)
