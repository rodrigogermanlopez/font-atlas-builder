/**
 *
 * Created by Rodrigo Lopez [blnk™] on 10/15/16.
 *
 */
package {
import demos.*;

import flash.desktop.NativeApplication;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.system.Capabilities;

import starling.core.Starling;

[SWF(width="800", height="600", backgroundColor="#565656", frameRate="60")]
public class Boot extends Sprite {

	public function Boot() {
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		stage.quality = StageQuality.HIGH;

		var Demo:Class;

		// test classes
		Demo = DemoWaysToEmbed ;
//		Demo = DemoLoadSWF ;
//		Demo = DemoBuildAtlas;
//		Demo = DemoLoadAtlas;

		var starling:Starling = new Starling( Demo, stage, new Rectangle( 0, 0, stage.stageWidth, stage.stageHeight ) );

		starling.simulateMultitouch = false;
		starling.enableErrorChecking = Capabilities.isDebugger;
		starling.supportHighResolutions = true;
		starling.stage.color = 0xFFFFFF;
		// adjust to macbook retina display @2x
		var retinaFactor:Number = starling.supportHighResolutions ? stage.contentsScaleFactor : 1 ;
		starling.stage.stageWidth = starling.viewPort.width * retinaFactor;
		starling.stage.stageHeight = starling.viewPort.height * retinaFactor ;
		starling.showStats = true;
		starling.showStatsAt( "left", "bottom" );
		starling.start();

		// keep the canvas centered.
		stage.addEventListener( Event.RESIZE, function ( e:Event ):void {
			starling.viewPort.x = Math.max( stage.stageWidth - starling.viewPort.width >> 1, 0 );
			starling.viewPort.y = Math.max( stage.stageHeight - starling.viewPort.height >> 1, 0 );
		} );

		NativeApplication.nativeApplication.addEventListener( Event.ACTIVATE, function ( e:Event ):void {
			starling.start();
		} );
		NativeApplication.nativeApplication.addEventListener( Event.DEACTIVATE, function ( e:Event ):void {
			starling.stop();
		} );

	}
}
}
