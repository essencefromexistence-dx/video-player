# DX Video Player

DX-branded fork of mpv. This repository builds a native `dx-video-player`
executable and an ABI-compatible `libdx-video-player` library. It is not a thin
wrapper around a system mpv installation.

## License

This fork follows mpv's build-dependent licensing model:

| Build configuration | License of the resulting combined work |
| --- | --- |
| Default `-Dgpl=true` | GPLv2-or-later |
| `-Dgpl=false`, excluding GPL-only files, with LGPL-compatible dependencies | LGPL2.1-or-later |

`Copyright` is the authoritative licensing document. Renaming the project or
its output files does not change the license of the copied mpv source. Passing
`-Dgpl=false` by itself does not create an LGPL grant.

The current DX build configuration uses the GPL route: the Meson default is
`gpl=true` (`meson.options:2`), the hub build driver does not override it
(`G:\Dx\build.ps1:455-462`), and the Windows version resource declares
GPLv2-or-later (`osdep/mpv.rc:32`). Treat the resulting binaries as GPLv2+.

## Source offer

Public source: https://github.com/essencefromexistence-dx/video-player

Every binary release must identify the exact source commit or tag and provide
an equivalent source archive or link alongside the binary distribution. The
source bundle must include the dependency source actually used, including any
local modifications to subprojects.

See `RELEASE-COMPLIANCE.md` and `THIRD-PARTY-NOTICES.md`.

## Building

The normal Meson build is:

```sh
meson setup build
meson compile -C build
```

DX release builds currently use static mpv core objects, Lua 5.1, and GPL
FFmpeg for the MSVC targets. An LGPL build requires `-Dgpl=false`, an FFmpeg
build without `--enable-gpl`, and an audit of every linked dependency.

## Using from other DX products

Other DX products may launch `dx-video-player` as a separate process without
becoming GPL merely by calling it. Copying mpv source into another product, or
linking `libmpv` into it, changes the licensing analysis.

## Notices

`Copyright`, `LICENSE.GPL`, and `LICENSE.LGPL` are the project license files.
Additional dependency notices are listed in `THIRD-PARTY-NOTICES.md`.
