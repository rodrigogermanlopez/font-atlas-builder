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
import starling.text.TextFieldAutoSize;
import starling.text.TextFormat;
import starling.textures.Texture;

public class DemoBuildAtlas extends Sprite {


	private var HELVETICA_REGULAR:String;
	private var HELVETICA_BOLDITALIC:String;

	// custom IDs for the Verdana device font.
	private const VERDANA:String = "verdana";
	private const VERDANA_B:String = "verdanaBold";
	private const VERDANA_I:String = "verdanaItalic";
	private const VERDANA_BI:String = "verdanaBoldItalic";

	private var fontsTexture:Texture;
	private var atlasImage:Image;

	private var fab:FontAtlasBuilder;


	/**
	 * Constructor.
	 */
	public function DemoBuildAtlas() {
		init();
	}

	private function init():void {

		// "embed" some fonts
		HELVETICA_REGULAR = new helvetica_regular_FNT().fontName;
		HELVETICA_BOLDITALIC = new helvetica_bold_italic_FNT().fontName;

		trace( 'Fonts are:\n\t' + [HELVETICA_REGULAR, HELVETICA_BOLDITALIC].join( "\n\t" ) );

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
		fab.addFontByStyle( HELVETICA_REGULAR, HELVETICA_REGULAR, 30, 0xffffff );
		fab.addFontByStyle( HELVETICA_BOLDITALIC, HELVETICA_BOLDITALIC, 30, 0xffffff );

		// add some DEVICE fonts... (metrics not available, neither kerning)
		fab.addFontByStyle( VERDANA, "Verdana", 20, 0xffffff, false, false );
		fab.addFontByStyle( VERDANA_B, "Verdana", 20, 0xffffff, true, false );
		fab.addFontByStyle( VERDANA_I, "Verdana", 20, 0xffffff, false, true );
//		fab.addFontByStyle( VERDANA_BI, "Verdana", 22, 0xff00ff, true, true );

		// this will crop the extra space from the atlas. Use it if u will include this into
		// another atlas.
		fab.cropIfExceeds = false;

		// calculate the kerning for the specific font (takes a few extra ms)
		fab.calculateKerning = true;

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
//		trace( fab.getFontStyleXML(REGULAR)); // print xml helvetica regular
//		trace( fab.getFontStyleXML(BOLDITALIC)); // print xml helvetica bold italic
//		trace( fab.getFontStyleXML(VERDANA_B)); // print xml verdana bold (device)

		stage.color = 0xcdcdcd;

		testExport() ;
//		testInStarling();
	}

	private function testInStarling():void {

		createStarlingFonts();

		// preview the atlas.
		atlasImage = new Image( fontsTexture );
		addChild( atlasImage );

		testSingleFont();
//		testMultipleFonts() ;
	}

	private function testMultipleFonts():void {

		var container:Sprite = new Sprite();
		container.x = 20;
		container.y = atlasImage.y + atlasImage.height + 20;
		addChild( container );

		var format:TextFormat = Utils.getStarlingFormat( HELVETICA_REGULAR, 30, 0x0 );

		addTf( HELVETICA_REGULAR );
		addTf( HELVETICA_BOLDITALIC );
		addTf( VERDANA_B );

		// turn on/off the kerning for testing on embed fonts.
		// MAY REQUIRE to add more chars to the kerning table ( FontAtlasBuilder::kerningPairs ), specially
		// combinations with the space character.
		toggleKerning();

		function addTf( font:String ):starling.text.TextField {
			format.font = font;
//			var text:String = font + " - This is a Test ?.,-=+AVATar";
			var text:String = "Test ?.,-=+AVATar";
			var tf:starling.text.TextField = Utils.getStarlingTextField( text, format );
			tf.y = container.numChildren * 100;
			container.addChild( tf );

			// Add flash font for comparision.
			var tf2:flash.text.TextField;
			if ( font == VERDANA_B ) {
				tf2 = Utils.getFlashTextField( text, Utils.getFlashFormat( "Verdana", 30, 0x777777, true, false, true ) );
			} else {
				tf2 = Utils.getFlashTextField( text, Utils.getFlashFormat( font, 30, 0x777777, false, false, true ) );
			}
			tf2.y = container.y + tf.y + 30;
			tf2.x = container.x - 3;
			return tf;
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

	private function testSingleFont():void {

		var texto:String = "This is a Test... VAMOS\nmultiple lines to ValidaTe lineH.";

		var format:TextFormat = Utils.getStarlingFormat( HELVETICA_REGULAR, 30, 0x0 );
		format.kerning = true;
		format.horizontalAlign = "left";

		var tf1 = new starling.text.TextField( 10, 10, texto, format );
		tf1.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
		tf1.x = 550;
		tf1.y = 50;
		addChild( tf1 );
		tf1.text = texto;

		var format2:flash.text.TextFormat = Utils.getFlashFormat( HELVETICA_REGULAR, 30, 0x0, false, false, true );
		format2.kerning = true;

		var tf2 = new flash.text.TextField();
		tf2.defaultTextFormat = format2;
		tf2.embedFonts = true;
		tf2.autoSize = "left";
		tf2.x = 550;
		tf2.y = 130;
		Starling.current.nativeOverlay.addChild( tf2 );
		tf2.text = texto;

		toggleKerning();
		function toggleKerning() {
			tf1.format.kerning = !tf1.format.kerning;
			tf1.format = tf1.format;
			var f:* = tf2.defaultTextFormat;
			f.kerning = !f.kerning;
			tf2.defaultTextFormat = f;
			tf2.setTextFormat( f );
			setTimeout( toggleKerning, 500 )
		}
	}

	private function createStarlingFonts():void {
		fontsTexture = Texture.fromBitmapData( fab.atlas_bd );
		starling.text.TextField.registerCompositor( new BitmapFont( fontsTexture, fab.getFontStyleXML( HELVETICA_REGULAR ) ), HELVETICA_REGULAR );
//		starling.text.TextField.registerCompositor( new BitmapFont( texture, fab.getFontStyleXML( HELVETICA_BOLDITALIC ) ), HELVETICA_BOLDITALIC );
		starling.text.TextField.registerCompositor( new BitmapFont( fontsTexture, fab.getFontStyleXML( VERDANA ) ), VERDANA );
		starling.text.TextField.registerCompositor( new BitmapFont( fontsTexture, fab.getFontStyleXML( VERDANA_B ) ), VERDANA_B );
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
