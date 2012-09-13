/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: 
 * Version 	  	: 
 * Description 	: 
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: 
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
 * NOTES			: -default-background-color #000000
 **********************************************************************************************************************************************************************************/
package com.kurst.video.tracking {
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;

	import com.kurst.video.tracking.data.TrackData;
	import com.kurst.video.tracking.data.loading.TrackDataLoadItem;
	import com.kurst.video.tracking.events.TrackingEvent;
	import com.kurst.video.tracking.parsers.FourPointTrackingParser;
	import com.kurst.video.tracking.parsers.XYSParser;
	import com.kurst.video.tracking.settings.TrackType;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class TrackDataLoader extends EventDispatcher {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private static var trackDataLoadedItems : Vector.<TrackDataLoadItem>;
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private var trackDataLoadItems : Vector.<TrackDataLoadItem>;
		private var currentLoadItem : TrackDataLoadItem;
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private var _urlLoader : URLLoader;
		private var zipLib : FZip;
		private var zipLoadInfo : Vector.<TrackDataLoadItem>;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function TrackDataLoader() {
			trackDataLoadItems = new Vector.<TrackDataLoadItem>();

			if ( TrackDataLoader.trackDataLoadedItems == null )
				TrackDataLoader.trackDataLoadedItems = new Vector.<TrackDataLoadItem>();
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *
		 * load a zip file containing tracking data
		 * 
		 * @method loadZip( uri : String ) : void 
		 * @param uri of ZIP file
		 */
		public function loadZip(uri : String, zipFileLoadInfo : Vector.<TrackDataLoadItem> = null) : void {
			zipLoadInfo = zipFileLoadInfo;
			zipLib = new FZip();

			zipLib.load(new URLRequest(uri));
			zipLib.addEventListener(Event.COMPLETE, onZipLoadComplete, false, 0, true);
			zipLib.addEventListener(ProgressEvent.PROGRESS, onZipProgress, false, 0, true);
		}

		/**
		 *
		 * add an item to the load queue
		 * 
		 * @method addLoadItem( uri : String , id : String ) : void
		 * @param uri : String - uri of item to load
		 * @param id : String - id of item to load
		 */
		public function addLoadItem(uri : String, id : String, dataType : String = "FOUR_POINT"/*TrackType.FOUR_POINT*/) : void {
			var item : TrackDataLoadItem = new TrackDataLoadItem();
			item.uri = uri;
			item.id = id;
			item.type = dataType;

			trackDataLoadItems.push(item);
		}

		/**
		 *
		 * start loading the data 
		 *  
		 * @method startLoad()
		 */
		public function startLoad() : void {
			loadNextItem();
		}

		/**
		 * 
		 * get tracking data by ID
		 *  
		 * @method getTrackData( id : String ) : TrackData
		 * @param id : String - id of tracking data
		 * @return TrackData
		 */
		public function getTrackData(id : String) : TrackData {
			var result : TrackData;

			for ( var c : int = 0 ; c < TrackDataLoader.trackDataLoadedItems.length ; c++ ) {
				if ( TrackDataLoader.trackDataLoadedItems[c].id == id )
					result = TrackDataLoader.trackDataLoadedItems[c].data;
			}

			return result;
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *
		 * load the next item in the queue
		 *  
		 * @method loadNextItem() : void 
		 */
		private function loadNextItem() : void {
			if ( trackDataLoadItems.length > 0 ) {
				currentLoadItem = trackDataLoadItems.shift() as TrackDataLoadItem;

				if ( currentLoadItem.strData != null ) {
					parseData(currentLoadItem.strData);
				} else {
					if ( _urlLoader != null ) {
						_urlLoader.removeEventListener(Event.COMPLETE, onLoadComplete);
						_urlLoader = null;
					}

					_urlLoader = new URLLoader();
					_urlLoader.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
					_urlLoader.load(new URLRequest(currentLoadItem.uri));
				}
			} else {
				var e : TrackingEvent = new TrackingEvent(TrackingEvent.LOAD_COMPLETE);
				dispatchEvent(e);

				currentLoadItem = null;
			}
		}

		/**
		 *
		 * parse the tracking data
		 *  
		 * @method parseData( d : String ) : void 
		 * @tooltip 
		 * @param d : String - Tracking Data from AfterEffects
		 */
		private function parseData(d : String) : void {
			switch ( currentLoadItem.type ) {
				case TrackType.FOUR_POINT :
					currentLoadItem.data = FourPointTrackingParser.parse(d);
					break;
				case TrackType.XY_SCALE:
					currentLoadItem.data = XYSParser.parse(d);
					break;
			}

			TrackDataLoader.trackDataLoadedItems.push(currentLoadItem);

			var e : TrackingEvent = new TrackingEvent(TrackingEvent.LOAD_ITEM_COMPLETE);
			e.data = currentLoadItem.data;
			dispatchEvent(e);

			loadNextItem();
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -GET/SET----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *
		 * get Number of loaded Items
		 * 
		 * @method getNumberOfLoadedItems() : int
		 * @return int
		 */
		public function getNumberOfLoadedItems() : int {
			return TrackDataLoader.trackDataLoadedItems.length;
		}

		/**
		 *
		 * get track file information / ZIP load only
		 * 
		 * @method fileName : String
		 * @return TrackDataLoadItem 
		 */
		private function getFileInfo(fileName : String) : TrackDataLoadItem {
			if ( zipLoadInfo == null ) return null;
			var result : TrackDataLoadItem;

			for ( var c : int = 0 ; c < zipLoadInfo.length ; c++ ) {
				if ( zipLoadInfo[c].filename == fileName ) {
					result = zipLoadInfo[c];
					return result;
				}
			}

			return result;
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * 
		 * zip load progress event
		 * 
		 * @method onZipProgress
		 */
		private function onZipProgress(event : ProgressEvent) : void {
		}

		/**
		 * 
		 * zip load complete
		 *  
		 * @method onZipLoadComplete(event : Event) : void
		 */
		private function onZipLoadComplete(event : Event) : void {
			var l : uint = zipLib.getFileCount();

			for ( var o : uint = 0 ; o < l ; o++ ) {
				var file : FZipFile = zipLib.getFileAt(o);

				var item : TrackDataLoadItem = new TrackDataLoadItem();
				item.strData = file.getContentAsString();
				item.id = file.filename;

				var fileInfo : TrackDataLoadItem = getFileInfo(item.id) ;
				item.type = ( fileInfo == null ) ? TrackType.FOUR_POINT : fileInfo.type;

				trackDataLoadItems.push(item);
			}

			zipLoadInfo = null;
			startLoad();
		}

		/**
		 *
		 * load item / load complete
		 * 
		 * @method onLoadComplete(event : Event) : void 
		 */
		private function onLoadComplete(event : Event) : void {
			var str : String = _urlLoader.data as String;
			parseData(str);
		}
	}
}