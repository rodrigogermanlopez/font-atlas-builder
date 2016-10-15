/**
 *
 * Created by Rodrigo Lopez [blnk™] on 10/15/16.
 *
 */
package {
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormat;

import starling.core.Starling;
import starling.display.Sprite;
import starling.text.TextField;
import starling.text.TextFormat;

public class Utils {
	public function Utils() {}

	public static function getStarlingTextField( text:String,
												 format:starling.text.TextFormat = null ):starling.text.TextField {
		var tf:starling.text.TextField = new starling.text.TextField( 10, 10, text, format );
		Sprite( Starling.current.root ).addChild( tf );
		tf.autoSize = "bothDirections";
		return tf;
	}

	public static function getFlashTextField( text:String, format:flash.text.TextFormat = null ):flash.text.TextField {
		var tf:flash.text.TextField = new flash.text.TextField();
		tf.defaultTextFormat = format;
		tf.autoSize = "left";
		tf.text = text;
		tf.multiline = false;
		Starling.current.nativeOverlay.addChild( tf );
		return tf;
	}

	public static function getStarlingFormat( font:String, size:int = 18, color:uint = 0x0 ):starling.text.TextFormat {
		return new starling.text.TextFormat( font, size, color );
	}

	public static function getFlashFormat( font:String, size:int = 18, color:uint = 0x0, bold:Boolean = false,
										   italic:Boolean = false, kerning:Boolean=false ):flash.text.TextFormat {
		var format:flash.text.TextFormat = new flash.text.TextFormat( font, size, color, bold, italic );
		format.kerning = kerning ;
		return format ;
	}

	public static function traceFonts( deviceFonts:Boolean ):void {
		var fonts:Array = Font.enumerateFonts(deviceFonts);
		trace("============");
		trace("FONT LIST ["+(deviceFonts?"DEVICE":"EMBED")+"]");
		for each( var font:Font in fonts ){
			trace("\tname: "+ font.fontName + ", style: " + font.fontStyle + ", type:" + font.fontType)
		}
		trace("============");
	}
}
}
