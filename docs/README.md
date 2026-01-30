This folder is used for documentation related to developing `gh`. Docs for `gh` installation and usage are available at [https://cli.github.com/manual](https://cli.github.com/manual).

## Additional Documentation

### Docker Multi-Architecture Build Fix

Documentation and examples for fixing multi-architecture Docker build issues:

- **[DOCKER_MULTI_ARCH_SUMMARY.md](DOCKER_MULTI_ARCH_SUMMARY.md)** - Overview and quick links
- **[docker-multi-arch-fix.md](docker-multi-arch-fix.md)** - Comprehensive guide to the fix
- **[examples/](examples/)** - Working examples and test scripts
  - [Dockerfile.multi-arch](examples/Dockerfile.multi-arch) - Example Dockerfile
  - [test-multi-arch.sh](examples/test-multi-arch.sh) - Test script
  - [xpipe-webtop-fix.md](examples/xpipe-webtop-fix.md) - Specific patch for xpipe-webtop
  - [README.md](examples/README.md) - Quick start guide

Reference: [xpipe-webtop workflow failure](https://github.com/xpipe-io/xpipe-webtop/actions/runs/20578223451/job/59099982309)