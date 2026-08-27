# PLAN: Bring all 11 dx-video-player binaries to feature parity (custom UI + logo)

Status: COMPLETE (all 11 targets rebuilt and structurally verified; runtime playback remains unverified because no `titanic.mp4` was available)

## Background / Problem

The binaries in `G:\Dx\bin` ARE built from the latest source (HEAD `7678739`, built 8/1).
However our cross-build pipeline drops two things the fork's "real" build has:

1. **Logo (icon) is missing entirely.** The icon resource (`osdep/mpv.rc` -> `.rsrc`)
   is only compiled for native (non-cross) builds because of the guard in
   `meson.build:1801` (`if win32 and not meson.is_cross_build()`). All 11 targets
   are cross-builds -> no icon at all. The fork's own logo `etc/dx-icon.ico` was
   wired in commit `2cca779` but reverted in `7559b89`. It is a 445-byte, single
   image icon. User decision: use `dx-icon.ico` as-is.

2. **Functions (custom UI) are absent.** The fork's custom "liquid glass" on-screen
   controller (`player/lua/osc.lua`, `player/lua/context_menu.lua` - play/pause,
   volume, loop) requires a **Lua interpreter**. Our binaries have zero Lua
   symbols -> the UI never loads. The fork's CI enables `-Dlua=luajit`,
   `-Djavascript=enabled`, `-Dvulkan=enabled`, etc. User decision: enable Lua so
   the on-screen UI works. Scope: all 11 targets.

Bonus bug found during verification: the dynamic linux-gnu builds embed
`G:/ffmpeg-prebuilt/...` (a Windows path) as their ELF RUNPATH -> they fail to
find FFmpeg libs on any normal Linux box without `LD_LIBRARY_PATH`.

## Findings that shaped this plan (verified facts)

- `meson.build:1801`: `if win32 and not meson.is_cross_build()` gates the `.rc`.
- `osdep/mpv.rc:47`: `IDI_ICON1 ICON "etc/mpv-icon.ico"` (currently the mpv icon).
- `osdep/win32/smtc.cpp:372`: `LoadIconW(..., L"IDI_ICON1")` needs the `.rsrc`.
- `meson.build:725-751`: Lua probing via `dependency('lua5.1', version: '>=5.1.0')`
  etc.; option `-Dlua` accepts `lua/lua52/lua5.2/lua-5.2/luajit/lua51/lua5.1/lua-5.1`.
- `cross/aarch64-pc-windows-gnullvm.ini` ALREADY has
  `windres = 'G:/Dev/Tools/Scoop/apps/mingw/current/bin/windres.exe'` (pattern to copy).
- scoop mingw `windres.exe` exists at `G:\Dev\Tools\Scoop\apps\mingw\current\bin\windres.exe`.
- `subprojects/` uses meson wraps (`.wrap` + `packagecache/` tarballs); no lua wrap present.
- `build.ps1` meson block deletes the build dir (`Remove-Item $buildDir`) then runs
  `meson setup` fresh -> would re-trigger ~11h FFmpeg source builds for
  musl/armv7/android/darwin targets. MUST change to reconfigure-in-place instead.
- `build.ps1:392-397` sets `$featArgs` (static/release) and has per-target option blocks.

## Step 1 - Enable Lua (custom UI) for all targets

- [x] Vendor **Lua 5.1.5** (pure C, cross-compiles everywhere) as a meson subproject:
  - [x] Download `lua-5.1.5.tar.gz` into `subprojects/packagecache/`.
  - [x] Create `subprojects/lua5.1.wrap` (`[wrap-file]` pointing at the tarball +
        source_hash; `[provide] dependency_names = lua5.1`).
  - [x] Create `subprojects/lua5.1/meson.build` that:
        - builds `liblua` (static) + `lua.h` include dir,
        - `pkgconfig.generate(...)` to emit `lua5.1.pc` (version 5.1.5),
        - exposes dependency so `dependency('lua5.1')` resolves for all cross targets.
- [x] `build.ps1`: add `-Dlua=lua5.1` and `--force-fallback-for=lua5.1` to `$featArgs`.
- [x] Verify: Lua runtime strings/symbols are present in all 11 rebuilt binaries.
      Runtime `[osc]` loading was not exercised because `titanic.mp4` is unavailable.

## Step 2 - Embed the dx logo on Windows (all 4 win targets)

- [x] `osdep/mpv.rc:47`: change `etc/mpv-icon.ico` -> `etc/dx-icon.ico`.
- [x] `meson.build:1801`: drop the `not meson.is_cross_build()` guard -> `if win32`.
- [x] Add a resource compiler to every Windows build config:
      `cross/x86_64-pc-windows-msvc.ini`,
      `cross/aarch64-pc-windows-msvc.ini`,
      `native-x86_64-pc-windows-gnullvm.ini`, and
      `cross/aarch64-pc-windows-gnullvm.ini`.
