/******************************************************************************************************************************************************************************** *  * Class Name  	: com.kurst.controls.audio.MP3ScrubBar * Version 	  	: 1 * Description 	: MP3 / Audio scrub Bar - works with the Mp3Player *  ******************************************************************************************************************************************************************************** *  * Author 		: Kb * Date 			: 10/02/09 *  ******************************************************************************************************************************************************************************** *  * METHODS *  *		removeController() : Boolean *		setController( c : Mp3Player ) : void *		draw( ) * **********************************************************************************************************************************************************************************/package com.kurst.controls.audio {	import com.kurst.controls.core.KurstUIComponentBase;	import flash.display.Sprite;	import flash.display.MovieClip;	import flash.events.Event;	import flash.events.MouseEvent;	import com.kurst.controls.audio.ScrubBarAssets.MP3ScrubBarBackground;	import com.kurst.controls.audio.ScrubBarAssets.MP3ScrubBarDragger;	import com.kurst.controls.audio.ScrubBarAssets.MP3ScrubBarLoadProgress;	import com.kurst.controls.audio.ScrubBarAssets.MP3ScrubBarPlayProgress;	import com.kurst.controls.audio.ScrubBarAssets.MP3ScrubBarBorder;	import com.kurst.controls.audio.Mp3Player;	import com.kurst.events.Mp3PlayerEvent;	import com.kurst.events.LoadEvent;	import flash.geom.Rectangle	public class MP3ScrubBar extends KurstUIComponentBase {		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		public var DeadPreview : MovieClip;		private var _background : MP3ScrubBarBackground;		private var _dragger : MP3ScrubBarDragger;		private var _loadprogress : MP3ScrubBarLoadProgress;		private var _playprogress : MP3ScrubBarPlayProgress;		private var _border : MP3ScrubBarBorder;		private var _scrubFlag : Boolean = false;		private var mp3Player : Mp3Player;		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		public function MP3ScrubBar() {			super();			addEventListener(Event.ADDED_TO_STAGE, AddedToStage, false, 0, true);		}		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		//		// PPPPPP  UU   UU BBBBBB  LL      IIIIII  CCCCC		// PP   PP UU   UU BB   BB LL        II   CC   CC		// PPPPPP  UU   UU BBBBBB  LL        II   CC		// PP      UU   UU BB   BB LL        II   CC   CC		// PP       UUUUU  BBBBBB  LLLLLLL IIIIII  CCCCC		//		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		/**		 * @method draw( )		 * @tooltip draw / update the component		 */		override protected function draw() : void {			// set the background width			if ( _background ) {				trace('_background.width: ' + _background.width);				_background.width = width;				trace('_background.width: ' + _background.width);			}			// set the postion of the drag bar			if ( _dragger )				_dragger.x = getDraggerXPos();			// set the load / play progresss withs			if ( _loadprogress ) {				_loadprogress.width = 0;				_playprogress.width = getPlayProgressWidth();			}			if ( _border )				_border.width = width;		}		/**		 * @method setController( c : Mp3Player )		 * @tooltip assign the Mp3Player to the controller		 * @param c : Mp3Player		 */		public function setController(c : Mp3Player) : void {			mp3Player = c;			mp3Player.addEventListener(Mp3PlayerEvent.COMPLETE, CompleteEvent, false, 0, true);			mp3Player.addEventListener(Mp3PlayerEvent.PLAY, PlayEvent, false, 0, true);			mp3Player.addEventListener(Mp3PlayerEvent.PAUSE, PauseEvent, false, 0, true);			mp3Player.addEventListener(Mp3PlayerEvent.RESUME, ResumeEvent, false, 0, true);			mp3Player.addEventListener(Mp3PlayerEvent.TIME_CHANGE, UpdateTimeEvent, false, 0, true);			mp3Player.addEventListener(LoadEvent.PROGRESS, LoadProgress, false, 0, true);			mp3Player.addEventListener(LoadEvent.COMPLETE, LoadComplete, false, 0, true);		}		/**		 * @method removeController( c : Mp3Player )		 * @tooltip remove the Mp3Player		 * @return True if successfull || Flase otherwise		 */		public function removeController() : Boolean {			try {				mp3Player.removeEventListener(Mp3PlayerEvent.COMPLETE, CompleteEvent);				mp3Player.removeEventListener(Mp3PlayerEvent.PLAY, PlayEvent);				mp3Player.removeEventListener(Mp3PlayerEvent.PAUSE, PauseEvent);				mp3Player.removeEventListener(Mp3PlayerEvent.RESUME, ResumeEvent);				mp3Player.removeEventListener(Mp3PlayerEvent.TIME_CHANGE, UpdateTimeEvent);				mp3Player.removeEventListener(LoadEvent.PROGRESS, LoadProgress);				mp3Player.removeEventListener(LoadEvent.COMPLETE, LoadComplete);				return true			} catch ( e : Error ) {				return false;			}			return true;		}		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		//		// PPPPPP  RRRRR   IIIIII V     V   AAA   TTTTTT EEEEEEE		// PP   PP RR  RR    II   V     V  AAAAA    TT   EE		// PPPPPP  RRRRR     II    V   V  AA   AA   TT   EEEE		// PP      RR  RR    II     V V   AAAAAAA   TT   EE		// PP      RR   RR IIIIII    V    AA   AA   TT   EEEEEEE		//		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		/**		 * @method init()		 * @tooltip initialize the component		 */		private function init() : void {			setSkin();			addEventListener(MouseEvent.MOUSE_DOWN, MouseDown, false, 0, true);			stage.addEventListener(MouseEvent.MOUSE_UP, StageMouseUp, false, 0, true);		}		/**		 * @method setSkin()		 * @tooltip attach the skin 		 */		private function setSkin() : void {						_background = new MP3ScrubBarBackground();			// trace('_background: ' + _background.width  );			_dragger = new MP3ScrubBarDragger();			_loadprogress = new MP3ScrubBarLoadProgress();			_playprogress = new MP3ScrubBarPlayProgress();			_border = new MP3ScrubBarBorder();			_loadprogress.visible = false;			addChild(_background);			addChild(_loadprogress);			addChild(_playprogress);			addChild(_dragger);			addChild(_border)			draw();		}		/**		 * @method getDraggerXPos():Number		 * @tooltip get the X Position of the drag bar		 */		private function getDraggerXPos() : Number {			return ( mp3Player == null ) ? 0 : ( width - _dragger.width ) * ( mp3Player.time / mp3Player.length );		}		/**		 * @method getPlayProgressWidth():Number		 * @tooltip get the width of the play progress bar		 */		private function getPlayProgressWidth() : Number {			return _dragger.x;		}		/**		 * @method StartScrubDrag() : void 		 * @tooltip Start a scrub action		 */		private function StartScrubDrag() : void {			// Drag bounds			var bounds : Rectangle = new Rectangle(0, 0, width - _dragger.width, 0);			_dragger.startDrag(false, bounds)			_dragger.gotoAndStop(2);			stage.addEventListener(MouseEvent.MOUSE_MOVE, DragHandler, false, 0, true);			_scrubFlag = true;		}		/**		 * @method StopScrubDrag():void		 * @tooltip end a scrub action		 */		private function StopScrubDrag() : void {			if ( _scrubFlag ) {				stage.removeEventListener(MouseEvent.MOUSE_MOVE, DragHandler);				_dragger.stopDrag();				_dragger.gotoAndStop(1);				_scrubFlag = false;				// seek to appropriate time				mp3Player.seek(_dragger.x / ( width - _dragger.width ))			}		}		/**		 * @method seekTo( percent:Number ) : void		 * @tooltip sound seek to percentage value		 * @param percentage - value between 0 and 1		 * @return		 */		private function seekTo(percent : Number) : void {			mp3Player.seek(percent);		}		// -EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		//		// EEEEEEE V     V EEEEEEE NN  NN TTTTTT         HH   HH   AAA   NN  NN DDDDDD  LL      EEEEEEE RRRRR    SSSSS		// EE      V     V EE      NNN NN   TT           HH   HH  AAAAA  NNN NN DD   DD LL      EE      RR  RR  SS		// EEEE     V   V  EEEE    NNNNNN   TT           HHHHHHH AA   AA NNNNNN DD   DD LL      EEEE    RRRRR    SSSS		// EE        V V   EE      NN NNN   TT           HH   HH AAAAAAA NN NNN DD   DD LL      EE      RR  RR      SS		// EEEEEEE    V    EEEEEEE NN  NN   TT           HH   HH AA   AA NN  NN DDDDDD  LLLLLLL EEEEEEE RR   RR SSSSS		//		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		/**		 * @method DragHandler( e : MouseEvent ) : void		 * @tooltip drag handler - called during a drag process 		 * @param		 * @return		 */		private function DragHandler(e : MouseEvent) : void {			_playprogress.width = getPlayProgressWidth();		}		/**		 * @method StageMouseUp( e : MouseEvent ) : void		 * @tooltip end a drag action when the mouse button is released		 */		private function StageMouseUp(e : MouseEvent) : void {			StopScrubDrag();		}		/**		 * @method MouseDown( e : MouseEvent ) : void 		 * @tooltip Mouse down handler - start a drag action - or seeks to clicked sound positions		 * @param		 * @return		 */		private function MouseDown(e : MouseEvent) : void {			if ( mp3Player == null ) return ;			if ( stage == null ) return ;			if ( _dragger.hitTestPoint(stage.mouseX, stage.mouseY) ) {				// if the drag button is pressed - start frag				StartScrubDrag();			} else if ( _background.hitTestPoint(stage.mouseX, stage.mouseY) ) {				// if the background is pressed - seek to appropriate time				seekTo(mouseX / width);			}		}		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		// LOADING EVENTS		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		/**		 * @method LoadComplete( e : LoadEvent )		 */		private function LoadComplete(e : LoadEvent) : void {			_loadprogress.visible = false;		}		/**		 * @method  LoadProgress( e : LoadEvent)		 */		private function LoadProgress(e : LoadEvent) : void {			_loadprogress.visible = true;			_loadprogress.width = width * ( e.bytesLoaded / e.bytesTotal );		}		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		// MP3 PLAYER EVENTS		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		/**		 * @method UpdateTimeEvent( e : Mp3PlayerEvent )		 */		private function UpdateTimeEvent(e : Mp3PlayerEvent) : void {			if ( !_scrubFlag ) {				_dragger.x = getDraggerXPos();				_playprogress.width = getPlayProgressWidth();			}		}		/**		 * @method ResumeEvent( e : Mp3PlayerEvent )		 */		private function ResumeEvent(e : Mp3PlayerEvent) : void {		}		/**		 * @method PauseEvent( e : Mp3PlayerEvent ) 		 */		private function PauseEvent(e : Mp3PlayerEvent) : void {		}		/**		 * @method PlayEvent( e : Mp3PlayerEvent )		 */		private function PlayEvent(e : Mp3PlayerEvent) : void {		}		/**		 * @method CompleteEvent( e : Mp3PlayerEvent )		 */		private function CompleteEvent(e : Mp3PlayerEvent) : void {		}		/**		 * @method AddedToStage( e : Event )		 */		private function AddedToStage(e : Event) : void {			init();		}	}}