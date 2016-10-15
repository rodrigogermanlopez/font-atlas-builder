/**
 *
 * Created by Rodrigo Lopez [blnk™] on 10/15/16.
 *
 */
package demos {
import flash.filesystem.File;

import starling.display.Sprite;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;
import starling.text.TextFormat;
import starling.utils.AssetManager;

public class DemoLoadAtlas extends Sprite {


	/**
	 * Constructor.
	 */
	public function DemoLoadAtlas() {
		init();
	}

	private var am:AssetManager;

	private function init():void {

		// hack to point to ./sample/assets/fab_export
		var folder:File = new File( File.applicationDirectory.nativePath ).parent.resolvePath( 'assets/fab_export' );

		am = new AssetManager();

		// keep the xmls to loop thought the font names.
		// there's no accessor to return the compositors.
		am.keepFontXmls = true ;

		// fix for multiple fonts in 1 atlas.
		var imageFile:File = folder.resolvePath( "allfonts.png" );
		// get all the xmls in dir, and map the only png texture to all xmls names.
		var list:Array = folder.getDirectoryListing();
		for each( var file:File in list ) {
			if ( file.extension == "xml" ) {
				am.enqueue( file );
				am.enqueueWithName( imageFile, file.name.split( "." )[0] );
			}
		}

		am.loadQueue( function ( p:Number ):void {
			if ( p == 1 ) assetsLoaded();
		} );
	}

	private function assetsLoaded():void {

		var tf:TextField;
		var format:TextFormat= new TextFormat( null, -1, 0x0 ) ;
		format.horizontalAlign = "left";

		var texto:String = "Amazing text, just to try the\ntext field and the Format!" ;

		for each( var fontName:String in am.getXmlNames() ) {
			format.font = fontName ;
			tf = new TextField(0,0,texto, format ) ;
			tf.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS ;
			tf.x = 10 ;
			tf.text = fontName + " _ " + texto ;
			tf.y = 10 + numChildren * 90 ;
//			tf.border = true ;
			addChild(tf) ;
		}


	}

}
}
