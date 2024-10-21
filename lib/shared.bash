#!/bin/bash

parse_plugin_config() {
  # Parse repository
  if [[ -n "${BUILDKITE_PLUGIN_CUSTOM_CHECKOUT_REPOSITORY:-}" ]]; then
    if [[ ! "${BUILDKITE_PLUGIN_CUSTOM_CHECKOUT_REPOSITORY}" =~ ^(https?|git|ssh):// ]]; then
      echo "Error: Invalid repository URL format" >&2
      exit 1
    fi
  fi

  # Parse branch (optional)
  if [[ -n "${BUILDKITE_PLUGIN_CUSTOM_CHECKOUT_BRANCH:-}" ]]; then
    if [[ ! "${BUILDKITE_PLUGIN_CUSTOM_CHECKOUT_BRANCH}" =~ ^[a-zA-Z0-9_.-]+$ ]]; then
      echo "Error: Invalid branch name format" >&2
      exit 1
    fi
  fi

  # Parse commit (optional)
  if [[ -n "${BUILDKITE_PLUGIN_CUSTOM_CHECKOUT_COMMIT:-}" ]]; then
    if [[ ! "${BUILDKITE_PLUGIN_CUSTOM_CHECKOUT_COMMIT}" =~ ^[a-fA-F0-9]{40}$ ]]; then
      echo "Error: Invalid commit SHA format" >&2
      exit 1
    fi
  fi
}
