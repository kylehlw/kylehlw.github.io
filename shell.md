---
layout: page
title: "Shell Scripting"
permalink: /shell
---

# Shell Scripting Guide

Welcome to the shell scripting guide! This page provides an overview of shell scripting concepts, commands, and examples.

## Table of Contents
1. [Introduction](#introduction)
2. [Basic Commands](#basic-commands)
3. [Writing Scripts](#writing-scripts)
4. [Examples](#examples)
5. [Resources](#resources)

## Introduction
Shell scripting is a powerful way to automate tasks in Unix/Linux environments. It allows you to execute a series of commands in a script file.

## Basic Commands
Here are some commonly used shell commands:
- `ls` - List directory contents
- `cd` - Change directory
- `echo` - Print text to the terminal
- `cat` - Display file contents

## Writing Scripts
To write a shell script:
1. Create a file with a `.sh` extension.
2. Add the shebang line: `#!/bin/bash`.
3. Write your commands in the file.
4. Make the script executable: `chmod +x script.sh`.
5. Run the script: `./script.sh`.

## Examples
### Hello World Script
```bash
#!/bin/bash
echo "Hello, World!"
```

### Loop Example
```bash
#!/bin/bash
for i in {1..5}; do
    echo "Number $i"
done
```

## Resources
- [Bash Scripting Tutorial](https://www.shellscript.sh)
- [GNU Bash Manual](https://www.gnu.org/software/bash/manual/)

Happy scripting!
```