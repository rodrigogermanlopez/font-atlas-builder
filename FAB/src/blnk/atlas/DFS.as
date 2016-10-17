/**
 * Created by rodrigolopezpeker (7 interactive) on 10/13/16.
 *
 * DFS { DistanceFieldSampler }
 * Allows to generate DistanceField images out of bitmaps.
 *
 * Ported from: https://stackoverflow.com/questions/36530680/distance-transform-implementation
 *
 */
package blnk.atlas {
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Rectangle;

public class DFS {

	// this value is used as a ratio to downscale the output image.
	// higher values returns smaller DFI (Distance field image)
	// An optimal ::spread value is ::downscale * 4.
	// 16 is more than enough for most cases, this value affects the processing time.
	public var downscale:Number = 8;

	// output color for the image, kinda pointless value as its preprocessed at
	// runtime and you have to color the Image, leave it as white.
	public var color:uint = 0xffffff;

	// spread value, this sort of "glow" defines the smoothness on the shader
	public var spread:int = 4;

	// onProgress(value) callback function.
	// When value == 1 process is complete
	public var onProgress:Function;

	// internal sprite used for progressive DF generation via enterFrame.
	private static var spr:Sprite;

	// output bitmapData
	public var result:BitmapData;

	// output percentage progress and complete message.
	public var verbose:Boolean = true;

	// max number for loop per frame, during coordinates storage (inside/outside)
	// unless u're using a huge image with a huge downsampling, this "step" is pretty fast
	public var maxCoordenatesPixelsPerFrame:uint = 100000;

	// max number for loop per frame for pixel rendering, this routine calculates
	// the distance between pixels [findSignedDistance()] based on the spread value, so each loop has
	// multiple subs loops. This is the critical performance part.
	// decrease this number to get a smoother FPS
	public var maxRenderPixelsPerFrame:uint = 1000; // based on spread

	// allows to read the progress during the generation process.
	private var _progress:Number = 0;
	public function get progress():Number {
		return _progress;
	}

	private var processFun:Function;

	// Flag for pause state.
	private var _paused:Boolean;
	public function get paused():Boolean {
		return _paused;
	}

	/**
	 * Constructor.
	 */
	public function DFS() {
		if ( !spr ) spr = new Sprite();
	}

	/**
	 * Process the image into a distance field.
	 *
	 * The input image should be binary (black/white), but if not, see {@link #isInside(int)}.
	 *
	 * The returned image is a factor of {@code upscale} smaller than {@code inImage}.
	 * Opaque pixels more than {@link #spread} away in the output image from white remain opaque;
	 * transparent pixels more than {@link #spread} away in the output image from black remain transparent.
	 * In between, we get a smooth transition from opaque to transparent, with an alpha value of 0.5
	 * when we are exactly on the edge.
	 *
	 * @param source the BitmapData to process.
	 * @return the distance field image
	 */
	public function generate( source:BitmapData ):void {
		var bdW:int = source.width;
		var bdH:int = source.height;
		var targetW:int = bdW / downscale;
		var targetH:int = bdH / downscale;

		result = new BitmapData( targetW, targetH, true, 0x0 );
		var coords:Vector.<Boolean> = new Vector.<Boolean>( bdW * bdH );
		var pixels:Vector.<uint> = source.getVector( source.rect );

		var downscale2:Number = downscale / 2;
		var i:int = 0;
		var len:int = 0;
		var totalPixels:int = bdW * bdH;

		spr.addEventListener( "enterFrame", loop );

		var maxRenderPPF:uint = maxRenderPixelsPerFrame / spread;

		i = 0;
		_progress = 0;
		processCoords();

		function processCoords():void {
			len += maxCoordenatesPixelsPerFrame;
			if ( len > totalPixels ) len = totalPixels;
			for ( i; i < len; i++ ) {
				coords[i] = ( pixels[i] & 0x808080 ) != 0 && (pixels[i] & 0x80000000) != 0;
			}

			_progress = ( len / totalPixels ) * 0.25;
			if ( i >= totalPixels ) {
				pixels.length = 0;
				totalPixels = targetW * targetH;
				i = 0;
				len = 0;
				_progress = .25;
				processFun = processBitmap;
			} else {
				processFun = processCoords;
			}
			if( onProgress ) onProgress( _progress );
		}

		function processBitmap():void {
			len += maxRenderPPF;
			if ( len > totalPixels ) len = totalPixels;
			for ( i; i < len; ++i ) {
				var x:int = i % targetW;
				var y:int = i / targetW;
				var cx:int = x * downscale + downscale2;
				var cy:int = y * downscale + downscale2;
				var signedDistance:Number = findSignedDistance( cx, cy, coords, bdW, bdH );
				var alpha:Number = .5 + .5 * (signedDistance / spread);
				alpha = alpha < 0 ? 0 : ( alpha > 1 ? 1 : alpha );
//				if( alpha == 0 ) alpha = 1 ; // debug padding.
				result.setPixel32( x, y, (alpha * 0xff << 24) | color & 0xffffff );
			}
			_progress = 0.25 + ( len / totalPixels ) * 0.75;
			if ( i >= totalPixels ) {
				_progress = 1;
				processFun = null ;
				spr.removeEventListener( "enterFrame", loop );
				_paused = false ;
				if( verbose ) trace( "[DFS] Process complete" );
			} else {
//				trace( "next loop", i, len, totalPixels )
			}
			if( onProgress ) onProgress( _progress );
		}
	}

	private function loop( e:Event ):void {
		if ( processFun ) processFun();
		if ( verbose ) trace( "[DFS] process " + Math.round( _progress * 100 ) + "%" );
	}

	/**
	 * Resets the DFS instance for reuse
	 * stops the execution and disposes the output bitmapData.
	 */
	public function reset():void {
		stop() ;
		if( result ) result.dispose() ;
		_progress = 0 ;
	}

	/**
	 * Stops the bitmap generation, without disposing
	 * the instance, useful for partial preview.
	 */
	public function stop():void {
		processFun = null ;
		spr.removeEventListener( "enterFrame", loop );
	}

	/**
	 * Pauses the generation process
	 * Use paused to evaluate the current state.
	 */
	public function pause():void {
		spr.removeEventListener( "enterFrame", loop );
		_paused = true ;
	}

	/**
	 * Resumes the generation process after ::pause()
	 * Use paused to evaluate the current state.
	 */
	public function resume():void {
		if( _progress == 1 ){
			return ;
		}
		_paused = false ;
		if( processFun ){
			spr.addEventListener( "enterFrame", loop );
			processFun();
		}
	}


	/**
	 * Returns the signed distance for a given point.
	 *
	 * For points "inside", this is the distance to the closest "outside" pixel.
	 * For points "outside", this is the <em>negative</em> distance to the closest "inside" pixel.
	 * If no pixel of different color is found within a radius of {@code spread}, returns
	 * the {@code -spread} or {@code spread}, respectively.
	 *
	 * @param centerX the x coordinate of the center point
	 * @param centerY the y coordinate of the center point
	 * @param coords the array representation of an image, {@code true} representing "inside"
	 * @param w the width of the original bitmap
	 * @param h the height of the original bitmap
	 * @return the signed distance
	 */

	[Inline]
	private function findSignedDistance( centerX:int, centerY:int, coords:Vector.<Boolean>, w:int,
										 h:int ):Number {
		var baseVal:Boolean = coords[int( centerX + centerY * w )];
		var startX:int = centerX - spread;
		if ( startX < 0 ) startX = 0;
		var startY:int = centerY - spread;
		if ( startY < 0 ) startY = 0;
		var j:int, k:int;
		j = w - 1;
		k = centerX + spread;
		var endX:int = j < k ? j : k;
		j = h - 1;
		k = centerY + spread;
		var endY:int = j < k ? j : k;
		var closestSqDist:Number = spread * spread;
		for ( var y:int = startY; y <= endY; y++ ) {
			for ( var x:int = startX; x <= endX; x++ ) {
				var idx:int = int( x + y * w );
				if ( baseVal != coords[idx] ) {
					var sqDist:Number = (centerX - x) * (centerX - x) + (centerY - y) * (centerY - y);
					if ( sqDist < closestSqDist ) {
						closestSqDist = sqDist;
					}
				}
			}
		}
		var closestDist:Number = Math.sqrt( closestSqDist );
		return (baseVal ? 1 : -1) * (closestDist < spread ? closestDist : spread);
	}


	//===================================================================================================================================================
	//
	//      ------  UTILITIES
	//
	//===================================================================================================================================================
	public function generateFromDisplayObject( d:DisplayObject ):void {
		generate( printDisplayObject( d, downscale, spread ) );
	}

	public static function printDisplayObject( d:DisplayObject, scale:Number = 1, padding:uint=0 ):BitmapData {
		// remove filters.
		d.filters = null;
		var rect:Rectangle = d.getBounds( d );
		if ( rect.isEmpty() ) {
			trace( "[DFS] Error: can't print an empty DisplayObject" );
			return null;
		}
		var m:Matrix = new Matrix();
		var bd:BitmapData = new BitmapData( rect.width * scale * d.scaleX+ padding * 2, rect.height * scale * d.scaleY + padding * 2, false, 0x0 );
		m.translate( -rect.x, -rect.y );
		m.scale( scale*d.scaleX, scale*d.scaleY );
		m.translate( padding,padding );
		bd.draw( d, m );
		return bd;
	}

	/**
	 * Fix a black silhoutte inverting the colors.
	 * @param bd
	 * @return
	 */
	public static function invertBlackShape( bd:BitmapData ):BitmapData {
		bd.colorTransform( bd.rect, new ColorTransform( -1, -1, -1, 1, 255, 255, 255, 0 ) );
		return bd;
	}

}
}
