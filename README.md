![](https://github.com/senselogic/REMIX/blob/master/LOGO/remix.png)

# Remix

Update command manager.

## Description

*   Parses the command to find its executable, input and output files;
*   Runs the command only if an output file is missing or if the command executable or some input files are newer than the output files.

## Installation

Install the [DMD 2 compiler](https://dlang.org/download.html) (using the MinGW setup option on Windows).

Build the executable with the following command line :

```bash
dmd -m64 remix.d
```

## Command line

```
remix [{option} ...] {command} [{argument} ...]
```

### Arguments

```
@clean : remove the output files
@force : run the command unconditionally
@from:{hidden input file path}
@to:{hidden output file path}
@:{ignored file path}
@in:{input file path}
@out:{output file path}
@+{minimum output file size}:{output file path}
@-{minimum output file size}:{output file path}
@try:{tentative argument}
```

An argument is treated as an input file path if it ends with a file extension.

The last argument is treated as an output file path if it ends with a file extension.

### Examples

```bash
remix ../IMAGE_MAGICK/magick input.jpg output.jpg
remix ../IMAGE_MAGICK/magick "input file.jpg" "output file.jpg"
remix @in:../IMAGE_MAGICK/magick @in:input.jpg @in:output.jpg
remix @in:../IMAGE_MAGICK/magick "@in:input file.jpg" "@in:output file.jpg"
remix @in:../IMAGE_MAGICK/magick "@in:input file.jpg" "@in:output file.jpg"
```

Generate the output file if the executable or the input file is newer than the output file.

```bash
remix @force ../IMAGE_MAGICK/magick input.jpg output.jpg
remix @force ../IMAGE_MAGICK/magick "input file.jpg" "output file.jpg"
remix @force @in:../IMAGE_MAGICK/magick @in:input.jpg @in:output.jpg
remix @force @in:../IMAGE_MAGICK/magick "@in:input file.jpg" "@in:output file.jpg"
```

Generate the output file unconditionally.

```bash
remix ../IMAGE_MAGICK/magick -auto-orient -filter Lanczos "input file.jpg" -resize "1200x630^" -gravity center -extent 1200x630 -quality 85 -strip "output file.jpg"
```

Generate the output file if the executable or the input file is newer than the output file.

```bash
remix /IMAGE_MAGICK/magick -auto-orient -filter Lanczos "input file.jpg" -resize "1920x1920>" -quality @try:60 @try:50 @try:40 @try:30 -strip "@-160k:output file.avif"
```

Generate the output file if the executable or the input file is newer than the output file, retrying with a lower quality setting if the output file takes more than 160 KB.

## Version

0.3

## Author

Eric Pelzer (ecstatic.coder@gmail.com).

## License

This project is licensed under the GNU General Public License version 3.

See the [LICENSE.md](LICENSE.md) file for details.
