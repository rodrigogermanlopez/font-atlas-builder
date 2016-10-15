/**
 *
 * Created by Rodrigo Lopez [blnk™] on 10/15/16.
 *
 */
package demos {
import flash.text.Font;

public class EmbedFontFiles {

	// UNICODE RANGE REFERENCE
	/*
	 Default ranges
	 U+0020-U+0040, // Punctuation, Numbers
	 U+0041-U+005A, // Upper-Case A-Z
	 U+005B-U+0060, // Punctuation and Symbols
	 U+0061-U+007A, // Lower-Case a-z
	 U+007B-U+007E, // Punctuation and Symbols

	 Extended ranges (if multi-lingual required)
	 U+0080-U+00FF, // Latin I
	 U+0100-U+017F, // Latin Extended A
	 U+0400-U+04FF, // Cyrillic
	 U+0370-U+03FF, // Greek
	 U+1E00-U+1EFF, // Latin Extended Additional
	 */

	// fontName defines the name that will be used in TextFormat.
	[Embed(source="../../assets/LemonMilk.otf",
			fontName = "Lemon_Milk",
			unicodeRange ="U+0020-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E",
			mimeType = "application/x-font",
			advancedAntiAliasing="true",
			embedAsCFF="false")]
	private static var LemonMilkFont:Class;

	[Embed(source="../../assets/mark_my_words.ttf",
			fontName = "mark_my_words",
			unicodeRange ="U+0020-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E",
			mimeType = "application/x-font",
			advancedAntiAliasing="true",
			embedAsCFF="false")]
	private static var MarkMyWordsFont:Class;

	private static var allFonts:Array = [LemonMilkFont, MarkMyWordsFont];
	public static var fontNames:Array = [];

	public function EmbedFontFiles() {
	}

	public static function register():void {
		for each( var fontClass:Class in allFonts ) {
			Font.registerFont( fontClass );
			var fontName:String = Font( new fontClass()).fontName ;
			fontNames.push(fontName);
			trace("EmbedFontFile::font added > " + fontName ) ;
		}
	}
}
}
