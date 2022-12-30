![](https://github.com/senselogic/FORGE/blob/master/LOGO/forge.png)

# Forge

Conditional command processor.

## Installation

Install the [DMD 2 compiler](https://dlang.org/download.html) (using the MinGW setup option on Windows).

Build the executable with the following command line :

```bash
dmd -m64 forge.d
```

## Command line

```
forge [argument] [argument ...]
```

### Roles

The first argument is treated as an input file path.
If an argument ends with a file path extension, it is treated as an input file path.
If the last argument ends with a file path extension, it is treated as an output file path.
If an argument has a role prefix, the prefix is removed and this role is used :

```
@in: input file path
@out: output file path
@from: removed input file path
@to: removed output file path
@: ignored file path
```

If any input file path is newer than any output file path, the command is executed with the provided arguments.

### Examples

```bash
forge ../TOOL/IMAGE_MAGICK/convert input.jpg output.jpg
```

Runs the command if the command executable or input file is newer than the output file.

```bash
forge @from:convert_images.sh @in:../TOOL/IMAGE_MAGICK/convert @in:input.jpg @out:output.jpg
```

Runs the command if the command script or command executable or input file is newer than the output file.

## Version

0.1

## Author

Eric Pelzer (ecstatic.coder@gmail.com).

## License

This project is licensed under the GNU General Public License version 3.

See the [LICENSE.md](LICENSE.md) file for details.
