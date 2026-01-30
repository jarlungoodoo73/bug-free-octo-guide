# Patch for xpipe-webtop Dockerfile Multi-Architecture Support

## Reference
https://github.com/xpipe-io/xpipe-webtop/actions/runs/20578223451/job/59099982309

## Issue
The Docker build fails for arm64 architecture because it downloads the amd64 version of AWS Session Manager Plugin.

## Location
File: `Dockerfile` (line ~131-133 based on the error log)

## Original Code
```dockerfile
RUN echo "**** aws ssm ****" && curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "/tmp/session-manager-plugin.deb" && \
  sudo dpkg -i "/tmp/session-manager-plugin.deb" && \
  rm -rf "/tmp/aws" "/tmp/session-manager-plugin.deb"
```

## Fixed Code
```dockerfile
# Add ARG declaration near the top of the Dockerfile (if not already present)
ARG TARGETARCH

# Replace the RUN command at line ~131-133 with:
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

## Unified Diff Format
```diff
--- a/Dockerfile
+++ b/Dockerfile
@@ -1,6 +1,9 @@
 FROM ubuntu:22.04
 
+# Declare build argument for target architecture
+ARG TARGETARCH
+
 ...
 
-@@ -128,7 +131,17 @@
+@@ -128,7 +131,19 @@
     
-RUN echo "**** aws ssm ****" && curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "/tmp/session-manager-plugin.deb" && \
-  sudo dpkg -i "/tmp/session-manager-plugin.deb" && \
-  rm -rf "/tmp/aws" "/tmp/session-manager-plugin.deb"
+RUN echo "**** aws ssm ****" && \
+  if [ "$TARGETARCH" = "amd64" ]; then \
+    ARCH_SUFFIX="ubuntu_64bit"; \
+  elif [ "$TARGETARCH" = "arm64" ]; then \
+    ARCH_SUFFIX="ubuntu_arm64"; \
+  else \
+    echo "Unsupported architecture: $TARGETARCH"; \
+    exit 1; \
+  fi && \
+  curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/${ARCH_SUFFIX}/session-manager-plugin.deb" -o "/tmp/session-manager-plugin.deb" && \
+  sudo dpkg -i "/tmp/session-manager-plugin.deb" && \
+  rm -rf "/tmp/aws" "/tmp/session-manager-plugin.deb"
     
```

## Verification

After applying this fix, verify the build works for both architectures:

```bash
# Test amd64 build
docker buildx build --platform linux/amd64 -t xpipe-webtop:amd64-test .

# Test arm64 build
docker buildx build --platform linux/arm64 -t xpipe-webtop:arm64-test .

# Build for both
docker buildx build --platform linux/amd64,linux/arm64 -t xpipe-webtop:latest .
```

## Notes

1. The `ARG TARGETARCH` declaration should be placed after the `FROM` statement in the stage where it's used
2. If the Dockerfile has multiple stages, ARG needs to be declared in each stage that uses it
3. The AWS Session Manager Plugin URLs are:
   - amd64: `https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb`
   - arm64: `https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_arm64/session-manager-plugin.deb`

## Additional Considerations

If there are other architecture-specific downloads in the Dockerfile, they should also be updated using the same pattern. Common examples:
- AWS CLI
- Binary downloads
- Pre-compiled tools
- System packages with different names for different architectures

## Related Resources

- [AWS Session Manager Plugin Installation](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html)
- [Docker Multi-platform Builds](https://docs.docker.com/build/building/multi-platform/)
- [Docker ARG Documentation](https://docs.docker.com/engine/reference/builder/#arg)
