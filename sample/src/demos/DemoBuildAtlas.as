/**
 *
 * Created by Rodrigo Lopez [blnk™] on 10/15/16.
 *
 */
package demos {
import blnk.atlas.FontAtlasBuilder;

import flash.filesystem.File;
import flash.text.TextField;
import flash.utils.setTimeout;

import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.text.TextFormat;
import starling.textures.Texture;

public class DemoBuildAtlas extends Sprite {

	private var fab:FontAtlasBuilder;

	/**
	 * Constructor.
	 */
	public function DemoBuildAtlas() {
		init();
	}

	private var HELVETICA_LIGHT:String;
	private var HELVETICA_REGULAR:String;
	private var HELVETICA_BOLDITALIC:String;

	// custom IDs for the Verdana device font.
	private const VERDANA:String = "verdana";
	private const VERDANA_B:String = "verdanaBold";
	private const VERDANA_I:String = "verdanaItalic";
	private const VERDANA_BI:String = "verdanaBoldItalic";


	private function init():void {

		// "embed" some fonts
		HELVETICA_LIGHT = new helvetica_light_FNT().fontName;
		HELVETICA_REGULAR = new helvetica_regular_FNT().fontName;
		HELVETICA_BOLDITALIC = new helvetica_bold_italic_FNT().fontName;

		trace( 'Fonts are:\n\t' + [HELVETICA_LIGHT, HELVETICA_REGULAR, HELVETICA_BOLDITALIC].join( "\n\t" ) );

		fab = new FontAtlasBuilder( Starling.current.nativeStage );

		// you can define a folder to export the xml/png.
		fab.exportDir = File.desktopDirectory.resolvePath( "fab_export" );

		// used as a filename for the png and to map the xml properly.
		fab.fontAtlasFilename = "allfonts";

		// define atlas width, height and bgColor(32 bits)
		fab.defineAtlas( 512, 512, 0x0 ); // 0xFF000000

		// padding between chars and edges of the bitmap.
		fab.padding = 2;

		// add fonts ...
		fab.addFontByStyle( HELVETICA_LIGHT, HELVETICA_LIGHT, 30, 0xffffff );
		fab.addFontByStyle( HELVETICA_REGULAR, HELVETICA_REGULAR, 30, 0xffffff );
		fab.addFontByStyle( HELVETICA_BOLDITALIC, HELVETICA_BOLDITALIC, 30, 0xffffff );

		// add some DEVICE fonts... (metrics not available, neither kerning)
//		fab.addFontByStyle( VERDANA, "Verdana", 22, 0xff00ff, false, false );
		fab.addFontByStyle( VERDANA_B, "Verdana", 30, 0xffffff, true, false );
//		fab.addFontByStyle( VERDANA_I, "Verdana", 22, 0xff00ff, false, true );
//		fab.addFontByStyle( VERDANA_BI, "Verdana", 22, 0xff00ff, true, true );

		// this will crop the extra space from the atlas. Use it if u will include this into
		// another atlas.
		fab.cropIfExceeds = false;

		// calculate the kerning for the specific font (takes a few extra ms)
		fab.calculateKerning = true;
		fab.kerningPairs = FontAtlasBuilder.KERNING_PAIRS;

		// characters to be included.
		fab.chars = FontAtlasBuilder.CHARSET_LATIN1;

		// round the values in the atlas (kerning and xadvance), not needed.
		fab.roundXMLValues = false;

		// the callbacks.
		fab.onGlyphProcessed = onGlyphsProcessed;
		fab.onPackComplete = onAtlasPackComplete;

		// process the atlas glyphs first.
		fab.process();
	}

	private function onGlyphsProcessed():void {
		// if the class gets extended to add MovieClip or images, etc into the atlas, this will be
		// the place to do it, before packing everything.
		fab.pack();
	}

	private function onAtlasPackComplete():void {
		// The final spritesheet has been generated
		// We can access the xml and bitmapdata now.

//		Starling.current.nativeOverlay.addChild(new Bitmap(fab.atlas_bd)) ; // add bitmap to flash's stage.
//		trace( fab.getFontStyleXML(LIGHT)); // print xml helvetica light
//		trace( fab.getFontStyleXML(REGULAR)); // print xml helvetica regular
//		trace( fab.getFontStyleXML(BOLDITALIC)); // print xml helvetica bold italic

//		testExport() ;
		testInStarling();
	}

	private function testInStarling():void {
		var texture:Texture = Texture.fromBitmapData( fab.atlas_bd );
		starling.text.TextField.registerCompositor( new BitmapFont( texture, fab.getFontStyleXML( HELVETICA_LIGHT ) ), HELVETICA_LIGHT );
		starling.text.TextField.registerCompositor( new BitmapFont( texture, fab.getFontStyleXML( HELVETICA_REGULAR ) ), HELVETICA_REGULAR );
		starling.text.TextField.registerCompositor( new BitmapFont( texture, fab.getFontStyleXML( HELVETICA_BOLDITALIC ) ), HELVETICA_BOLDITALIC );
		starling.text.TextField.registerCompositor( new BitmapFont( texture, fab.getFontStyleXML( VERDANA_B ) ), VERDANA_B );

		stage.color = 0xcdcdcd;

		// preview the atlas.
		var atlasImage:Image = new Image( texture );
		addChild( atlasImage );

		var container:Sprite = new Sprite();
		container.x = 20;
		container.y = atlasImage.y + atlasImage.height + 20;
		addChild( container );

		var format:TextFormat = Utils.getStarlingFormat( HELVETICA_LIGHT, 30, 0x232323 );
		addTf( HELVETICA_LIGHT );
		addTf( HELVETICA_REGULAR );
		addTf( HELVETICA_BOLDITALIC );
		addTf( VERDANA_B );

		// turn on/off the kerning for testing on embed fonts.
		// MAY REQUIRE to add more chars to the kerning table ( FontAtlasBuilder::kerningPairs ), specially
		// combinations with the space character.
//		toggleKerning();

		function addTf( font:String ):starling.text.TextField {
			format.font = font;
			var text:String = font + " - This is a Test ?.,-=+AVATar";
			var tf:starling.text.TextField = Utils.getStarlingTextField( text, format );
			tf.y = container.numChildren * 100;
			container.addChild( tf );

			// Add flash font for comparision.
			var tf2:flash.text.TextField ;
			if( font==VERDANA_B ){
				tf2 = Utils.getFlashTextField( text, Utils.getFlashFormat( "Verdana", 30, 0x777777, true, false, true ) );
			} else {
				tf2 = Utils.getFlashTextField( text, Utils.getFlashFormat( font, 30, 0x777777, false, false, true ) );
			}
			tf2.y = container.y + tf.y + 30;
			tf2.x = container.x - 3;

			return tf ;
		}

		function toggleKerning():void {
			for ( var i:int = 0; i < container.numChildren; i++ ) {
				var tf:starling.text.TextField = container.getChildAt( i ) as starling.text.TextField;
				var tfFormat:TextFormat = tf.format;
				tfFormat.kerning = !tfFormat.kerning;
				tf.format = tfFormat;
			}
			setTimeout( toggleKerning, 500 );
		}

	}

	private function testExport():void {
		// shortcut.
		fab.exportAll();

		// we can export the assets now.
//		fab.exportXml(VERDANA);
//		fab.exportXml(VERDANA_B);
//		fab.exportXml(VERDANA_I);
//		fab.exportXml(VERDANA_BI) ;
//		fab.exportXml(LIGHT) ;
//		fab.exportXml(REGULAR) ;
//		fab.exportXml(BOLDITALIC) ;

//		fab.exportBitmap() ;

	}

}
}
