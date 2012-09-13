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
	import com.kurst.video.tracking.data.Tracker;
	import com.kurst.video.tracking.data.tracking.TrackPoint;
	import com.zehfernando.display.drawPlane;

	import flash.geom.Point;

	public class FourPointRenderer extends RendererBase implements IRenderer {
		private var pt1 : Point;
		private var pt2 : Point;
		private var pt3 : Point;
		private var pt4 : Point;

		// private var _debug 						: Boolean = false;
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
		override public function init(_timelineData : Tracker) : void {
			super.init(_timelineData);

			pt1 = new Point();
			pt2 = new Point();
			pt3 = new Point();
			pt4 = new Point();
		}

		/**
		 * 
		 * render(frame : int) : void 
		 * 
		 * @param
		 * @return
		 */
		override public function render(frame : int) : void {
			var points : Vector.<TrackPoint> = trackData.getFourPointTrackFrameData(frame);

			if ( points[0] != null ) {
				pt1.x = ( points[0].x * timelineData.scaleX ) + timelineData.xOffset;
				pt1.y = ( points[0].y * timelineData.scaleY ) + timelineData.yOffset;
				pt2.x = ( points[1].x * timelineData.scaleX ) + timelineData.xOffset;
				pt2.y = ( points[1].y * timelineData.scaleY ) + timelineData.yOffset;
				pt3.x = ( points[2].x * timelineData.scaleX ) + timelineData.xOffset;
				pt3.y = ( points[2].y * timelineData.scaleY ) + timelineData.yOffset;
				pt4.x = ( points[3].x * timelineData.scaleX ) + timelineData.xOffset;
				pt4.y = ( points[3].y * timelineData.scaleY ) + timelineData.yOffset;

				drawPlane(drawContainer.graphics, bitmapData, pt1, pt2, pt3, pt4);

				/*
				if ( timelineData.debug ){
					
				trace('frame: ' + frame );
					
				drawContainer.graphics.beginFill( 0xFF0000 );
				drawContainer.graphics.drawCircle( pt1.x, pt1.y, 2 );
					
				drawContainer.graphics.beginFill( 0x00FF00 );
				drawContainer.graphics.drawCircle( pt2.x, pt2.y, 2 );
					
				drawContainer.graphics.beginFill( 0x0000FF );
				drawContainer.graphics.drawCircle( pt3.x, pt3.y, 2 );
					
				drawContainer.graphics.beginFill( 0xFFFF00 );
				drawContainer.graphics.drawCircle( pt4.x, pt4.y, 2 );
					
				}
				// */
			}
		}

		/**
		 *  
		 * destroy() : void 
		 * 
		 * @param
		 * @return
		 */
		override public function destroy() : void {
			super.destroy();

			pt1 = null;
			pt2 = null;
			pt3 = null;
			pt4 = null;
		}
	}
}
