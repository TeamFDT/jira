/********************************************************************************************************************************************************************************
* 
* Class Name  	: com.kurst.video.StagePlayer
* Version 	  	: 1
* Description 	: StageVideo / Video player (optimised for mobile and desktop)
* 
********************************************************************************************************************************************************************************
* 
* Author 		: Karim Beyrouti
* Date 			: 02/07/12
* 
********************************************************************************************************************************************************************************
* 
* METHODS
* 
*		stopVideoAirMobile()				: void
*		loadVideo(uri : String) 			: void
*		playVideo() 						: void
*		stopVideo() 						: void
*		seekPercent ( percent : Number ) 	: void
*		seek( time : Number )				: void
*		pauseVideo( ) 						: void
*		dispose() 							: void
* 
* PROPERTIES
* 
*		volume 								: Number (get/set)
*		totalTime 							: Number (get)
*		videoHeight 						: Number (get)
*		videoWidth 							: Number (get)
*		x 									: Number (get/set)
*		y 									: Number (get/set)
*		scaleToStage 						: Boolean (get/set)
*		debug 								: Boolean (get/set)
*		videoPlaying 						: Boolean (get)
*		videoPaused 						: Boolean (get)
*		videoStopped 						: Boolean (get)
*		autoPlay 							: Boolean (get/set)
*		autoLoop 							: Boolean (get/set)
*		videoProgress 						: Number (get)
*		bytesLoaded 						: Number (get)
*		bytesTotal 							: Number (get)
* 
* EVENTS
* 
* 		com.kurst.events.StagePlayerEvent.VIDEO_COMPLETE
* 		com.kurst.events.StagePlayerEvent.VIDEO_LOOP
* 		com.kurst.events.StagePlayerEvent.VIDEO_LOAD
* 		com.kurst.events.StagePlayerEvent.VIDEO_PLAY
* 		com.kurst.events.StagePlayerEvent.VIDEO_STOPPED
* 		flash.events.NetStatusEvent.NET_STATUS
* 
**********************************************************************************************************************************************************************************/


