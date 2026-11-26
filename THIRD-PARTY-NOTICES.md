# Third-Party Notices

Binary distributions of `dx-video-player` must preserve the applicable license
texts and copyright notices, and must provide the corresponding source.

| Component | License | Local source / notice |
| --- | --- | --- |
| mpv-derived core | GPLv2-or-later by default; LGPL2.1-or-later only in a qualifying `-Dgpl=false` build | `Copyright`, `LICENSE.GPL`, `LICENSE.LGPL` |
| FFmpeg | LGPL2.1-or-later by default; GPLv2-or-later when GPL parts are enabled | `subprojects/ffmpeg/LICENSE.md`, `subprojects/ffmpeg/COPYING.*` |
| libplacebo | LGPL2.1-or-later | `subprojects/libplacebo/LICENSE` |
| libass | ISC | `subprojects/libass/COPYING` |
| Lua 5.1.5 | MIT | `subprojects/lua5.1/lua-5.1.5/src/lua.h` |
| HarfBuzz, FreeType, FriBidi, zlib, and other bundled libraries | See each bundled source tree | License files under the matching `subprojects/` directory |

For GPL builds that link GPL-enabled FFmpeg, the corresponding FFmpeg source
must be provided with the release. Dynamic linking to a GPL library does not
remove the GPL source obligation for the combined work.

Distribution packaging must not replace or hide these notices behind a
proprietary EULA. Each component remains under its own license.
