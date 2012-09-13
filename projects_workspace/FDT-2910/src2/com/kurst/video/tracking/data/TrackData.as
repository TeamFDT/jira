/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.video.tracking.data.TrackData
 * Version 	  	: 1
 * Description 	: Tracking data - container for all tracking data of a single object
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti 
 * Date 			: 07 / 11 / 11 
 * 
 ********************************************************************************************************************************************************************************
 * 
 * METHODS
 * 
 * 	getTotalFrames() : int
 * 	getNewTrackPointFrames( id : int ) : TrackFrames
 * 	getNewTrackScale( id : int ) : TrackScale
 * 	addTrackPointFrames( d : TrackFrames ) : void
 * 	addTrackScale( d : TrackScale ) : void
 * 	getTrackPointFrames( pointID : int ) : TrackFrames
 * 	getTrackPoints( frame : int ) : Vector.<TrackPoint> 
 *	getTrackPointXYScale( frame : int ) : Vector.<TrackPoint>
 * 	
 **********************************************************************************************************************************************************************************/
package com.kurst.video.tracking.data {
	import com.kurst.video.tracking.data.tracking.TrackFrames;
	import com.kurst.video.tracking.data.tracking.TrackPoint;
	import com.kurst.video.tracking.data.tracking.TrackScale;

	public class TrackData {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public var trackPoints : Vector.<TrackFrames>;
		public var trackScale : Vector.<TrackScale>;
		public var id : String;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function TrackData() {
			trackPoints = new Vector.<TrackFrames>();
			trackScale = new Vector.<TrackScale>();
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * @method getTotalFrames() : int
		 * @tooltip get the total number of frames in the animation
		 * @return int - number of frames
		 */
		public function getTotalFrames() : int {
			return trackPoints[0].trackFrames.length;
		}

		/**
		 * @method addTrackPointFrames( d : TrackFrames ) : void
		 * @tooltip add track point frames to the track points
		 * @param TrackFrames
		 */
		public function	addTrackPointFrames(d : TrackFrames) : void {
			trackPoints.push(d);
		}

		/**
		 * @method 
		 * @tooltip
		 * @param 
		 * @return
		 */
		public function addTrackScaleFrames(d : TrackScale) : void {
			trackScale.push(d);
		}

		/**
		 * @method getFourPointTrackFrameData( frame : int ) : Vector.<TrackPoint>
		 * @tooltip get tracking points for a specific frame
		 * @param frame : Int
		 * @return Vector.<TrackPoint> - four tracking points for transformation
		 */
		public function getFourPointTrackFrameData(frame : int) : Vector.<TrackPoint> {
			var result : Vector.<TrackPoint> = new Vector.<TrackPoint>();

			for ( var c : int = 0 ; c < trackPoints.length ; c++ )
				result.push(trackPoints[c].getFrameData(frame));

			return result;
		}

		/**
		 * @method 
		 * @tooltip 
		 * @param 
		 * @return 
		 */
		public function getXYScaleTrackFrameData(frame : int) : Vector.<TrackPoint> {
			var result : Vector.<TrackPoint> = new Vector.<TrackPoint>();

			for ( var c : int = 0 ; c < trackPoints.length ; c++ )
				result.push(trackPoints[c].getFrameData(frame));

			if ( trackScale.length >= 1 )
				result.push(trackScale[0].getScaleData(frame));

			return result;
		}
	}
}