/**
 *
 * Created by Rodrigo Lopez [blnk™] on 10/15/16.
 *
 */
package demos {
import flash.text.Font;

public class EmbedSWF {

	[Embed(source="../../bin/fonts_swf.swf", symbol="roboto_italic_FNT")]
	public static var RobotoItalicFont:Class;

	[Embed(source="../../bin/fonts_swf.swf", symbol="roboto_light_FNT")]
	public static var RobotoLightFont:Class;

	/*[Embed(source="../../assets/fonts_swf.swf", symbol="roboto_light_italic_FNT")]
	 public static var RobotoLightItalicFont:Class;

	 [Embed(source="../../assets/fonts_swf.swf", symbol="roboto_regular_FNT")]
	 public static var RobotoRegularFont:Class;

	 [Embed(source="../../assets/fonts_swf.swf", symbol="signpainter_regular_FNT")]
	 public static var SignpainterFont:Class;

	 [Embed(source="../../assets/fonts_swf.swf", symbol="signpainter_semibold_FNT")]
	 public static var SignpainterSemiboldFont:Class;

	 [Embed(source="../../assets/fonts_swf.swf", symbol="skia_FNT")]
	 public static var SkiaFont:Class;

	 [Embed(source="../../assets/fonts_swf.swf", symbol="standard_09_55_8pt_FNT")]
	 public static var Standard0955Font:Class;

	 [Embed(source="../../assets/fonts_swf.swf", symbol="standard_09_65_8pt_FNT")]
	 public static var Standard0965Font:Class;*/

	private static var allFonts:Array = [RobotoItalicFont, RobotoLightFont];
	public static var fontNames:Array = [];

	public function EmbedSWF() {
	}

	public static function register():void {
		for each( var fontClass:Class in allFonts ) {
			Font.registerFont( fontClass );
			var fontName:String = Font( new fontClass()).fontName ;
			fontNames.push(fontName);
			trace("EmbedSWF::font added > " + fontName ) ;
		}
	}
}
}
