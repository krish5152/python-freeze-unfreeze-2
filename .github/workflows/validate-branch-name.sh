name: Branch Name Validator

on:
  pull_request:
    types: [opened, synchronize, reopened]
  push:
    branches:
      - "**" # You can change this to trigger only on certain branches if necessary

jobs:
  validate-branch-name:
    runs-on: ubuntu-latest

    steps:
      - name: Check out repository
        uses: actions/checkout@v3
      - name: Set script permission
        run: chmod +x .github/scripts/validate-branch-name.sh
      - name: Validate branch name
        run: |
          branch_name=${{ github.ref_name }}
          echo "Validating branch name: $branch_name"
          
          # Define the regex for valid branch names
          if [[ ! "$branch_name" =~ ^(feature|bugfix|release|hotfix)/[a-zA-Z0-9._-]+$ ]]; then
            echo "Invalid branch name: $branch_name"
            echo "Branch name must match the pattern: feature/*, bugfix/*, release/*, hotfix/*"
            exit 1
          fi

      - name: Branch name validation passed
        run: echo "Branch name validation passed for ${{ github.ref_name }}!"
