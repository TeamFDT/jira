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
package com.kurst.video.tracking.parsers {
	import com.kurst.video.tracking.data.TrackData;
	import com.kurst.video.tracking.data.tracking.TrackFrames;

	public class FourPointTrackingParser {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private static const MOTION_TRACK_HEADER : String = 'Motion Trackers';
		private static const MOTION_TRACK_LABEL : String = 'Frame';

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function FourPointTrackingParser() {
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public static function parse(d : String) : TrackData {
			var result : TrackData = new TrackData();
			var dLines : Array = d.split('\n');
			var row : String = '';
			var trackFrames : TrackFrames;
			var rFrames : Array;
			var trackDataID : int = 0;

			for ( var c : int = 0 ; c < dLines.length ; c++ ) {
				row = dLines[c];

				if ( row.indexOf(MOTION_TRACK_HEADER) != -1 ) {
					if ( trackFrames != null )
						result.addTrackPointFrames(trackFrames);

					trackFrames = new TrackFrames();
					trackFrames.trackPointID = trackDataID++;
				} else if ( row.indexOf(MOTION_TRACK_LABEL) == -1 ) {
					rFrames = row.split('\t');

					if ( rFrames.length > 1 )
						trackFrames.addFrameData(rFrames[1], rFrames[2], rFrames[3]);
				}
			}

			result.addTrackPointFrames(trackFrames);

			return result;
		}
	}
}