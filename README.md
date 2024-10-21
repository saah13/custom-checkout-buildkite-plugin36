# Buildkite Plugin: Custom Checkout

This plugin allows you to specify a custom Git repository, branch, or commit to checkout in your Buildkite pipeline steps, overriding the default repository configured in the pipeline settings.

## Configuration

- `repository` (string, required): The Git repository URL to clone.
- `branch` (string, optional): The Git branch to checkout.
- `commit` (string, optional): The Git commit SHA to checkout.

## Example

```yaml
steps:
  - label: "Build with Custom Repo"
    plugins:
      - your-username/custom-checkout#v1.0.0:
          repository: "git@github.com:your-org/custom-repo.git"
          branch: "develop"
    command: "build.sh"
```

## Development

To run the tests:

```bash
bats tests/pre-checkout.bats
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

MIT (see [LICENSE](LICENSE))
