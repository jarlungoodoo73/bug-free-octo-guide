# Docker Multi-Architecture Build Examples

This directory contains examples and documentation for fixing multi-architecture Docker build issues.

## Problem Reference

Based on the issue found in: https://github.com/xpipe-io/xpipe-webtop/actions/runs/20578223451/job/59099982309

## Files

- **Dockerfile.multi-arch** - Example Dockerfile demonstrating proper multi-architecture support
- **test-multi-arch.sh** - Script to test multi-architecture builds
- **../docker-multi-arch-fix.md** - Comprehensive documentation on the fix

## Quick Start

### Prerequisites

- Docker with buildx support
- Basic understanding of Docker multi-platform builds

### Testing the Example

1. Navigate to this directory:
   ```bash
   cd docs/examples
   ```

2. Run the test script:
   ```bash
   ./test-multi-arch.sh
   ```

3. Or manually build for specific architecture:
   ```bash
   # Build for amd64
   docker buildx build --platform linux/amd64 -t test:amd64 -f Dockerfile.multi-arch .
   
   # Build for arm64
   docker buildx build --platform linux/arm64 -t test:arm64 -f Dockerfile.multi-arch .
   
   # Build for both
   docker buildx build --platform linux/amd64,linux/arm64 -t test:multi -f Dockerfile.multi-arch .
   ```

## The Problem

When building Docker images for multiple architectures (e.g., amd64 and arm64), hardcoded URLs for architecture-specific packages cause build failures.

**Example of the problem:**
```dockerfile
# This FAILS for arm64 builds
RUN curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "/tmp/session-manager-plugin.deb"
```

**Error message:**
```
dpkg: error processing archive /tmp/session-manager-plugin.deb (--install):
 package architecture (amd64) does not match system (arm64)
```

## The Solution

Use Docker's built-in `TARGETARCH` or `TARGETPLATFORM` build arguments to dynamically select the correct package:

```dockerfile
ARG TARGETARCH

RUN if [ "$TARGETARCH" = "amd64" ]; then \
        ARCH_SUFFIX="ubuntu_64bit"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        ARCH_SUFFIX="ubuntu_arm64"; \
    fi && \
    curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/${ARCH_SUFFIX}/session-manager-plugin.deb" -o "/tmp/session-manager-plugin.deb"
```

## Key Concepts

### Docker Build Arguments

Docker automatically provides these build arguments when using `--platform`:

- `TARGETARCH` - Target architecture (e.g., `amd64`, `arm64`)
- `TARGETPLATFORM` - Full platform string (e.g., `linux/amd64`, `linux/arm64`)
- `TARGETOS` - Target operating system (e.g., `linux`, `windows`)
- `TARGETVARIANT` - Architecture variant (e.g., `v7` for arm/v7)

### Architecture Mappings

Common architecture naming conventions:

| TARGETARCH | Common Names | Package Suffix Examples |
|------------|-------------|------------------------|
| amd64      | x86_64, x64 | ubuntu_64bit, x86_64   |
| arm64      | aarch64     | ubuntu_arm64, aarch64  |
| arm        | armv7       | ubuntu_armhf, armv7    |

## Best Practices

1. **Always declare ARG before using it:**
   ```dockerfile
   ARG TARGETARCH
   RUN echo "Building for ${TARGETARCH}"
   ```

2. **Provide fallback for unsupported architectures:**
   ```dockerfile
   RUN if [ "$TARGETARCH" = "amd64" ]; then \
           ARCH="amd64"; \
       elif [ "$TARGETARCH" = "arm64" ]; then \
           ARCH="arm64"; \
       else \
           echo "Unsupported architecture: $TARGETARCH"; \
           exit 1; \
       fi
   ```

3. **Test all target architectures before releasing:**
   ```bash
   docker buildx build --platform linux/amd64,linux/arm64 -t myimage:latest .
   ```

4. **Document supported architectures in your README**

5. **Use specific architecture tags when pushing:**
   ```bash
   docker buildx build --platform linux/amd64,linux/arm64 \
       -t myorg/myimage:latest \
       -t myorg/myimage:1.0.0 \
       --push .
   ```

## Common Pitfalls

1. **Forgetting to declare ARG:**
   - ARG must be declared in each stage of multi-stage builds
   - ARG declared before FROM is in global scope

2. **Hardcoding architecture-specific values:**
   - URLs, package names, binary names
   - Always use conditional logic based on TARGETARCH

3. **Not testing on actual hardware:**
   - QEMU emulation may hide issues
   - Test on real ARM hardware when possible

4. **Ignoring TARGETVARIANT:**
   - Important for ARM (v6, v7, v8)
   - May need additional conditionals

## Resources

- [Docker Buildx Documentation](https://docs.docker.com/buildx/working-with-buildx/)
- [Multi-platform builds](https://docs.docker.com/build/building/multi-platform/)
- [Docker ARG reference](https://docs.docker.com/engine/reference/builder/#arg)
- [AWS Session Manager Plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html)

## Related Documentation

See [../docker-multi-arch-fix.md](../docker-multi-arch-fix.md) for more detailed information and alternative solutions.
