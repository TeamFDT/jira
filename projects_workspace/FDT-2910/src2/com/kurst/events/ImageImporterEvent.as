package com.kurst.events {
	import com.kurst.air.data.ImageDataItem;

	import flash.events.Event;

	/**
	 * @author karim
	 */
	public class ImageImporterEvent extends Event {
		public static const PROGRESS : String = "ImageImporterEvent_PROGRESS";
		public static const COMPLETE : String = "ImageImporterEventCOMPLETE";
		public static const STATUS_UPDATE : String = "ImageImporterEvent_STATUS_UPDATE";
		public static const ENCODE_PROGRESS : String = "ENCODE_PROGRESS";
		public var total : int;
		public var progress : int;
		public var fileArray : Array;
		public var imageData : ImageDataItem;

		public function ImageImporterEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
