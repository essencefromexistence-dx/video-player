# DX Video Player

DX Video Player is a source fork of mpv. It builds a standalone player
executable and an `libmpv`-compatible client library. The repository retains
the mpv source tree, build system, and public API headers, with DX branding on
the output names and resources.

## Overview

| Item | Value |
| --- | --- |
| Repository | https://github.com/essencefromexistence-dx/video-player |
| Project name | `dx-video-player` |
| Default build | GPLv2-or-later |
| Optional build | LGPL2.1-or-later with `-Dgpl=false` and compatible dependencies |

## Requirements

- Meson 1.3 or newer
- Ninja
- C11 compiler
- FFmpeg, libass, and libplacebo development files

Optional features may require additional libraries. See `meson.options` for the
full option list.

## Building

```sh
meson setup build
meson compile -C build
```

Common build options:

| Option | Effect |
| --- | --- |
| `-Dgpl=false` | Excludes GPL-only mpv source files |
| `-Dcplayer=false` | Builds the client library without the player executable |
| `-Dlibmpv=false` | Builds the player executable without a separate library target |
| `-Ddefault_library=static` | Builds static libraries |
| `-Ddefault_library=shared` | Builds shared libraries |

Build outputs are named `dx-video-player` and `libdx-video-player`. The public
API headers remain under `include/mpv`, so client applications use the libmpv
API.

## License

The license depends on the build configuration:

- The default build is GPLv2-or-later.
- A build with `-Dgpl=false` is LGPL2.1-or-later only when GPL-only files are
  excluded and every linked dependency permits LGPL licensing.

The authoritative licensing notes are in `Copyright`. The license texts are in
`LICENSE.GPL` and `LICENSE.LGPL`. Dependency notices are in
`THIRD-PARTY-NOTICES.md`.

## Distribution

Binary releases must include the applicable license texts and notices, and
must provide access to the source that matches the distributed binary. Release
requirements are documented in `RELEASE-COMPLIANCE.md`.

## Integration

Applications can launch `dx-video-player` as a separate process. Linking the
client library or copying mpv source into another product follows the GPL or
LGPL terms described in `Copyright`.