package com.kurst.video {
	

	/**
	 *
	 *
	 *
	 * 
	 */
	[Event(name="VIDEO_COMPLETE", type="com.kurst.events.StagePlayerEvent")]
	/**
	 *
	 *
	 *
	 * 
	 */
	[Event(name="VIDEO_LOOP", type="com.kurst.events.StagePlayerEvent")]
	/**
	 *
	 *
	 *
	 * 
	 */
	[Event(name="VIDEO_LOAD", type="com.kurst.events.StagePlayerEvent")]
	/**
	 *
	 *
	 *
	 * 
	 */
	[Event(name="VIDEO_PLAY", type="com.kurst.events.StagePlayerEvent")]
	/**
	 *
	 *
	 *
	 * 
	 */
	[Event(name="VIDEO_STOPPED", type="com.kurst.events.StagePlayerEvent")]
	/**
	 *
	 *
	 *
	 * 
	 */	
	[Event(name="NET_STATUS", type="flash.events.NetStatusEvent")]

	import flash.media.SoundTransform;
	import com.kurst.events.StagePlayerEvent;
	import com.kurst.controls.core.KurstUIComponentBase;

	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.events.StageVideoEvent;
	import flash.events.VideoEvent;
	import flash.geom.Rectangle;
	import flash.media.StageVideo;
	import flash.media.StageVideoAvailability;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class StagePlayer extends KurstUIComponentBase {

		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		// Debug
		
		private var _debug 				: Boolean 	= true;
		private var debugTxt 			: TextField;
		private var debugStr 			: String 	= new String();
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		// Video
				
		private var sv 					: StageVideo;
		private var nc 					: NetConnection;
		private var ns 					: NetStream;
		private var rc 					: Rectangle;
		private var video 				: Video;
		private var _soundTransform		: SoundTransform;
		
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		// Video State
				
		private var playing 			: Boolean;
		private var paused 				: Boolean = false;
		private var stopped				: Boolean = true;
		private var inited 				: Boolean;
		private var stageVideoInUse 	: Boolean;
		private var classicVideoInUse 	: Boolean;
		private var available 			: Boolean; // stage video available
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		// Rendering
	
		private var drawDirty 			: Boolean = false;
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		// Properties

		private var _scaleToStage 		: Boolean 	= false;
		private var _xpos 				: Number 	= 0;
		private var _ypos 				: Number 	= 0;
		private var _uri 				: String;
		private var _totalTime 			: Number;
		private var _videoWidth 		: int 		= 320;
		private var _videoHeight 		: int 		= 240;
		private var _videoFrameRate 	: Number;
		private var _autoPlay 			: Boolean 	= false;
		private var _autoLoop 			: Boolean 	= false;
		private var _defaultVolume 		: Number	= 1; 

		//------------------------------------------------------------------------------------------------------------------------------------------------------------

		public function StagePlayer() {
			
			_width 		= _videoWidth;
			_height 	= _videoHeight;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage , false ,0 , true );
			
		}

		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		//-PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------------------------------------------------------------------------------------

		/**
		* 
		* stopVideoAirMobile()
		* 
		* unload and stop the video.
		* Note: stop() has an android bug when app is deactivated:
		* https://bugbase.adobe.com/index.cfm?event=bug&id=3218132
		* 
		* This function circumvents that bug by hiding viewport / pausing NetStream
		* 
		*/
		public function stopVideoAirMobile() : void {
			
			if ( inited && !stopped ) {

				if ( stageVideoInUse ) {
					
					ns.pause();
					sv.viewPort = new Rectangle( stage.stageWidth , 0 ,width ,height );
					
				} else {
					
					ns.close();
					initVideoObject();
					
				}
				
				dispatchEvent( new StagePlayerEvent( StagePlayerEvent.VIDEO_STOPPED ) );
				
			}
			
		}
		/**
		* 
		* loadVideo(uri : String)
		* 
		* load a video, and start playing it is autoPlay == true;
		* 
		* 
		* @param uri : String - path to video
		*/
		public function loadVideo(uri : String) : void {
			
			this._uri 	= uri;
			
			stopped 	= false;
			playing		= autoPlay;
			paused		= ! autoPlay;
			
			if ( inited ) {
					
				toggleStageVideo( stageVideoInUse );
				dispatchEvent( new StagePlayerEvent( StagePlayerEvent.VIDEO_LOAD ) );
				
			}
			
		}
		/**
		* 
		* playVideo()
		* 
		* play a video / resume from pause
		* 
		*/
		public function playVideo() : void {
			
			if ( inited ) {
						
				paused	= false;
				playing = true;		
				stopped = false;
				ns.resume();
				dispatchEvent( new StagePlayerEvent( StagePlayerEvent.VIDEO_PLAY ) );
				
			}
		}
		/**
		* 
		* stopVideo()
		* 
		* unload and stop the video.
		* Note: stop() has an android bug when app is deactivated:
		* https://bugbase.adobe.com/index.cfm?event=bug&id=3218132
		* 
		*/
		public function stopVideo() : void {
			
			_uri = null;
			
			if ( inited && !stopped ) {
				
				paused	= false;
				playing = false;	
				stopped = true;
								
				if ( stageVideoInUse ) {
					
					
					sv.viewPort = new Rectangle( stage.stageWidth , 0 ,width ,height );
					sv.attachNetStream( null );
					ns.close();
					nc.close();
					
				} else {
					
					ns.close();
					initVideoObject();
					
				}
				
				dispatchEvent( new StagePlayerEvent( StagePlayerEvent.VIDEO_STOPPED ) );
				
			}
			
		}
		/**
		* 
		* seekPercent ( percent : Number ) : void
		* 
		* seek / scrub the video 
		* 
		* @param percent : Number - percent totalTime to seek to 
		*/
		public function seekPercent ( percent : Number ) : void {
			
			if ( inited ){
				 
				ns.seek( _totalTime * percent);
				
			}
			
		}
		/**
		* 
		* seek( time : Number ): void
		* 
		* seek to video
		* @param time : Number - time in seconds
		*/
		public function seek( time : Number ): void {
			
			if ( inited ) {
				
				ns.seek( time );
				
			}
			
		}
		/**
		* 
		*  pauseVideo( ) : void
		*  
		*  pause the video
		*  
		*/
		public function pauseVideo( ) : void {
			
			if ( inited ) {
				
				playing = false;
				paused	= true;
				stopped = false;
				ns.pause();
				
			}
		}
		/**
		* 
		* dispose()
		* 
		* dispose of the video player
		* Note: triggers a android bug when app is deactivated:
		* https://bugbase.adobe.com/index.cfm?event=bug&id=3218132
		* 
		*/
		public function dispose() : void {
			
			graphics.clear();
			
			stopVideo();
			
			if ( sv && ns ){
				
				ns.close();
				nc.close();
					
			}
			
			if ( ns ) {
				
				ns.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				nc.close();
				ns.client = new Object();
				nc = null;
				
			}

			if ( nc ) {

				nc.connect( null );
				nc.close();
				nc = null;
				
			}

			
			if ( video ){
				
				if ( contains( video )){
					
					removeChild( video );
					
				}
				
				video.removeEventListener(VideoEvent.RENDER_STATE, videoStateChange ) ;
				video.attachNetStream( null );
				video.clear();
				video = null;
				
			}

			if ( sv ){
				
				sv.removeEventListener(StageVideoEvent.RENDER_STATE, stageVideoStateChange );
				sv.attachNetStream( null );
				sv = null;

			}

			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage );
			removeEventListener( Event.ENTER_FRAME, onInvalidateFrameEvent );
						
			if ( stage ){
				
				stage.removeEventListener( Event.RESIZE , onResize );
				stage.removeEventListener( StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY , onStageVideoState );
				
			}
			
			if ( debugTxt )  {
				
				removeChild(debugTxt);
				debugTxt = null;
				
			}
			
			rc 		= null;
			_uri 	= null;
						
		}
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		//-PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------------------------------------------------------------------------------------

		/**
		* 
		* updateDebugTxt( str : String ) : void
		* update debug textfield
		* 
		*/
		private function updateDebugTxt( str : String ) : void {
			
			debugStr += str;
			
			if ( debugTxt && stage ){
				
				debugTxt.x = stage.stageWidth - debugTxt.width;
				debugTxt.text = debugStr;
				
			}
					
		}
		/**
		* 
		* resize the video
		* 
		*/
		private function resize() : void {
			
			if ( ! drawDirty ) {
				
				drawDirty = true;
				addEventListener( Event.ENTER_FRAME, onInvalidateFrameEvent , false ,0 , true );
				
			}

				
		}
		/**
		* 
		* draw the component / override from KurstUiComponent
		* 
		*/
		override protected function draw() : void {
			
			if ( !_scaleToStage )
				resize();
			
		}
		/**
		* 
		* intialise the debug textfield
		* 
		*/
		private function initDebugTextfield() : void {
			
			if ( !debugTxt ) {
				
				debugTxt = new TextField();
				debugTxt.autoSize = TextFieldAutoSize.LEFT;

				// Debug infos
				debugTxt.multiline = true;
				debugTxt.background = true;
				debugTxt.backgroundColor = 0xFFFFFFFF;
				debugTxt.x = 0;
				debugTxt.y = 0;
				addChild(debugTxt);
			}
			
		}
		/**
		 * 
		 * Get video size
		 * 
		 * @param width
		 * @param height
		 * @return Rectangle - size / position of StageVideo viewport or Video
		 * 
		 */
		private function getVideoRect( vwidth : Number, vheight : Number ) : Rectangle {
			
			var videoRect : Rectangle = new Rectangle();
			
			if ( _scaleToStage ) {

				var _vWidth 	: Number = vwidth;
				var _vHeight 	: Number = vheight;
				var scaling 	: Number = Math.min(stage.stageWidth / _videoWidth, stage.stageHeight / _videoHeight);
	
				_vWidth 		*= scaling;
				_vHeight 		*= scaling;
	
				var posX 		: Number = ( stage.stageWidth - _vWidth )  / 2;
				var posY 		: Number = ( stage.stageHeight - _vHeight ) / 2;

				videoRect.x 		= posX;
				videoRect.y 		= posY;
				videoRect.width 	= _vWidth;
				videoRect.height 	= _vHeight;
			
			} else {
				
				videoRect.x 		= _xpos;
				videoRect.y 		= _ypos;
				videoRect.width 	= _width;
				videoRect.height 	= _height;
				
			}
			
			return videoRect;

		}
		/**
		* 
		* Resize invalidation
		* 
		*/
		private function invalidateResize() : void {
			
			if ( drawDirty ) {
								
				if ( stageVideoInUse && sv ) {
					
					rc = getVideoRect(sv.videoWidth, sv.videoHeight);// Get the Viewport viewable rectangle
					
					if ( sv )
						sv.viewPort = rc;// set the StageVideo size using the viewPort property
					
					//trace( rc );
				} else if ( ! stageVideoInUse ){
					
					rc = getVideoRect(video.videoWidth, video.videoHeight);
					
					if ( video ){
						
						video.width 	= rc.width;// Get the Viewport viewable rectangle
						video.height 	= rc.height;// Set the Video object size
						video.x 		= rc.x;
						video.y 		= rc.y;
						
					}
				}
				
				if ( debug ) {
					
					graphics.clear();
					graphics.beginFill(0xff0000 , .25);
					graphics.lineStyle( 1 , 0xffffff );
					graphics.drawRect(rc.x, rc.y, rc.width - 2, rc.height );
					graphics.endFill();
					
					if ( debugTxt ){
						
						debugTxt.x = stage.stageWidth - debugTxt.width;
					}

				}
			
				drawDirty = false;
								
			}
			
		}
		/**
		* 
		* toggleStageVideo
		* 
		* @param on : Boolean - flag to enable / disable StageVideo
		*/
		private function toggleStageVideo( on : Boolean ) : void {
					
			
				
			if ( _debug ) {
				debugStr = '';
				updateDebugTxt( "StageVideo Running (Direct path) : " + on + "\n" );
				
			}
			
			if ( on ) {// If we choose StageVideo we attach the NetStream to StageVideo
				
				stageVideoInUse = true;

				if ( sv == null ) {
					
					sv = stage.stageVideos[0];
					sv.addEventListener(StageVideoEvent.RENDER_STATE, stageVideoStateChange , false , 0 , true );

				}
				
				sv.attachNetStream( ns );

				if ( classicVideoInUse ) {
					
					// If we use StageVideo, we just remove from the display list the Video object to avoid covering the StageVideo object (always in the background)
					this.removeChild( video );
					classicVideoInUse = false;
					
				}
				
				
			} else {
				
				if ( stageVideoInUse )// Otherwise we attach it to a Video object
					stageVideoInUse = false;

				classicVideoInUse = true;

				video.attachNetStream( ns );
				this.addChildAt( video, 0 );
				
			}
			
			if ( _uri != null ) {
				
						
				ns.close();
				ns.play( _uri );
				
				resize();
				
			}
		}
		/**
		* 
		* intialise the traditional video object
		* 
		*/
		private function initVideoObject() : void {
			
			if ( video ) {

				video.attachNetStream(null);
				video.clear();
				video.removeEventListener(VideoEvent.RENDER_STATE, videoStateChange ) ;				
			
				if ( this.contains( video )) {
					
					this.removeChild( video );
					
				}
				
				video = null;
				
			}

			video 			= new Video();
			video.smoothing = true;
			video.addEventListener(VideoEvent.RENDER_STATE, videoStateChange, false ,0 , true );// in case of fallback to Video, we listen to the VideoEvent.RENDER_STATE event to handle resize properly and know about the acceleration mode running

		}
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		//-GET/SET----------------------------------------------------------------------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------------------------------------------------------------------------------------

		/**
		 * 
		 * set video volume
		 * 
		 */
		public function get volume() : Number {
			
			if ( _soundTransform ) {
				
				return _soundTransform.volume;
				
			} 
			
			return _defaultVolume;
			
		}
		public function set volume( vol : Number ) : void {

			if ( _soundTransform ) {
				
				_soundTransform.volume = vol;
				
				if ( ns ){
					
					ns.soundTransform = _soundTransform;
					
				}
				
			} else {
				
				_defaultVolume = vol;
				
			}
						
		}
		/**
		 * 
		 * total time of video in seconds
		 * 
		 */
		public function get totalTime() : Number {
		
			return _totalTime;
		
		}
		/**
		 * 
		 * intial width / height of video
		 *  
		 */
		public function get videoWidth() : int {
		
			return _videoWidth;
		
		}
		public function get videoHeight() : int {
			
			return _videoHeight;
		
		}
		/**
		 * 
		 * x position of video on stage. overriden for StageVideo
		 *  
		 */
		override public function get x() : Number {
		
			return _xpos;
		
		}
		override public function set x(xp : Number) : void {
		
			_xpos = xp;
			draw();
		
		}
		/**
		 * 
		 * y position of video on stage. overriden for StageVideo
		 * 
		 */
		override public function get y() : Number {
		
			return _height;
		
		}
		override public function set y( yp : Number) : void {
		
			_ypos = yp;
			draw();
		
		}
		/**
		* 
		* automatically scale the video to fill the stage
		* 
		*/
		public function get scaleToStage() : Boolean {
			
			return _scaleToStage;
		
		}
		public function set scaleToStage(scaleToStage : Boolean) : void {
			
			_scaleToStage = scaleToStage;
			
			if ( stage ) {
				
				if ( _scaleToStage ) {
					
					stage.addEventListener(Event.RESIZE, onResize , false , 0 , true );
					
				} else {
					
					stage.removeEventListener(Event.RESIZE, onResize );
					
				}
				
			}
		}
		/**
		* 
		* show debug information and intended video position 
		* 
		*/
		public function get debug() : Boolean {
		
			return _debug;
		
		}
		public function set debug(debug : Boolean) : void {
			
			_debug = debug;
		
		}
		/**
		* 
		* video play state
		* 
		*/
		public function get videoPlaying() : Boolean {
			
			return playing;
			
		}
		/**
		* 
		* video paused state
		*  
		*/
		public function get videoPaused() : Boolean {
			
			return paused;
			
		}
		/**
		* 
		* video stopped state
		* 
		*/
		public function get videoStopped() : Boolean {
			
			return stopped;
			
		}
		/**
		* 
		* auto play on load ( Note false: does no work on iOS ) 
		* 
		*/
		public function get autoPlay() : Boolean {
			return _autoPlay;
		}
		public function set autoPlay(autoPlay : Boolean) : void {
			_autoPlay = autoPlay;
		}
		/**
		* 
		* auto loop the video on complete
		* 
		*/
		public function get autoLoop() : Boolean {
			return _autoLoop;
		}
		public function set autoLoop(autoLoop : Boolean) : void {
			_autoLoop = autoLoop;
		}
		/**
		* 
		* play progress of current video in percentage of total time
		* 
		*/
		public function get videoProgress() : Number {
			
			if ( ! ns )
				return 0;
				
 			return ns.time / totalTime;
 
		}
		/**
		* 
		* 
		* 
		*/
		public function get bytesLoaded() : Number {
			
			if ( ns )
				return ns.bytesLoaded
				
			return 0;
			
		}
		/**
		* 
		* 
		* 
		*/		
		public function get bytesTotal() : Number {
			
			if ( ns )
				return ns.bytesTotal;
				
			return 0;
			
		}
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		//-EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------------------------------------------------------------------------------------

		/**
		* 
		* invalidation frame
		* 
		*/
		private function onInvalidateFrameEvent( event : Event ) : void {
			
			invalidateResize();
			removeEventListener( Event.ENTER_FRAME, onInvalidateFrameEvent );
			
		}
		/**
		* 
		*  
		*/
		private function onAddedToStage(event : Event) : void {
			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			if ( _debug )
				initDebugTextfield();

			nc = new NetConnection();
			nc.connect(null);

			_soundTransform = new SoundTransform();
			_soundTransform.volume = _defaultVolume;

			ns 			= new NetStream(nc);
			ns.client 	= this;
			ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			ns.soundTransform = _soundTransform;

			initVideoObject();
			
			stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoState , false ,0 , true );// the StageVideoEvent.STAGE_VIDEO_STATE informs you if StageVideo is available or not
			
			if ( scaleToStage )
				stage.addEventListener(Event.RESIZE, onResize , false , 0 , true );

		}
		/**
		* 
		*  
		*/
		private function onNetStatus(event : NetStatusEvent) : void {
			
			if ( stopped ) return;
			
			switch ( event.info.code ) {
				
				case 'NetStream.Play.Start' : 
				
					
					if ( ! _autoPlay ){
						
						ns.pause();

						playing = false;
						paused 	= true;
												
					} else {
						
						playing = true;
						paused 	= false;
						
					}
										
					break;
					
				case 'NetStream.Buffer.Full' : 
					
					break;
					
				case 'NetStream.Play.StreamNotFound' : 
					break;
					
				case 'NetStream.Buffer.Flush' : 
					break;
					
				case 'NetStream.Play.Stop' : 
					break;
					
				case 'NetStream.Buffer.Empty' :
				 
					
					break;

					
					
			}

			dispatchEvent( event.clone() );

		}
		/**
		* 
		* 
		* @param
		* @return
		*/
		public function onMetaData(evt : Object) : void {
			
			_videoWidth 			= evt.width;
			_videoHeight			= evt.height;
			_videoFrameRate 		= evt.videoframerate;
			_totalTime 				= evt.duration;
			
			if ( _scaleToStage ) {
				
				resize();
				
			}
			
		}
		/**
		* 
		* 
		* @param
		* @return
		*/
		public function onPlayStatus(evt : Object) : void {
			
			if ( evt.code == "NetStream.Play.Complete" ) {
			
				dispatchEvent( new StagePlayerEvent( StagePlayerEvent.VIDEO_COMPLETE ) );
					
				if ( _autoLoop && ns && ! stopped ) {
					
					ns.seek( 0 );
					dispatchEvent( new StagePlayerEvent( StagePlayerEvent.VIDEO_LOOP ) );
					
					
				}
			}
			
		}
		/**
		 * 
		 * @param event
		 * 
		 */
		private function onStageVideoState(event : StageVideoAvailabilityEvent) : void {
			
			toggleStageVideo( available = ( event.availability == StageVideoAvailability.AVAILABLE ) ); // Detect if StageVideo is available and decide what to do in toggleStageVideo
			inited = true;
			
		}
		/**
		* 
		* 
		* @param
		* @return
		*/
		private function onResize(event : Event) : void {
			
			resize();
			
		}
		/**
		* 
		* 
		* @param
		* @return
		*/
		private function stageVideoStateChange(event : StageVideoEvent) : void {
			
			////trace('stageVideoStateChange: ' + event.status);
			
			if ( _debug ) {
				
				updateDebugTxt( "StageVideoEvent received\n" )
				updateDebugTxt( "Render State : " + event.status + "\n" );
				
			}
			
			drawDirty = true;
			invalidateResize();
		}
		/**
		* 
		* 
		* @param
		* @return
		*/
		private function videoStateChange(event : VideoEvent) : void {

			if ( _debug ) {
				
				updateDebugTxt( "VideoEvent received\n" ) ;
				updateDebugTxt( "Render State : " + event.status + "\n" );
				
			}

			resize();
		}
		/**
		* 
		* Removed - saves resources - 
		* 
		* on enter frame event handler
		*  
		private function onFrame(event : Event) : void {
			
			var e : StagePlayerEvent = new StagePlayerEvent( StagePlayerEvent.VIDEO_FRAME );
				e.progress = ns.time / totalTime; 
			dispatchEvent( e );
			
			if ( debug && debugTxt )
				debugTxt.text = debugStr;
				
		}
		*/

		
	}
}
