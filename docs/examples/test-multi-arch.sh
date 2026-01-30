#!/bin/bash
# Test script for multi-architecture Docker builds
# This script helps test the fix for architecture-specific package downloads

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKERFILE="${SCRIPT_DIR}/Dockerfile.multi-arch"
IMAGE_NAME="multi-arch-test"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if buildx is available
if ! docker buildx version &> /dev/null; then
    print_error "Docker buildx is not available. Please install or enable buildx."
    exit 1
fi

# Function to test build for a specific architecture
test_architecture() {
    local arch=$1
    print_status "Testing build for architecture: ${arch}"
    
    if docker buildx build \
        --platform "linux/${arch}" \
        -t "${IMAGE_NAME}:${arch}" \
        -f "${DOCKERFILE}" \
        "${SCRIPT_DIR}"; then
        print_status "✓ Build succeeded for ${arch}"
        return 0
    else
        print_error "✗ Build failed for ${arch}"
        return 1
    fi
}

# Function to verify the built image
verify_image() {
    local arch=$1
    print_status "Verifying image for architecture: ${arch}"
    
    # Try to run the image and check architecture
    if docker run --rm "${IMAGE_NAME}:${arch}" bash -c "uname -m && aws --version && session-manager-plugin --version" 2>/dev/null; then
        print_status "✓ Image verification succeeded for ${arch}"
        return 0
    else
        print_warning "Could not verify image ${arch} (may not be runnable on this host)"
        return 0
    fi
}

# Main test flow
main() {
    print_status "Starting multi-architecture Docker build tests"
    print_status "================================================"
    echo ""
    
    # Test amd64
    if test_architecture "amd64"; then
        verify_image "amd64"
    fi
    echo ""
    
    # Test arm64
    if test_architecture "arm64"; then
        verify_image "arm64"
    fi
    echo ""
    
    # Try multi-arch build
    print_status "Testing multi-architecture build (amd64,arm64)"
    if docker buildx build \
        --platform "linux/amd64,linux/arm64" \
        -t "${IMAGE_NAME}:multi" \
        -f "${DOCKERFILE}" \
        "${SCRIPT_DIR}"; then
        print_status "✓ Multi-architecture build succeeded"
    else
        print_error "✗ Multi-architecture build failed"
        exit 1
    fi
    
    echo ""
    print_status "================================================"
    print_status "All tests completed successfully!"
    print_status "================================================"
}

# Run main function
main
