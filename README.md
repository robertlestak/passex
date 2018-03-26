# passex

Simple export script for UNIX `pass`.

## Configuration

Use the `passex.sh` file as a standalone script, or `source` the path to the file in your `.bashrc`/`.zshrc`/etc. to use the `passex` function anywhere.

## Usage

````
./passex.sh [options]
-f	force - will remove existing files / directories
-p	pass directory to export	
````

## Security Note

This will export your passwords to **plain text** (that's the point of exporting the passwords, after all).

