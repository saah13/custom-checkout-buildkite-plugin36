# Custom Checkout Buildkite Plugin

A Buildkite plugin to specify a custom Git repository, branch, or commit to checkout in your pipeline steps, overriding the default repository configured in the pipeline settings.

## Example

Add the following to your `pipeline.yml`:

```yaml
steps:
  - label: "Build with Custom Repo"
    plugins:
      - buildkite-plugins/custom-checkout#v1.0.0:
          repository: "git@github.com:your-org/custom-repo.git"
          branch: "develop"
    command: "build.sh"
```

## Configuration

### `repository` (required, string)

The Git repository URL to clone.

### `branch` (optional, string)

The Git branch to checkout.

### `commit` (optional, string)

The Git commit SHA to checkout.

## Developing

To run the tests:

```shell
docker-compose run --rm tests
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

MIT (see [LICENSE](LICENSE))
