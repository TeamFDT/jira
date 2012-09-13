/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: 
 * Version 	  	: 
 * Description 	: 
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti
 * Date 			: 
 * 
 ********************************************************************************************************************************************************************************
 * 
 * METHODS
 * 
 *
 * PROPERTIES
 * 
 *
 * EVENTS
 * 
 * 
 ********************************************************************************************************************************************************************************
 * 				:
 *
 *
 *********************************************************************************************************************************************************************************
 * NOTES			:
 **********************************************************************************************************************************************************************************/
package com.kurst.video.tracking.renderer {
	import flash.display.PixelSnapping;

	import com.kurst.video.tracking.data.Tracker;
	import com.kurst.video.tracking.data.tracking.TrackPoint;

	import flash.display.Bitmap;

	public class XYSRenderer extends RendererBase implements IRenderer {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private var bitmap : Bitmap;
		private var _currentFrame : int = 1;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * init( _timelineData : TimelineDataItem ) : void
		 * 
		 * @param
		 * @return
		 */
		override public function init(timelineData : Tracker) : void {
			super.init(timelineData) ;

			drawContainer.addChild(bitmap = new Bitmap(bitmapData));
			drawContainer.cacheAsBitmap = true;

			bitmap.smoothing = true;

			render(_currentFrame);
		}

		/**
		 *  
		 * render(frame : int) : void
		 * 
		 * @param
		 * @return
		 */
		override public function render(frame : int) : void {
			var points : Vector.<TrackPoint> = trackData.getXYScaleTrackFrameData(frame);

			if ( points[0] != null ) {
				bitmap.x = ( points[0].x * timelineData.scaleX ) - ( bitmap.width / 2 ) + timelineData.xOffset;
				bitmap.y = ( points[0].y * timelineData.scaleY ) - ( bitmap.height / 2 ) + timelineData.yOffset;
			}

			if ( points.length > 1 ) {
				bitmap.scaleX = timelineData.contentScaleX * ( points[1].scaleX / 100 );
				bitmap.scaleY = timelineData.contentScaleY * ( points[1].scaleY / 100 );
			}

			_currentFrame = frame;
		}

		/**
		 *  
		 * destroy() : void
		 * 
		 * @param
		 * @return
		 */
		override public function destroy() : void {
			if ( drawContainer.contains(bitmap) )
				drawContainer.removeChild(bitmap);

			bitmap = null;

			super.destroy();
		}
	}
}
