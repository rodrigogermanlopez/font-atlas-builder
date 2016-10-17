# font atlas builder {FAB}
A simple font atlas builder (Bitmap Font) for AS3 to use with Starling or any other suitable framework

The most useful thing about it, is to package "wisely" multiple fonts in 1 atlas.
![Image spritesheet](https://dl.dropboxusercontent.com/u/21621726/starling/fab_atlas1.png)

*(512x512 atlas with 5 fonts embeded with a minimized latin1_charset, Helvetica Light and Helvetica Bold Oblique are at 30pt and embedded into the app, while Verdana (regular, italic and bold) are at 20pt using device fonts)*

As it renders the spritesheet using Flash's TextField, the representation of the BitmapText should have proper metrics at 1:1
which seems critical when working with a design team :)

The code is not yet optimized, but several demos are included. The most critical part is to embed the fonts into the package, that's why is a runtime "library" as needs to be compiled with the Font files accesible via code to have access to metrics information.

The functionality is really simple:
```javascript
var fab:FontAtlasBuilder = new FontAtlasBuilder( stage );
// you can define a folder to export the xml/png.
fab.exportDir = File.desktopDirectory.resolvePath( "fab_export" );
fab.defineAtlas( 256, 256, 0x0 ) ; // transparent bg spritesheet 256x256
fab.padding = 2 ; // padding between glyphs/margin

// you can rotate the quads inside the sprite to gain more room
// during the spritesheet's packing (not supported by Starling, requires a tiny hack to BitmapText).
// and I guess it breaks batching while rendering tons of glyphs on screen...
fab.allowRotation = true ;

// System fonts based on familyName (OSX FontBook)
fab.addFontByStyle( "arialBold", "Arial", 30, 0xff0000, true, false ) ; // arial at 30pt, red, BOLD
fab.addFontByStyle( "courierNew", "Courier New", 30, 0x00ff00, false, true ) ; // courier new at 30pt, green, ITALIC

// or use embed fonts.
[Embed(source="LemonMilk.otf", fontName = "Lemon_Milk", mimeType = "application/x-font", advancedAntiAliasing="true", embedAsCFF="false")]
private static var LemonMilkFont:Class;

// load the font in memory.
new LemonMilkFont() ;

var myFormat:flash.text.TextFormat = new flash.text.TextFormat( "Lemon_Milk", 40, 0xffffff ) ;
fab.addFontByTextFormat( "LemonMilk", myFormat ) ;

// set the glyphs to export.
fab.chars = FontAtlasBuilder.CHARSET_LATIN1;

// calculate kerning when available (only embed fonts)
fab.calculateKerning = true;

// add the needed callbacks.
// 1 - when glyphs are printed into bitmaps...
fab.onGlyphProcessed = function(){
  fab.pack();
};

// 2 - when the max bin rect logic ends to pack everything on the atlas.    
fab.onPackComplete = function(){
  fab.exportAll(); // export all the xmls and png.
}

// start processing the fonts.
fab.process();
```

**UPDATE:**

Now it has the option to package rotated glyphs, just set
    allowRotation=true

![Image spritesheet](https://dl.dropboxusercontent.com/u/21621726/starling/fab_atlas2.png)

**UPDATE 17/10/2016 :**

Signed Distance Fields generator included as a separated class (DFS.as)
The DF generation process is REALLY heavy in CPU terms, that's why I split the logic in batches to avoid blocking the UI and overloading the CPU/freezing the app.

Is not integrated into FAB yet, but is useful to process and export any DisplayObject (or BitmapData)

[Sample class](https://github.com/rodrigogermanlopez/font-atlas-builder/blob/master/sample/src/demos/DemoDistanceField.as) 

Partial DF generation in realtime:
![partial DF generation](https://dl.dropboxusercontent.com/u/21621726/starling/fds_demo1.png)

DistanceFieldStyle applied in Starling when the process is completed:
![Starling DistanceField](https://dl.dropboxusercontent.com/u/21621726/starling/fds_demo2.png)
