#!/bin/bash

# Set strict bash options
set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to log messages
plugin_log() {
  echo -e "${GREEN}~~~ ${1}${NC}"
}

# Function to log errors
plugin_error() {
  echo -e "${RED}🚨 Error: ${1}${NC}" >&2
  exit 1
}

# Function to parse plugin configuration
parse_plugin_config() {
  CUSTOM_REPO="${BUILDKITE_PLUGIN_CUSTOM_CHECKOUT_REPOSITORY:-}"
  CUSTOM_BRANCH="${BUILDKITE_PLUGIN_CUSTOM_CHECKOUT_BRANCH:-}"
  CUSTOM_COMMIT="${BUILDKITE_PLUGIN_CUSTOM_CHECKOUT_COMMIT:-}"
  CUSTOM_PATH="${BUILDKITE_PLUGIN_CUSTOM_CHECKOUT_PATH:-$BUILDKITE_BUILD_CHECKOUT_PATH}"

  # Use default values only if custom values are not set
  if [ -z "$CUSTOM_REPO" ]; then
    CUSTOM_REPO="$BUILDKITE_REPO"
  fi
  if [ -z "$CUSTOM_BRANCH" ] && [ -z "$CUSTOM_COMMIT" ]; then
    CUSTOM_BRANCH="$BUILDKITE_BRANCH"
  fi
}

# Function to perform git operations
git_checkout() {
  if [ -d ".git" ]; then
    plugin_log "Updating existing repository"
    git remote set-url origin "$CUSTOM_REPO" || plugin_error "Failed to set remote URL"
    git fetch origin || plugin_error "Failed to fetch from remote"
  else
    plugin_log "Cloning repository"
    git clone "$CUSTOM_REPO" . || plugin_error "Failed to clone repository"
  fi

  if [ -n "$CUSTOM_BRANCH" ]; then
    plugin_log "Checking out branch: $CUSTOM_BRANCH"
    git checkout -B "$CUSTOM_BRANCH" "origin/$CUSTOM_BRANCH" || plugin_error "Failed to checkout branch"
  elif [ -n "$CUSTOM_COMMIT" ]; then
    plugin_log "Checking out commit: $CUSTOM_COMMIT"
    git checkout "$CUSTOM_COMMIT" || plugin_error "Failed to checkout commit"
  fi
}

# Function to set Buildkite environment variables
set_buildkite_env() {
  CURRENT_COMMIT=$(git rev-parse HEAD)
  export BUILDKITE_REPO="$CUSTOM_REPO"
  export BUILDKITE_REFSPEC="$CUSTOM_BRANCH"
  export BUILDKITE_COMMIT="$CURRENT_COMMIT"
  export BUILDKITE_BUILD_CHECKOUT_PATH="$CUSTOM_PATH"
}

# Function to print checkout information
print_checkout_info() {
  plugin_log "Custom checkout completed successfully"
  plugin_log "Current commit: $(git rev-parse HEAD)"
  plugin_log "Commit message: $(git log -1 --pretty=%B)"
  plugin_log "Commit author: $(git log -1 --pretty=%an)"
  plugin_log "Commit date: $(git log -1 --pretty=%ad)"
}
