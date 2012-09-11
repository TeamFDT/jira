/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: 
 * Version 	  	: 
 * Description 	: 
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti
 * Date 		: 
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
package com.kurst.video {
	import com.kurst.events.YouTubePlayerEvents;

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.Security;

	public class YouTubePlayer extends Sprite {
		private var playerInit : Boolean = false;
		private var playerReady : Boolean = false;
		private var initSizeFlag : Boolean = false;
		private var player : Object;
		private var loader : Loader;
		private var _autoPlay : Boolean = true;
		private var _startSeconds : Number = 0;
		private var _suggestedQuality : String = 'highres';
		private var _videoID : String = '';
		private var _backgroundColour : Number = 0x000000;
		private var _backgroundAlpha : Number = 1;
		private var _useChrome : Boolean = true;
		private var background : Sprite;
		private var defaultSize : Object = {width:640, height:390};

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function YouTubePlayer() {
			Security.allowDomain("www.youtube.com");

			background = new Sprite();
			addChild(background);

			updateBackround();
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// Player Controls
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function setSize(width : Number, height : Number) : void {
			defaultSize.width = width;
			defaultSize.height = height;

			if ( playerReady ) {
				player.setSize(width, height)
			} else {
				initSizeFlag = true;
			}

			updateBackround();
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function loadVideoById(id : String, autoPlay : Boolean = true, startSeconds : Number = 0, suggestedQuality : String = 'highres') : void {
			_autoPlay = autoPlay;
			_suggestedQuality = suggestedQuality;
			_startSeconds = startSeconds;
			_videoID = id;

			if ( !playerInit ) {
				initPlayer(id)
				return;
			}

			if ( playerReady ) {
				if ( _autoPlay ) {
					player.loadVideoById(_videoID, 0, _suggestedQuality)
				} else {
					player.cueVideoById(_videoID, 0, _suggestedQuality);
				}
			}
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function destroy() : void {
			if ( contains(loader))
				removeChild(loader);

			loader.content.removeEventListener("onReady", onPlayerReady);
			loader.content.removeEventListener("onError", onPlayerError);
			loader.content.removeEventListener("onStateChange", onPlayerStateChange);
			loader.content.removeEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);

			loader.contentLoaderInfo.removeEventListener(Event.INIT, onLoaderInit);

			player.destroy()
			player = null;
		}

		// Playback Controls
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function playVideo() : void {
			if ( !playerReady ) return ;
			player.playVideo();
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function pauseVideo() : void {
			if ( !playerReady ) return ;
			player.pauseVideo();
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function stopVideo() : void {
			if ( !playerReady ) return ;
			player.stopVideo();
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function seekTo(seconds : Number, allowSeekAhead : Boolean) : void {
			if ( !playerReady ) return ;
			player.seekTo(seconds, allowSeekAhead);
		}

		// Volume Controls
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function mute() : void {
			if ( !playerReady ) return ;
			player.mute()
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function unMute() : void {
			if ( !playerReady ) return ;
			player.unMute()
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function isMuted() : Boolean {
			if ( !playerReady ) return false;
			return player.isMuted()
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function setVolume(volume : Number) : void {
			if ( !playerReady ) return ;
			player.setVolume(volume);
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function getVolume() : Number {
			if ( !playerReady ) return NaN;
			return player.getVolume()
		}

		// Video information
		/**
		 * Returns the duration in seconds of the currently playing video. Note that getDuration() 
		 * will return 0 until the video's metadata is loaded, which normally happens just after the video starts playing.
		 * 
		 * @param
		 * @return
		 */
		public function getDuration() : Number {
			if ( !playerReady ) return NaN;
			return player.getDuration()
		}

		/**
		 * Returns the YouTube.com URL for the currently loaded/playing video.
		 * 
		 * @param
		 * @return
		 */
		public function getVideoUrl() : String {
			if ( !playerReady ) return null ;
			return player.getVideoUrl()
		}

		/**
		 * Returns the embed code for the currently loaded/playing video.
		 * 
		 * @param
		 * @return
		 */
		public function getVideoEmbedCode() : String {
			if ( !playerReady ) return null;
			return player.getVideoEmbedCode()
		}

		// Playback status
		/**
		 * Returns the number of bytes loaded for the current video.
		 * 
		 * @param
		 * @return
		 */
		public function getVideoBytesLoaded() : Number {
			if ( !playerReady ) return NaN;
			return player.getVideoBytesLoaded()
		}

		/**
		 * Returns the size in bytes of the currently loaded/playing video.
		 * 
		 * @param
		 * @return
		 */
		public function getVideoBytesTotal() : Number {
			if ( !playerReady ) return NaN;
			return player.getVideoBytesTotal()
		}

		/**
		 * Returns the number of bytes the video file started loading from. Example scenario: the user seeks ahead to a point that hasn't loaded yet, 
		 * and the player makes a new request to play a segment of the video that hasn't loaded yet.
		 * 
		 * @param
		 * @return
		 */
		public function getVideoStartBytes() : Number {
			if ( !playerReady ) return NaN;
			return player.getVideoStartBytes()
		}

		/**
		 *  Returns the state of the player. Possible values are unstarted (-1), ended (0), playing (1), paused (2), buffering (3), video cued (5).
		 * 
		 * @param
		 * @return
		 */
		public function getPlayerState() : Number {
			if ( !playerReady ) return NaN;
			return player.getPlayerState()
		}

		/**
		 * Returns the elapsed time in seconds since the video started playing.
		 * 
		 * @param
		 * @return
		 */
		public function getCurrentTime() : Number {
			if ( !playerReady ) return NaN;
			return player.getCurrentTime()
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function updateBackround() : void {
			background.graphics.beginFill(_backgroundColour, _backgroundAlpha)
			background.graphics.drawRect(0, 0, defaultSize.width, defaultSize.height);
			background.graphics.endFill();
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function initPlayer(id : String) : void {
			if ( playerInit ) return;

			playerInit = true;
			loader = new Loader();

			loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit, false, 0, true);

			var urlRQ : URLRequest

			if ( !_useChrome ) {
				urlRQ = new URLRequest("http://www.youtube.com/apiplayer?version=3");
			} else {
				urlRQ = new URLRequest("http://www.youtube.com/v/" + id + "?version=3");
			}

			loader.load(urlRQ);
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -GET/SET----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// Player Settings
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get useChrome() : Boolean {
			return _useChrome;
		}

		public function set useChrome(useChrome : Boolean) : void {
			_useChrome = useChrome;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get autoPlay() : Boolean {
			return _autoPlay;
		}

		public function set autoPlay(autoPlay : Boolean) : void {
			_autoPlay = autoPlay;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get videoID() : String {
			return _videoID;
		}

		public function set videoID(videoID : String) : void {
			_videoID = videoID;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get backgroundColour() : Number {
			return _backgroundColour;
		}

		public function set backgroundColour(backgroundColour : Number) : void {
			_backgroundColour = backgroundColour;
			updateBackround();
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get backgroundAlpha() : Number {
			return _backgroundAlpha;
		}

		public function set backgroundAlpha(backgroundAlpha : Number) : void {
			_backgroundAlpha = backgroundAlpha;
			updateBackround();
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function onLoaderInit(event : Event) : void {
			addChild(loader);
			// loader.content.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);

			/*
			loader.content.addEventListener(Event.COMPLETE, completeHandler);
			loader.content.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);

			loader.content.addEventListener(Event.OPEN, openHandler);
			loader.content.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.content.addEventListener(Event.UNLOAD, unLoadHandler);
			 */

			loader.content.addEventListener("onReady", onPlayerReady, false, 0, true);
			loader.content.addEventListener("onError", onPlayerError, false, 0, true);
			loader.content.addEventListener("onStateChange", onPlayerStateChange, false, 0, true);
			loader.content.addEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange, false, 0, true);
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function onPlayerReady(event : Event) : void {
			// Event.data contains the event parameter, which is the Player API ID

			playerReady = true;
			player = loader.content;

			loadVideoById(_videoID, _autoPlay, _startSeconds, _suggestedQuality)

			if ( initSizeFlag ) {
				initSizeFlag = false;
				setSize(defaultSize.width, defaultSize.height);
			}
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function onPlayerError(event : Event) : void {
			
			// Event.data contains the event parameter, which is the error code
			// trace( "player error:" , Object( event ).data );
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function onPlayerStateChange(event : Event) : void {
			// Event.data contains the event parameter, which is the new player state
			// trace( "player state:" , Object( event ).data );

			// unstarted (-1), ended (0), playing (1), paused (2), buffering (3), video cued (5)

			switch ( Object(event).data ) {
				case 0:
					// ended
					dispatchEvent(new YouTubePlayerEvents(YouTubePlayerEvents.VIDEO_COMPLETE))
					break;
				case 1:
					// playing
					dispatchEvent(new YouTubePlayerEvents(YouTubePlayerEvents.VIDEO_PLAYING))
					break;
				case 2:
					// paused
					dispatchEvent(new YouTubePlayerEvents(YouTubePlayerEvents.VIDEO_PAUSED))
					break;
				case 3:
					// buffering
					dispatchEvent(new YouTubePlayerEvents(YouTubePlayerEvents.VIDEO_BUFFERING))
					break;
				case 5:
					// video cued
					dispatchEvent(new YouTubePlayerEvents(YouTubePlayerEvents.VIDEO_CUED))
					break;
			}
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function onVideoPlaybackQualityChange(event : Event) : void {
			
			// Event.data contains the event parameter, which is the new video quality
			// trace( "video quality:" , Object( event ).data );
		}
	}
}