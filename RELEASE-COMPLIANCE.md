# Release Compliance

Use this checklist before publishing a binary release from this repository.

- [ ] Tag or record the exact source commit used for the binary.
- [ ] Resolve every dirty subproject and include any local modifications in
      the source bundle. Do not claim a clean source release while
      `subprojects/ffmpeg` or `subprojects/libplacebo` is dirty.
- [ ] Add or pin untracked dependency source such as `subprojects/libass`.
- [ ] Include the build scripts or an equivalent reproducible recipe with the
      source bundle. The current DX driver is `G:\Dx\build.ps1:436-626`.
- [ ] Include `Copyright`, `LICENSE.GPL`, `LICENSE.LGPL`, and
      `THIRD-PARTY-NOTICES.md` with the binary distribution.
- [ ] Provide the corresponding source for GPL-enabled FFmpeg where used.
- [ ] Confirm no nonfree dependency was enabled.
- [ ] Keep the player as a separate executable when launched by other DX
      products; do not copy mpv source into those products.

Current known gaps:

| Gap | Evidence |
| --- | --- |
| `subprojects/ffmpeg` has uncommitted modifications | `git status -sb` |
| `subprojects/libplacebo` has uncommitted modifications | `git status -sb` |
| `subprojects/libass` is untracked | `git status -sb` |
| Inherited GitHub workflow targets `master` and old `mpv.exe` names | `.github/workflows/build.yml:3-8`, `ci/build-win32.ps1:347` |
| Inherited publish job is restricted to `mpv-player/mpv` | `.github/workflows/build.yml:681-685` |

Making the repository public does not by itself satisfy the source obligations
for an already-built binary. It makes the source available; the release must
still correspond exactly to the binary being distributed.
