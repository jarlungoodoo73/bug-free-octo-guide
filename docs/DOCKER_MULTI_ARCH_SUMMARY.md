# Multi-Architecture Docker Build Fix - Summary

## Overview

This documentation provides a comprehensive solution for the multi-architecture Docker build issue identified in the xpipe-io/xpipe-webtop repository.

**Issue Reference:** https://github.com/xpipe-io/xpipe-webtop/actions/runs/20578223451/job/59099982309

## Problem

The Docker build for `linux/arm64` architecture fails with:
```
dpkg: error processing archive /tmp/session-manager-plugin.deb (--install):
 package architecture (amd64) does not match system (arm64)
```

This occurs because the Dockerfile hardcodes the amd64 package URL instead of selecting the appropriate package based on the target architecture.

## Solution

Use Docker's `TARGETARCH` build argument to dynamically select architecture-specific packages:

```dockerfile
ARG TARGETARCH

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      ARCH_SUFFIX="ubuntu_64bit"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      ARCH_SUFFIX="ubuntu_arm64"; \
    fi && \
    curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/${ARCH_SUFFIX}/session-manager-plugin.deb" -o "/tmp/session-manager-plugin.deb" && \
    dpkg -i "/tmp/session-manager-plugin.deb"
```

## Documentation Structure

```
docs/
├── docker-multi-arch-fix.md          # Main documentation
└── examples/
    ├── README.md                     # Quick start guide
    ├── Dockerfile.multi-arch         # Working example
    ├── test-multi-arch.sh            # Test script
    └── xpipe-webtop-fix.md          # Specific patch for xpipe-webtop
```

## Quick Links

- **Main Documentation:** [docker-multi-arch-fix.md](docker-multi-arch-fix.md)
- **Example Dockerfile:** [examples/Dockerfile.multi-arch](examples/Dockerfile.multi-arch)
- **Quick Start Guide:** [examples/README.md](examples/README.md)
- **Specific Fix:** [examples/xpipe-webtop-fix.md](examples/xpipe-webtop-fix.md)

## Key Concepts

### Docker Build Arguments

Docker automatically provides these when using `--platform`:
- `TARGETARCH` - Architecture (amd64, arm64, etc.)
- `TARGETPLATFORM` - Full platform string (linux/amd64, linux/arm64)
- `TARGETOS` - Operating system (linux, windows)

### Common Architecture Mappings

| Docker TARGETARCH | Package Suffix | Alternative Names |
|------------------|----------------|-------------------|
| amd64            | ubuntu_64bit   | x86_64, x64      |
| arm64            | ubuntu_arm64   | aarch64          |
| arm              | ubuntu_armhf   | armv7            |

## Testing

Build for specific architecture:
```bash
docker buildx build --platform linux/amd64 -t test:amd64 .
docker buildx build --platform linux/arm64 -t test:arm64 .
```

Build for multiple architectures:
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t test:multi .
```

## Applying the Fix

### For xpipe-webtop Repository

1. Add `ARG TARGETARCH` after the `FROM` statement
2. Replace the hardcoded session-manager-plugin installation with the conditional logic
3. Test both architectures
4. Commit and push

See [examples/xpipe-webtop-fix.md](examples/xpipe-webtop-fix.md) for detailed patch instructions.

### For Other Projects

1. Identify all architecture-specific downloads
2. Replace hardcoded URLs with conditional logic using `TARGETARCH`
3. Add error handling for unsupported architectures
4. Test all target platforms
5. Document supported architectures

## Best Practices

1. ✅ Always use `TARGETARCH` for architecture-specific logic
2. ✅ Provide clear error messages for unsupported architectures
3. ✅ Test all target architectures before releasing
4. ✅ Document which architectures are supported
5. ✅ Use architecture-agnostic solutions when possible

## Common Mistakes to Avoid

1. ❌ Hardcoding architecture-specific URLs
2. ❌ Forgetting to declare `ARG TARGETARCH`
3. ❌ Not testing on actual ARM hardware
4. ❌ Assuming emulation catches all issues
5. ❌ Missing error handling for unsupported architectures

## Resources

- [Docker Multi-platform Documentation](https://docs.docker.com/build/building/multi-platform/)
- [Docker ARG Reference](https://docs.docker.com/engine/reference/builder/#arg)
- [AWS Session Manager Plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html)

## Support

For questions or issues with this documentation:
1. Review the [main documentation](docker-multi-arch-fix.md)
2. Check the [examples](examples/)
3. Open an issue in the repository

## Version History

- **v1.0** - Initial documentation covering AWS Session Manager Plugin multi-arch fix
  - Main documentation
  - Example Dockerfile
  - Test script
  - Specific patch for xpipe-webtop

## License

This documentation is provided as-is for educational purposes. Use at your own discretion.
