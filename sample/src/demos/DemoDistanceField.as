/**
 *
 * Created by Rodrigo Lopez [blnk™] on 10/17/16.
 *
 */
package demos {

import blnk.atlas.DFS;

import flash.display.Bitmap;
import flash.display.Shape;

import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.styles.DistanceFieldStyle;
import starling.textures.Texture;

public class DemoDistanceField extends Sprite {

	/**
	 * Constructor.
	 */
	public function DemoDistanceField() {
		addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
	}

	private function onAddedToStage( event:Event ):void {
		removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );

		stage.color = 0x565656;

		// draw a Star shape using Flash Graphics API.
		var star:Shape = new Shape();
		var points:int = 5;
		var innerRadius:Number = 40;
		var outerRadius:Number = innerRadius + 30;
		var step:Number = (Math.PI * 2) / points;
		var halfStep:Number = step / 2;
		var start:Number = -Math.PI / 2 + Math.PI;
		star.graphics.beginFill( 0xff0000 );
		star.graphics.moveTo( x + (Math.cos( start ) * outerRadius), y - (Math.sin( start ) * outerRadius) );
		for ( var n:uint = 1; n <= points; ++n ) {
			var dx:Number = x + Math.cos( start + (step * n) - halfStep ) * innerRadius;
			var dy:Number = y - Math.sin( start + (step * n) - halfStep ) * innerRadius;
			star.graphics.lineTo( dx, dy );
			dx = x + Math.cos( start + (step * n) ) * outerRadius;
			dy = y - Math.sin( start + (step * n) ) * outerRadius;
			star.graphics.lineTo( dx, dy );
		}

		star.x = star.y = 100;

		// DFS consideres DisplayObject's scaleX,scaleY when sampling.
		// That makes it easier to create smaller images.
		star.scaleX = star.scaleY = 0.5;
		Starling.current.nativeOverlay.addChild( star );

		// -- Create a bitmap to display DFS output.

		// We can create the bitamp from the DisplayObject directly.
		//var bd:BitmapData = DFS.printDisplayObject(star, 2, 32) ;

		var bmp:Bitmap = new Bitmap();
//		bmp.bitmapData = bd ;
		Starling.current.nativeOverlay.addChild( bmp );
		bmp.x = star.x + star.width / 2 + 50;
		bmp.y = star.y - star.height / 2;

		var dfs:DFS = new DFS();
		dfs.verbose = true;
		dfs.downscale = 16;

		// spread has to be downscale.
		dfs.spread = dfs.downscale * 4;
		dfs.generateFromDisplayObject( star );

		// After calling dfs.generate() we have access to dfs.result (bitmapData), so we can preview
		// the process in realtime.
		bmp.bitmapData = dfs.result;
		bmp.scaleX = bmp.scaleY = dfs.downscale / 2; // preview the "pixels" generation at %50 of the sampling scale.

		dfs.onProgress = function ( p:Number ):void {
			if ( p == 1 ) {
				// return the bitmap to the original "size"
				bmp.scaleX = bmp.scaleY = 1;
				trace( "output bitmap size: " + dfs.result.width + "x" + dfs.result.height );

				var img:Image = new Image( Texture.fromBitmapData( dfs.result ) );
				img.x = bmp.x + bmp.width + 50;
				img.y = bmp.y;
				img.style = new DistanceFieldStyle();
				addChild( img );
				img.scale = 8;
				trace( img.width, img.height );
			}
		};

		// other useful API.
//		dfs.paused
//		dfs.reset() ;
//		dfs.pause();
//		dfs.resume();
//		dfs.stop();
	}
}
}
