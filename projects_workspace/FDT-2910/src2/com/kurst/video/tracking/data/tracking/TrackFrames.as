/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.video.tracking.data.tracking.TrackFrames
 * Version 	  	: 1
 * Description 	: Track data frames container
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti
 * Date 			: 07/11/11
 * 
 ********************************************************************************************************************************************************************************
 * 
 * METHODS
 * 
 * 	addFrameData( frame : int , xPos: Number , yPos: Number  ) : void
 * 	getFrameData( frame : int ) : TrackPoint 
 *
 **********************************************************************************************************************************************************************************/
package com.kurst.video.tracking.data.tracking {
	public class TrackFrames {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public var trackPointID : int;
		public var trackFrames : Vector.<TrackPoint>;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function TrackFrames() : void {
			trackFrames = new Vector.<TrackPoint>();
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * @method addFrame( frame : int , xPos: Number , yPos: Number  ) : void 
		 * @tooltip add a tracking frame 
		 * @param frame : int - id of frame
		 * @param xPos: Number - xPosition of tracking point
		 * @param yPos: Number - yPosition of tracking point
		 */
		public function addFrameData(frame : int, xPos : Number, yPos : Number) : void {
			trackFrames.push(new TrackPoint(frame, xPos, yPos));
		}

		/**
		 * @method getFrame( frame : int ) : TrackPoint
		 * @tooltip get tracking data for a frame
		 * @param frame : int - frame Number
		 * @return TrackPoint
		 */
		public function getFrameData(frame : int) : TrackPoint {
			if ( frame < 0 ) {
				return null;
			} else if ( frame > trackFrames.length - 1 ) {
				return null;
			} else {
				return trackFrames[frame];
			}
		}
	}
}