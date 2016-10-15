package demos {
import flash.text.AntiAliasType;
import flash.text.Font;

import starling.display.Sprite;

public class DemoWaysToEmbed extends Sprite {

	public function DemoWaysToEmbed() {
		init();
	}

	private function init():void {


		//===================================================================================================================================================
		//
		//      WAYS TO EMBED A FONT IN FLASH.
		//
		//===================================================================================================================================================

		// precompiled SWC fonts (embedded)
		var allFontsSWC:Array = [
			helvetica_light_FNT,
			helvetica_regular_FNT,
			helvetica_bold_italic_FNT,
			prelo_light_FNT,
			prelo_light_italic_FNT,
			prelo_semibold_FNT,
			prelo_semibold_italic_FNT
		] ;

		// precompiled SWF fonts (embedded)
		EmbedSWF.register() ;

		// EMBEDDED at runtime fonts (ttf/otf/etc)
		EmbedFontFiles.register() ;

		var posy:int = 50 ;

		var tf:flash.text.TextField ;

		// register the swc fonts and show them on stage.
		for each( var swcFont:Class in allFontsSWC ){
			var fontName:String = Font( new swcFont ).fontName ;
			tf = Utils.getFlashTextField( "SWC-"+fontName, Utils.getFlashFormat( fontName, 24 ) ) ;
			tf.embedFonts = true ;
			tf.antiAliasType = AntiAliasType.ADVANCED ;
			tf.x = 50 ;
			tf.y = posy ;
			posy += 30 ;
		}

		// add the swf fonts.
		for each( fontName in EmbedSWF.fontNames ){
			tf = Utils.getFlashTextField( "SWF-"+fontName, Utils.getFlashFormat( fontName, 24 ) ) ;
			tf.embedFonts = true ;
			tf.antiAliasType = AntiAliasType.ADVANCED ;
			tf.x = 50 ;
			tf.y = posy ;
			posy += 30 ;
		}

		// add the ttf/otf embedded fonts.
		for each( fontName in EmbedFontFiles.fontNames ){
			tf = Utils.getFlashTextField( "Embed-"+fontName, Utils.getFlashFormat( fontName, 24 ) ) ;
			tf.embedFonts = true ;
			tf.antiAliasType = AntiAliasType.ADVANCED ;
			tf.x = 50 ;
			tf.y = posy ;
			posy += 30 ;
		}


	}
}
}
