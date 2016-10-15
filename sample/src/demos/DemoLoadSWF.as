/**
 *
 * Created by Rodrigo Lopez [blnk™] on 10/15/16.
 *
 */
package demos {
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.text.AntiAliasType;
import flash.text.Font;
import flash.text.TextField;

import starling.display.Sprite;

public class DemoLoadSWF extends Sprite {


	//===================================================================================================================================================
	//
	//      Simple test to load a swf and make the embedded Fonts
	//		available.
	//
	//===================================================================================================================================================

	/**
	 * Constructor.
 	 */
	public function DemoLoadSWF() {
		init();
	}

	private function init():void {
		// fonts_swf.swf has to be in "/bin" to avoid security issues.
		var loader:Loader = new Loader();
		loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoaded );
		loader.load( new URLRequest( "fonts_swf.swf" ) );
	}

	private function onLoaded( event:Event ):void {
		var appDomain:ApplicationDomain = (event.target as LoaderInfo).applicationDomain;

		// Inspect app domain
		trace( 'Loaded SWF. Available Font classes:' );
		var list:Vector.<String> = appDomain.getQualifiedDefinitionNames();
		for each( var className:String in list ) {
			trace( "\t" + className );
		}
//		trace( "Has the font? " + appDomain.hasDefinition("standard_09_55_8pt_FNT")) ;
		// take the pixel font from the previous list.
		var standard0965Font:Class = appDomain.getDefinition( "standard_09_55_8pt_FNT" ) as Class;
//		var roboto_light_FNT:Class = appDomain.getDefinition( "roboto_light_FNT" ) as Class;
		var skia_FNT:Class = appDomain.getDefinition( "skia_FNT" ) as Class;

		Font.registerFont( standard0965Font );
		Font.registerFont( skia_FNT );

		var fontName:String = new standard0965Font().fontName;

		Utils.traceFonts( false );

		// create the field
		var tf:TextField = Utils.getFlashTextField( "REMOTE SWF " + fontName, Utils.getFlashFormat( fontName, 8 ) );
		tf.embedFonts = true;
		tf.antiAliasType = AntiAliasType.ADVANCED;
		tf.x = 50;
		tf.y = 50;
	}
}
}
