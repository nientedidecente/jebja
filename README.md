# jebja

simple sailing boat simulator in Haxe/Heaps

## How to Run
Prerequisites:
- [Haxe](https://haxe.org/download/) installed (used version 4.1.2 while developing).
- [Hashlink](https://hashlink.haxe.org/) installed (if you want to use the SDL version)

To install dependencies
```
haxelib install hxml/js.hxml // deps for js
haxelib install hxml/hl.hxml // deps for hashlink
```

**Build**

**Hashlink**

To build it as **hashlink-sdl** target: `haxe hxml/hl.hxml`
This will generate `build/game.hl` that will be runnable with `hl build/game.hl`

**Web/JS**

To build it as **web/js** target: `haxe hxml/js.hxml`
This will generate `web/game.js` that will be runnable by opening the `web/index.html` with a browser.

