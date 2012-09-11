/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.video.tracking.data.loading.TrackDataLoadItem
 * Version 	  	: 1
 * Description 	: Tracking data load item
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti
 * Date 			: 07/11/11
 * 
 ********************************************************************************************************************************************************************************
 * 
 **********************************************************************************************************************************************************************************/
package com.kurst.video.tracking.data.loading {
	import com.kurst.video.tracking.data.TrackData;
	import com.kurst.video.tracking.settings.TrackType;

	public class TrackDataLoadItem {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public var uri : String;
		// URI of tracking file to load
		public var id : String;
		// ID of tracking file
		public var strData : String;
		// Loaded via zip file - this is the data
		public var data : TrackData;
		// Track data
		public var type : String = TrackType.FOUR_POINT;
		// Tracking type - default is four point track
		public var filename : String;

		// filename ( for data loaded from ZIP file )
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function TrackDataLoadItem() {
		}
	}
}