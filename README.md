![](https://img.shields.io/github/commit-activity/t/subhamay-bhattacharyya-gha/github-action-template)&nbsp;![](https://img.shields.io/github/last-commit/subhamay-bhattacharyya-gha/github-action-template)&nbsp;![](https://img.shields.io/github/release-date/subhamay-bhattacharyya-gha/github-action-template)&nbsp;![](https://img.shields.io/github/repo-size/subhamay-bhattacharyya-gha/github-action-template)&nbsp;![](https://img.shields.io/github/directory-file-count/subhamay-bhattacharyya-gha/github-action-template)&nbsp;![](https://img.shields.io/github/issues/subhamay-bhattacharyya-gha/github-action-template)&nbsp;![](https://img.shields.io/github/languages/top/subhamay-bhattacharyya-gha/github-action-template)&nbsp;![](https://img.shields.io/github/commit-activity/m/subhamay-bhattacharyya-gha/github-action-template)&nbsp;![](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/bsubhamay/06e35985280456b113298ed56c626e73/raw/github-action-template.json?)

# GitHub Template Repository - Composite Action

A Template GitHub Repository to be used to create a composite action.

# Action Name

**Action Description**

This GitHub Action provides a reusable composite workflow that sets up Python and interacts with the GitHub API to post a comment on an issue, including a link to a created branch.

---

## Inputs

| Name           | Description         | Required | Default        |
|----------------|---------------------|----------|----------------|
| `input-1`      | Input description.  | No       | `default-value`|
| `input-2`      | Input description.  | No       | `default-value`|
| `input-3`      | Input description.  | No       | `default-value`|
| `github-token` | GitHub token. Used for API authentication. | Yes | — |

---

## Example Usage

```yaml
name: Example Workflow

on:
  issues:
    types: [opened]

jobs:
  example:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Run Custom Action
        uses: your-org/your-action-repo@v1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          input-1: your-value
          input-2: another-value
          input-3: something-else
```

## License

MIT