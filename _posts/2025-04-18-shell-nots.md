---
layout: post
title: "Using awk to Split a Text File in Bash"
date: 2025-04-18
categories: bash scripting awk
---

In this page, we'll explore how to use the `awk` command in a Bash script to split a text file into multiple smaller files based on specific criteria.

### The Script

Below is an example Bash script that uses `awk` to split a text file into separate files based on a delimiter or a pattern:

```bash
#!/bin/bash

# Check if the input file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"

# Ensure the input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: File '$input_file' not found!"
    exit 1
fi

# Split the file based on a pattern (e.g., "Section")
awk '/^Section/ { 
    if (out) close(out); 
    out = "output_" ++i ".txt" 
} 
{ print > out }' "$input_file"

echo "File has been split into multiple files named output_1.txt, output_2.txt, etc."
```

### How It Works

1. The script takes one argument: the path to the input file.
2. It uses `awk` to look for lines that match a specific pattern (e.g., lines starting with "Section").
3. When a match is found, it closes the current output file (if any) and opens a new one.
4. The content is written to the corresponding output file.

### Example Input File

```txt
Section 1
This is the first section.
Section 2
This is the second section.
Section 3
This is the third section.
```

### Output Files

- `output_1.txt`:
  ```txt
  Section 1
  This is the first section.
  ```

- `output_2.txt`:
  ```txt
  Section 2
  This is the second section.
  ```

- `output_3.txt`:
  ```txt
  Section 3
  This is the third section.
  ```

### Conclusion

Using `awk` in Bash scripts is a powerful way to process and manipulate text files. This script demonstrates how to split a file into smaller files based on a pattern, but you can adapt it to suit your specific needs.

Happy scripting!
```