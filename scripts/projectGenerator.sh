#!/bin/bash

# check for minimum arguments
if [ $# -lt 1 ]; then
    echo "Usage: $0 <project_path> [-vscode]"
    exit 1
fi

# check UMFELD_ROOT exists
if [ -z "$UMFELD_ROOT" ]; then
    echo "Error: UMFELD_ROOT environment variable not set"
    exit 1
    else
    # print UMFELD_ROOT is used
    echo "Using UMFELD_ROOT: $UMFELD_ROOT"
fi

# get absolute project path
if [[ "$1" = /* ]]; then
    project_path="$1"
else
    project_path="$(pwd)/$1"
fi

# make project directory
mkdir -p "$project_path" || exit 1

# Get project name from path
project_name=$(basename "$project_path")

# copy CMakeLists.txt template
cmake_template="$UMFELD_ROOT/templates/cmakelists.project"
if [ ! -f "$cmake_template" ]; then
    echo "Error: CMake template not found at $cmake_template"
    exit 1
fi
cp "$cmake_template" "$project_path/CMakeLists.txt"

# copy and rename empty cpp template
cpp_template="$UMFELD_ROOT/templates/emptyProject.cpp"
if [ ! -f "$cpp_template" ]; then
    echo "Error: CPP template not found at $cpp_template"
    exit 1
fi
cp "$cpp_template" "$project_path/${project_name}.cpp"

# optionally, handle VSCode workspace
if [ "$2" == "-vscode" ]; then
    vscode_template="$UMFELD_ROOT/templates/vscode/template.code-workspace"
    if [ ! -f "$vscode_template" ]; then
        echo "Error: VSCode template not found at $vscode_template"
        exit 1
    fi
    
    # create modified workspace file
    workspace_file="$project_path/${project_name}.code-workspace"
    sed \
        -e "s|\"path\": \"\"|\"path\": \"$UMFELD_ROOT\"|" \
        -e "s|\"name\": \"\"|\"name\": \"umfeld\"|" \
        -e "/\"path\": \".\"/{n;s/\"name\": \"\"/\"name\": \"$project_name\"/}" \
        "$vscode_template" > "$workspace_file"
    
    echo "Created VSCode workspace: $workspace_file"

    # prompt to open in VS Code
    read -p "Open project in VS Code? [Y/n] " answer
    case "$answer" in
        [Yy]*|"")
            echo "Launching VS Code..."
            code "$workspace_file"
            ;;
        *)
            echo "Skipping VS Code launch"
            ;;
    esac
fi

echo "Project created successfully at: $project_path"
