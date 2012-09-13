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
	import com.kurst.events.eventDispatcher;
	import com.kurst.video.tracking.events.TrackingEvent;
	import com.kurst.video.tracking.core.TrackRenderer;
	import com.kurst.video.tracking.data.Tracker;
	import com.kurst.video.tracking.video.VideoUtils;

	import fl.video.FLVPlayback;

	import flash.display.MovieClip;

	public class TrackTimeline extends eventDispatcher {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private var _timeline : MovieClip;
		private var _tracks : Vector.<Tracker>;
		private var _activeTracks : Vector.<Tracker>;
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public var videoUtils : VideoUtils;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function TrackTimeline() {
			_tracks = new Vector.<Tracker>();
			_activeTracks = new Vector.<Tracker>();

			videoUtils = new VideoUtils();
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *
		 * get a track data item
		 *  
		 * @method getTrack( id : String ) : Tracker 
		 * @param id of track data item
		 * @return Tracker
		 */
		public function getTrack(id : String) : Tracker {
			var result : Tracker;

			for ( var c : int = 0 ; c < _tracks.length ; c++ ) {
				if ( _tracks[c].id == id  )
					result = _tracks[c];
			}

			return result;
		}

		/**
		 * 
		 * add timeline / timeline data 
		 * 
		 * @method addTrackData( tracker : Tracker ) : void
		 * @param Tracker
		 */
		public function addTrack(tracker : Tracker) : void {
			_tracks.push(tracker);
		}

		/**
		 *
		 * set the timeline / movieclip containing the video
		 * 
		 * @method setTimeline( mc : MovieClip ) : void
		 * @param mc : MovieClip
		 */
		public function setTimeline(mc : MovieClip) : void {
			_timeline = mc;
		}

		/**
		 * 
		 * set the video source to track to
		 *  
		 * @method setVideo( video : FLVPlayback ) : void 
		 * @param video : FLVPlayback
		 */
		public function setVideo(video : FLVPlayback) : void {
			videoUtils.setVideo(video);
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -RENDER-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * 
		 * get the current video frame 
		 *  
		 * @method getVideoFrane() : int 
		 * @param int : Frame number. If the video is not initialised returns -1
		 */
		public function getVideoFrame() : int {
			trace('videoUtils.getFrame(): ' + videoUtils.getFrame());
			return videoUtils.getFrame();
		}

		/**
		 * 
		 * render the tracks / personalisations from a movieclip source
		 *  
		 * @method render( ) : void
		 */
		public function renderMovieClip() : void {
			var c : int = _timeline.currentFrame;
			var frameTimelines : Vector.<Tracker> = getTrackers(c);
			var timelineData : Tracker;
			var frame : int;
			var found : Boolean;

			// ---------------------------------
			// check for trackers to stop;
			// ---------------------------------

			for ( c = 0 ; c < _activeTracks.length ; c++ ) {
				timelineData = _activeTracks[c];
				found = false;

				for ( var d : int = 0 ; d < frameTimelines.length ; d++ ) {
					if ( timelineData == frameTimelines[d] ) {
						found = true;
					}
				}

				if ( !found )
					stopTimeline(timelineData) ;
			}

			// ---------------------------------
			// start new trackers
			// ---------------------------------

			for ( c = 0 ; c < frameTimelines.length ; c++ ) {
				timelineData = frameTimelines[c];

				// Start new timeline
				if ( !timelineData.isActive ) {
					startNewTimeline(timelineData);
				}
			}

			// ---------------------------------
			// animate trackers
			// ---------------------------------

			for ( c = 0 ; c < _activeTracks.length ; c++ ) {
				timelineData = _activeTracks[c];

				if ( timelineData.renderer != null ) {
					frame = _timeline.currentFrame - timelineData.startFrame;
					timelineData.renderer.render(frame);
				}
			}
		}

		/**
		 * 
		 * render the trackers / personalisations from a video source
		 *  
		 * @method renderVideo( ) : void
		 */
		public function renderVideo() : void {
			var frame : int = videoUtils.getFrame();
			if ( frame == -1 ) return;

			var c : int;
			var frameTimelines : Vector.<Tracker> = getTrackers(frame);
			var timelineData : Tracker;
			var found : Boolean;
			var renderFrame : int;

			// ---------------------------------
			// check for trackers to stop;
			// ---------------------------------

			for ( c = 0 ; c < _activeTracks.length ; c++ ) {
				timelineData = _activeTracks[c];
				found = false;

				for ( var d : int = 0 ; d < frameTimelines.length ; d++ )
					if ( timelineData == frameTimelines[d] )
						found = true;

				if ( !found )
					stopTimeline(timelineData) ;
			}

			// ---------------------------------
			// start new trackers
			// ---------------------------------

			for ( c = 0 ; c < frameTimelines.length ; c++ ) {
				timelineData = frameTimelines[c];

				// Start new timeline
				if ( !timelineData.isActive )
					startNewTimeline(timelineData);
			}

			// ---------------------------------
			// animate trackers
			// ---------------------------------

			for ( c = 0 ; c < _activeTracks.length ; c++ ) {
				timelineData = _activeTracks[c];

				if ( timelineData.renderer != null ) {
					renderFrame = frame - timelineData.startFrame;
					timelineData.renderer.render(renderFrame);
				}
			}
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * 
		 * start a new timeline
		 *  
		 * @method startNewTimeline( timelineData : Tracker ) : void
		 * @param Tracker
		 */
		private function startNewTimeline(tracker : Tracker) : void {
			if ( tracker.renderer == null && !tracker.isActive ) {
				tracker.renderer = new TrackRenderer(tracker);
				tracker.isActive = true;

				_activeTracks.push(tracker);

				var e : TrackingEvent = new TrackingEvent(TrackingEvent.START_TRACKER, false);
				e.tracker = tracker
				dispatchEvent(e);
			}
		}

		/**
		 * 
		 * stop a timeline
		 *  
		 * @method stopTimeline ( timelineData : Tracker  ) : void
		 * @param Tracker
		 */
		private function stopTimeline(tracker : Tracker) : void {
			if ( tracker.renderer != null )
				tracker.renderer.dispose();

			tracker.renderer = null;
			tracker.isActive = false;

			for ( var c : int = 0 ; c < _activeTracks.length ; c++ )
				if ( tracker == _activeTracks[c])
					_activeTracks.splice(c, 1);

			var e : TrackingEvent = new TrackingEvent(TrackingEvent.STOP_TRACKER, false);
			e.tracker = tracker
			dispatchEvent(e);
		}

		/**
		 * 
		 * get all active timeline for a specific frame
		 *  
		 * @method getTimelines( frame : int ) : Vector.<Tracker>
		 * @param frame : int
		 * @return Vector.<Tracker>
		 */
		private function getTrackers(frame : int) : Vector.<Tracker> {
			var t : Tracker;
			var result : Vector.<Tracker> = new Vector.<Tracker>();

			for ( var c : int = 0 ; c < _tracks.length ; c++ ) {
				t = _tracks[c];

				if ( ( frame >= t.startFrame ) && (frame <= t.endFrame ) )
					result.push(t);
			}

			return result;
		}
	}
}