- [x] Verify: `.rsrc` section + `IDI_ICON1` resource present in all four rebuilt
      win exes; version resource present.
- [x] NOTE: dx-icon.ico is 1 image / 445 bytes -> will render small/pixelated but it
      is the user's chosen dx logo.

The ARM64 Windows configurations use LLVM's resource compiler where MinGW's
resource object format is not linkable by the ARM64 linker; x64 continues to use
the MinGW resource compiler.

## Step 3 - Fix linux-gnu RUNPATH bug (dynamic linux targets)

- [x] Locate where `G:/ffmpeg-prebuilt/...` rpath is injected
      (candidates: `cross/*.ini` link args, `native-build-machine.ini`,
      `meson-env.ps1`, `src-env.ps1`, `build.ps1`). Use `rg -n "rpath|-Wl,-rpath"`.
- [x] Remove/neutralize it for the dynamic linux-gnu targets by sanitizing the
      FFmpeg `.pc` metadata and supplying the absolute library directory only as
      a linker search path.
- [x] Verify: `readelf -d` shows no `RPATH`/`RUNPATH` on either dynamic GNU
      binary. Playback via `LD_LIBRARY_PATH` was not exercised because
      `titanic.mp4` is unavailable.

## Step 4 - Rebuild all 11 targets (preserve FFmpeg artifacts)

- [x] `build.ps1` meson block: replace `Remove-Item -Recurse -Force $buildDir` with:
      - if build dir exists -> `meson setup --reconfigure $buildDir <same args>`,
      - else -> fresh `meson setup`.
      A one-time `--wipe` retry was also added for stale absolute Meson paths after
      checkout relocation; source subprojects and package caches remain intact.
- [x] Quarantine the stale `dx-video-player` outputs before rebuilding; FFmpeg DLLs
      were kept in `G:\Dx\bin`.
- [x] Run the build driver: all 11 `dx-video-player` target binaries are present
      in `G:\Dx\bin` and each completed with a successful Ninja link.
- [x] Monitor and complete the slow FFmpeg-source targets; NASM was added to the
      driver PATH for libass/FFmpeg x86 assembly builds.

## Step 5 - Verification matrix

Runtime (titanic.mp4 = H.264 576x640; decode + EOF exit 0):

- [x] Windows x64 msvc (plain + named): `.rsrc`, `IDI_ICON1`, version resource,
      and Lua runtime strings verified. Playback was not run: no `titanic.mp4` found.
- [x] Windows x64 gnullvm: `.rsrc`, `IDI_ICON1`, version resource, and Lua runtime
      strings verified. Playback was not run: no `titanic.mp4` found.
- [x] Windows aarch64 msvc / gnullvm: `.rsrc`, `IDI_ICON1`, and version resources
      verified; no ARM64 Windows host was available for execution.
- [x] WSL linux-gnu x64: ELF dependencies, Lua symbols, and no `RPATH`/`RUNPATH`
      verified. Playback was not run: no `titanic.mp4` found.
- [x] WSL musl static x64: no dynamic section and Lua symbols verified. Playback
      was not run: no `titanic.mp4` found.
- [x] qemu armv7: ELF dependencies and Lua symbols verified; runtime was not run.
- [x] qemu aarch64 gnu: ELF dependencies, Lua symbols, and no `RPATH`/`RUNPATH`
      verified; runtime was not run.
- [x] Android aarch64: PIE (`ET_DYN`) and `NEEDED` checks passed.
- [x] Darwin x2: Mach-O x86_64/arm64 headers and Lua symbols passed; no dynamic
      library load commands were reported.
- [x] `readelf -d`: the two dynamic GNU binaries contain no `G:/...` path and no
      `RPATH`/`RUNPATH` entry.

Runtime limitation: `rg --files G:\Dx -g titanic.mp4` found no sample media, so
decode/EOF exit status and `[osc]` runtime loading remain unverified.

## Risks / fallbacks

- If `dependency('lua5.1')` subproject fallback does not resolve: fallback plan =
  build Lua per-triple into a prefix and add its `lib/pkgconfig` to `PKG_CONFIG_PATH`
  (matches the existing ffmpeg pkgconfig pattern in build.ps1).
- If lld-link rejects mingw windres COFF for clang-cl targets: switch to
  `llvm-windres` (or `zig rc` wrapper).
- Optional (not included unless requested): `-Djavascript=enabled` (mujs) +
  `-Dvulkan=enabled` to fully match fork CI.

## DONE (update as steps complete)
- [x] Step 1 (lua)
- [x] Step 2 (icon)
- [x] Step 3 (runpath)
- [x] Step 4 (rebuild)
- [x] Step 5 (structural verification; runtime media unavailable)
