package com.kurst.events {
	import flash.events.Event;

	public class YouTubePlayerEvents extends Event {
		public static const VIDEO_COMPLETE : String = 'YouTubePlayerEvents_VIDEO_COMPLETE'
		public static const VIDEO_PLAYING : String = "YouTubePlayerEvents_VIDEO_PLAYING";
		public static const VIDEO_PAUSED : String = "YouTubePlayerEvents_VIDEO_PAUSED";
		public static const VIDEO_BUFFERING : String = "YouTubePlayerEvents_VIDEO_BUFFERING";
		public static const VIDEO_CUED : String = "YouTubePlayerEvents_VIDEO_CUED";

		public function YouTubePlayerEvents(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
