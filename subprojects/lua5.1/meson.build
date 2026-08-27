project(
    'lua5.1',
    'c',
    version: '5.1.5',
    meson_version: '>= 0.55.0',
    default_options: ['default_library=static'],
)

lua_source_dir = 'lua-5.1.5/src'
lua_includes = include_directories(lua_source_dir)

lua_sources = files([
    lua_source_dir / 'lapi.c',
    lua_source_dir / 'lcode.c',
    lua_source_dir / 'ldebug.c',
    lua_source_dir / 'ldo.c',
    lua_source_dir / 'lfunc.c',
    lua_source_dir / 'lgc.c',
    lua_source_dir / 'llex.c',
    lua_source_dir / 'lmem.c',
    lua_source_dir / 'lobject.c',
    lua_source_dir / 'lopcodes.c',
    lua_source_dir / 'lparser.c',
    lua_source_dir / 'lstate.c',
    lua_source_dir / 'lstring.c',
    lua_source_dir / 'ltable.c',
    lua_source_dir / 'ltm.c',
    lua_source_dir / 'lundump.c',
    lua_source_dir / 'lvm.c',
    lua_source_dir / 'lzio.c',
    lua_source_dir / 'lauxlib.c',
    lua_source_dir / 'lbaselib.c',
    lua_source_dir / 'ldblib.c',
    lua_source_dir / 'ldump.c',
    lua_source_dir / 'liolib.c',
    lua_source_dir / 'lmathlib.c',
    lua_source_dir / 'loslib.c',
    lua_source_dir / 'ltablib.c',
    lua_source_dir / 'lstrlib.c',
    lua_source_dir / 'loadlib.c',
    lua_source_dir / 'linit.c',
])

lua_static = static_library(
    'lua5.1',
    lua_sources,
    include_directories: lua_includes,
    install: false,
)

lua_dep = declare_dependency(
    link_with: lua_static,
    include_directories: lua_includes,
)

pkgconfig = import('pkgconfig')
pkgconfig.generate(
    lua_static,
    name: 'lua5.1',
    filebase: 'lua5.1',
    version: meson.project_version(),
    description: 'Lua 5.1 embeddable scripting language',
)

meson.override_dependency('lua5.1', lua_dep)
