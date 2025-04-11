# Project Generator

This script will create a minimal environment for using [umfeld](https://github.com/dennisppaul/umfeld).


## Prerequisites

- Set the environmental variable `UMFELD_ROOT` to point the root of the umfeld.

```bash
# if using bash
echo 'export UMFELD_ROOT=<YOUR_UMFELD_DIR>' >> ~/.bashrc

# if using zsh
echo 'export UMFELD_ROOT=<YOUR_UMFELD_DIR>' >> ~/.zshrc
```
Don't forget to replace the `<YOUR_UMFELD_DIR>` to the real path.

After that, change the file permission to be executable:
```bash
chmod +x projectGenerator.sh
```

## Usage

```bash
## Syntax:
##      projectGenerator.sh <project_path> [-vscode]

## example 1 (relative path)
projectGenerator.sh relative/path -vscode

## example 2 (absolute path)
projectGenerator.sh /absolute/path
```