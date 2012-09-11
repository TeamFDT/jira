/******************************************************************************************************************************************************************************** *  * Class Name  	: com.kurst.controls.gallery3d.GalleryController3D * Version 	  	: 1 * Description 	: 3D Gallery Controller *  ******************************************************************************************************************************************************************************** *  * Author 		: Kb * Date 			: 27/05/09 *  ******************************************************************************************************************************************************************************** *  * METHODS * ********************************************************************************************************************************************************************************* *  *	updateView() : void  *	 *	getRenderer(  ) : GalleryRenderer *	setRenderer( r : GalleryRenderer ) *	 *	addViewportFilters( a : Array ) : void *	 *	setGallerySettings ( cs : GallerySettings ) : void *	getGallerySettings ( ) : GallerySettings *	 *	setBackButton( btn : SimpleButton ) : void *	setNextButton( btn : SimpleButton ) : void *	 *	setSection( sectionID:Object ) : void  *	setSubSection( subSectionID:Object ) : void *	 *	startRender () : void *	stopRender () : void *	 *	clear () : void *	destroy () : void *	 *	setData( dp : Object ) : void * ********************************************************************************************************************************************************************************* * * GET / SET * *********************************************************************************************************************************************************************************  * *	get selectedID () : Number *	get totalItems () : Number *	get camera () : CameraObject3D *	 *	set autoScaleToStage ( f : Boolean ) : void *	get autoScaleToStage ( ) : Boolean  *	 *	get width(  ) : Number  *	set width( v : Number ) : void *	 *	get height(  ) : Number *	set height( v : Number ) : void *	 *	get useKeyNavigation() : Boolean *	set useKeyNavigation(useKeyNav : Boolean) : void *	 *	get imageDataBinding() : String *	set imageDataBinding(imageDataBinding : String) : void * ********************************************************************************************************************************************************************************* * * EVENTS * ********************************************************************************************************************************************************************************* *  * 		LOADING * 		 *			 LoadEvent.ITEM_COMPLETE *			 				event.itemsLoaded *							event.itemsTotal *			 LoadEvent.PROGRESS *			 				event.bytesLoaded *							event.bytesTotal *			 LoadEvent.COMPLETE * *		View3D *		 *			Gallery3dEvent.SELECT_IMAGE *				event.selectedID *				event.totalItems *				event.data *				event.plane *				event.movie *		 ********************************************************************************************************************************************************************************* **********************************************************************************************************************************************************************************/package com.kurst.controls.gallery3d {	import br.com.stimuli.loading.BulkLoader;	import br.com.stimuli.loading.loadingtypes.LoadingItem;	import com.kurst.controls.gallery3d.renderer.GalleryRenderer;	import com.kurst.controls.gallery3d.settings.GallerySettings;	import com.kurst.controls.gallery3d.view.View3D;	import com.kurst.events.Gallery3dEvent;	import com.kurst.events.LoadEvent;	import com.kurst.utils.FDelayCall;	import flash.display.Loader;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.IOErrorEvent;	import flash.events.KeyboardEvent;	import flash.events.MouseEvent;	import flash.events.ProgressEvent;	import flash.events.TimerEvent;	import flash.net.URLLoader;	import flash.net.URLRequest;	import flash.system.System;	import flash.text.StyleSheet;	import flash.utils.Timer;	import com.greensock.layout.AlignMode	import com.greensock.layout.ScaleMode	import com.greensock.layout.AutoFitArea	import mx.collections.ArrayCollection;	import org.papervision3d.core.proto.CameraObject3D;	public class GalleryController3D extends Sprite {		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		private var background : Sprite;		private var bgLoader : Loader;		private var imgLoader : BulkLoader;		private var styleLoader : URLLoader;		private var view : View3D;		private var lBtn : *;		private var rBtn : *;		private var _scrollFlag : Boolean = false;		private var initFlag : Boolean = false;		private var background_uri : String = '';		private var _maxImages : int = 0;		private var _data : ArrayCollection;		private var _styleSheet : StyleSheet;		private var _enableMouseWheel : Boolean = true		private var _useKeyNav : Boolean = true;		private var mouseWheelTimer : Timer;		private var mouseWheelTimerDelay : Number = 60;		private var mouseWheelFlag : Boolean = true;		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		/*		private var viewportWidth		: Number 	= 640		private var viewportHeight 		: Number 	= 480		private var scaleToStage 		: Boolean 	= true		private var interactive 		: Boolean 	= true		private var cameraType 			: String 	= "Target"		 */		// private var backgroundArea		: AutoFitArea;		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		public function GalleryController3D(viewportWidth : Number = 640, viewportHeight : Number = 480, scaleToStage : Boolean = true, interactive : Boolean = false, cameraType : String = "Target") {			super();			view = new View3D(viewportWidth, viewportHeight, scaleToStage, true, cameraType);			// 3D View			viewportWidth = viewportWidth;			viewportHeight = viewportHeight;			scaleToStage = scaleToStage;			interactive = interactive;			cameraType = cameraType;			mouseWheelTimer = new Timer(mouseWheelTimerDelay);			mouseWheelTimer.addEventListener(TimerEvent.TIMER, onMouseWheelTimer, false, 0, true);			addEventListener(Event.ADDED_TO_STAGE, OnAddedToStage, false, 0, true);		}		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		/**		 * @method 		 * @tooltip 		 * @param 		 * @return 		 */		public function resizeBackground(w : Number, h : Number) : void {			if ( background != null ) {				background.width = w;				background.height = h;			}		}		/**		 * @method 		 * @tooltip 		 * @param 		 * @return 		 */		public function resize() : void {		}		/**		 * @method 		 * @tooltip 		 * @param 		 * @return 		 */		public function loadBg(url : String) : void {			if ( background_uri != url ) {				background.visible = false;				if ( bgLoader != null ) {					background.removeChild(bgLoader);					bgLoader.unloadAndStop(true);					bgLoader = null;				}				bgLoader = new Loader();				bgLoader.load(new URLRequest(url));				bgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, BackgroundLoaded, false, 0, true);				bgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);				background_uri = url;				if ( view != null ) {					var s : GallerySettings = view.getGallerySettings();					s.background = background_uri					view.setGallerySettings(s);				}			}		}		/**		 * @method updateView()		 * @tooltip Update the view - redraw / reposition		 */		public function updateView() : void {			view.update();		}		/**		 * @method getRenderer / setRenderer		 * @tooltip get / set the renderer		 * @param GalleryRenderer		 * @return GalleryRenderer		 */		public function getRenderer() : GalleryRenderer {			return view.getRenderer();		}		/**		 * @method getRenderer / setRenderer		 * @tooltip get / set the renderer		 * @param GalleryRenderer		 * @return GalleryRenderer		 */		public function setRenderer(r : GalleryRenderer) : void {			view.setRenderer(r);		}		/**		 * @method addViewportFilters		 * @tooltip add filters to the 3d viewport		 * @param a : Array 		 */		public function addViewportFilters(a : Array) : void {			view.addViewportFilters(a);		}		/**		 * @method setGallerySettings / getGallerySettings		 * @tooltip get / set the gallery settings		 * @param cs : GallerySettings		 * @return GallerySettings		 */		public function setGallerySettings(cs : GallerySettings) : void {			if ( cs.background != '' )				loadBg(cs.background);			view.setGallerySettings(cs);		}		/**		 * @method setGallerySettings / getGallerySettings		 * @tooltip get / set the gallery settings		 * @param cs : GallerySettings		 * @return GallerySettings		 */		public function getGallerySettings() : GallerySettings {			return view.getGallerySettings();		}		/**		 * @method setBackButton( btn : SimpleButton )		 * @tooltip assign a back button to the gallery		 * @param btn : SimpleButton		 */		public function setBackButton(btn : *) : void {			lBtn = btn;			lBtn.addEventListener(MouseEvent.CLICK, ClickButton, false, 0, true);		}		/**		 * @method setNextButton( btn : SimpleButton )		 * @tooltip assign a next button to the gallery		 * @param btn : SimpleButton		 */		public function setNextButton(btn : *) : void {			rBtn = btn;			rBtn.addEventListener(MouseEvent.CLICK, ClickButton, false, 0, true);		}		/**		 * @method renderFrame		 * @tooltip		 */		public function render() : void {			view.render();		}		/**		 * @method startRender () : void		 * @tooltip start rendering the 3d gallery		 */		public function startRender() : void {			view.startRender();		}		/**		 * @method stopRender () : void		 * @tooltip stop rendering the 3d gallery		 */		public function stopRender() : void {			view.stopRender();		}		/**		 * @method clear () : void		 * @tooltip clear the gallery		 */		public function clear() : void {			view.clear();			if ( lBtn != null) lBtn.visible = false;			if ( rBtn != null) rBtn.visible = false;			imgLoader.pauseAll();			imgLoader.removeAll();		}		/**		 * @method destroy () : void		 * @tooltip destroy all objects in the gallery / free RAM 		 */		public function destroy(preserveView : Boolean = false) : void {			stopRender();			// Destroy / Clear the 3d view			view.destroy(preserveView);			// Remove event listeners			if ( !preserveView ) {				view.removeEventListener(Gallery3dEvent.SELECT_IMAGE, ScrollGallery);				view.removeEventListener(Gallery3dEvent.SCROLL_COMPLETE, ScrollGalleryComplete);				view.removeEventListener(Gallery3dEvent.SELECT_IMAGE_ANIMATION_COMPLETE, ScrollGalleryComplete);				// un-assign the buttons				if ( lBtn != null ) lBtn = null;				if ( rBtn != null ) rBtn = null;			}			// clear the image loader			if ( imgLoader != null ) {				imgLoader.pauseAll();				imgLoader.removeAll();				imgLoader.removeEventListener(BulkLoader.COMPLETE, AllItemsLoaded);				imgLoader = null;			}			// Remove Default Event :Listeners			removeEventListener(Event.ADDED_TO_STAGE, OnAddedToStage);			if ( stage != null && !preserveView ) {				stage.addEventListener(Event.RESIZE, StageResize, false, 0, true);				stage.addEventListener(MouseEvent.MOUSE_WHEEL, MouseWheelHandler, false, 0, true);				stage.addEventListener(KeyboardEvent.KEY_UP, OnKeyUp, false, 0, true);				initFlag = false;				if ( bgLoader != null ) {					background.removeChild(bgLoader);					bgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, BackgroundLoaded);					bgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);					bgLoader.unload();				}			}			// Remove the view			if ( !preserveView )				removeChild(view);		}		/**		 * @method setData( dp : ArrayCollection ) : void 		 * @tooltip assign the gallery data		 * @param dp - Data Provider		 */		public function setData(dp : Object) : void {			if ( dp == null ) {				return;			}			// Store the data object			_data = dp as ArrayCollection;			// Clear the loader			if ( imgLoader == null )				initLoader()			else				imgLoader.removeAll();			var tmpMaxImages : int = _maxImages;			if ( _maxImages == 0 ) tmpMaxImages = _data.length			// Add all the images to the loading queue			for ( var i : int = 0 ; i < _data.length ; i++ ) {				if ( i < tmpMaxImages ) {					var record : Object = _data.getItemAt(i);					// trace('setData record.group: ' + record.group );					// trace('GC3D - record.group: ' + record.group )					// var imageURI: String		= ( view.useThumbnail ) ? record[view.thmbnlDataBinding] : record[view.imageDataBinding];					var imageURI : String = record[view.imageDataBinding];					var item : LoadingItem = imgLoader.add(imageURI);					item.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);					item.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);				}			}			// start loading			imgLoader.start(1);		}		/**		 * @method 		 * @tooltip 		 * @return  		 */		public function next() : Boolean {			return view.next()		}		/**		 * @method 		 * @tooltip 		 * @return  		 */		public function previous() : Boolean {			return view.previous();		}		/**		 * @method 		 * @tooltip 		 * @return  		 */		public function goto(id : Number) : Boolean {			return view.goto(id)		}		/**		 * @method 		 * @tooltip 		 * @return  		 */		public function loadStyleSheet(uri : String = null) : void {			if ( uri != null ) {				styleLoader = new URLLoader()				styleLoader.addEventListener(Event.COMPLETE, styleSheetLoaded, false, 0, true);				styleLoader.load(new URLRequest(uri));			}		}		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		// -GET/SET----------------------------------------------------------------------------------------------------------------------------------------------------		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		/**		 * @method		 * @tooltip		 * @param		 * @return		 */		public function get useMovieClipMaterial() : Boolean {			return view.useMovieClip;		}		public function set useMovieClipMaterial(useMovieClip : Boolean) : void {			view.useMovieClip = useMovieClip;		}		/**		 * @method		 * @tooltip		 * @param		 * @return		 */		public function get movieClipMaterialSymbol() : String {			return view.movieClipSymbol;		}		public function set movieClipMaterialSymbol(movieClipSymbol : String) : void {			view.movieClipSymbol = movieClipSymbol;		}		/**		 * @method selectedID		 * @tooltip get the seletect item ID		 * @return Number		 */		public function get selectedID() : Number {			return view.selectedID;		}		/**		 * @method totalItems		 * @tooltip get total items in the gallery		 * @return Number		 */		public function get totalItems() : Number {			return view.totalItems;		}		/**		 * @method camera 		 * @tooltip get the 3d camera object		 * @param CameraObject3D		 */		public function get camera() : CameraObject3D {			return view.camera;		}		/**		 * @method autoScaleToStage		 * @tooltip auto scale the 3d component to the stage		 * @param Boolean		 * @return Boolean		 */		public function set autoScaleToStage(f : Boolean) : void {			view.autoScaleToStage = f;		}		/**		 * @method autoScaleToStage		 * @tooltip auto scale the 3d component to the stage		 * @param Boolean		 * @return Boolean		 */		public function get autoScaleToStage() : Boolean {			return view.autoScaleToStage;		}		/**		 * @method width		 * @tooltip get the width of the 3d view area		 * @param Number		 * @return Number 		 */		override public function get width() : Number {			return view.viewportWidth;		}		/**		 * @method width		 * @tooltip get the width of the 3d view area		 * @param Number		 * @return Number 		 */		override public function set width(v : Number) : void {			view.width = v;			resize();		}		/**		 * @method height		 * @tooltip get the height of the 3d view area		 * @param Number		 * @return Number 		 */		override public function get height() : Number {			return view.viewportHeight;		}		/**		 * @method height		 * @tooltip get the height of the 3d view area		 * @param Number		 * @return Number 		 */		override public function set height(v : Number) : void {			view.height = v;			resize();		}		/**		 * @method 		 * @tooltip 		 * @param 		 * @param  		 * @return  		 */		public function get useKeyNavigation() : Boolean {			return _useKeyNav;		}		/**		 * @method 		 * @tooltip 		 * @param 		 * @param  		 * @return  		 */		public function set useKeyNavigation(useKeyNav : Boolean) : void {			_useKeyNav = useKeyNav;			if ( _useKeyNav ) {				stage.addEventListener(KeyboardEvent.KEY_UP, OnKeyUp, false, 0, true);			} else {				stage.removeEventListener(KeyboardEvent.KEY_UP, OnKeyUp);			}		}		/**		 * @method 		 * @tooltip 		 * @param 		 * @param  		 * @return  		 */		public function get imageDataBinding() : String {			return view.imageDataBinding;		}		/**		 * @method 		 * @tooltip 		 * @param 		 * @param  		 * @return  		 */		public function set imageDataBinding(imageDataBinding : String) : void {			view.imageDataBinding = imageDataBinding;		}		/**		 * @method 		 * @tooltip 		 * @return  		 */		public function set enableMouseWheel(flag : Boolean) : void {			_enableMouseWheel = flag			if ( stage == null ) return;			trace('GalleryController3D.enableMouseWheel: ' + flag)			if ( flag ) {				stage.addEventListener(MouseEvent.MOUSE_WHEEL, MouseWheelHandler, false, 0, true);			} else {				stage.removeEventListener(MouseEvent.MOUSE_WHEEL, MouseWheelHandler);			}		}		/**		 * @method 		 * @tooltip 		 * @return  		 */		public function get enableMouseWheel() : Boolean {			return _enableMouseWheel;		}		/**		 * @method 		 * @tooltip 		 * @return  		 */		public function set maxImages(val : int) : void {			_maxImages = val;		}		/**		 * @method 		 * @tooltip 		 * @return  		 */		public function get maxImages() : int {			return _maxImages		}		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		/**		 * @method init ( )  : void		 * @tooltip initialize the component		 */		private function init() : void {			if ( background == null ) {				background = new Sprite();				background.cacheAsBitmap = true;				addChild(background);			}			addChild(view);			stage.addEventListener(Event.RESIZE, StageResize, false, 0, true);			if ( enableMouseWheel )				enableMouseWheel = true;			if ( useKeyNavigation )				stage.addEventListener(KeyboardEvent.KEY_UP, OnKeyUp, false, 0, true);			view.addEventListener(Gallery3dEvent.SELECT_IMAGE, ScrollGallery, false, 0, true);			view.addEventListener(Gallery3dEvent.SCROLL_COMPLETE, ScrollGalleryComplete, false, 0, true);			view.addEventListener(Gallery3dEvent.SELECT_IMAGE_ANIMATION_COMPLETE, ScrollGalleryComplete, false, 0, true);			initLoader();			initFlag = true;		}		/**		 * @method 		 * @tooltip 		 * @param 		 * @param  		 * @return  		 */		private function initLoader() : void {			if ( BulkLoader.getLoader('CoverFlowBulkLoader') == null ) {				imgLoader = new BulkLoader('CoverFlowBulkLoader');			} else {				imgLoader = BulkLoader.getLoader('CoverFlowBulkLoader');			}			imgLoader.addEventListener(BulkLoader.COMPLETE, AllItemsLoaded, false, 0, true);		}		/**		 * @method getRecordByKey( value:* , key:String ) : Object		 * @tooltip get a record by key		 * @param value to match		 * @param key to look 		 * @return object 		 */		private function getRecordByKey(value : *, key : String) : Object {			for ( var i : int = 0 ; i < _data.length ; i++ ) {				var record : Object = _data.getItemAt(i);				if ( record[key] == value ) return record;			}			return -1;		}		/**		 * @method		 * @tooltip		 * @param 		 * @param  		 * @return  		 */		private function startMouseWheelTimer() : void {			mouseWheelTimer.reset();			mouseWheelFlag = false;			mouseWheelTimer.start();		}		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		// -EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		/**		 * @method		 * @tooltip		 * @param		 */		private function onMouseWheelTimer(event : TimerEvent) : void {			mouseWheelFlag = true;			mouseWheelTimer.stop();		}		/**		 * @method		 * @tooltip		 * @param		 */		private function styleSheetLoaded(event : Event) : void {			_styleSheet = new StyleSheet();			_styleSheet.parseCSS(event.target.data);			view.styleSheet = _styleSheet			dispatchEvent(new Gallery3dEvent(Gallery3dEvent.STYLE_SHEET_LOADED, true, false))		}		/**		 * @method		 * @tooltip		 * @param		 */		private function ioErrorHandler(e : IOErrorEvent) : void {			bgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, BackgroundLoaded);			bgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);			bgLoader.unloadAndStop(true);			bgLoader = null;		}		/**		 * @method		 * @tooltip		 * @param		 */		private function BackgroundLoaded(e : Event) : void {			background.visible = true;			bgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, BackgroundLoaded);			bgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);			background.addChild(bgLoader);			StageResize();			FDelayCall.addCall(StageResize, this);			dispatchEvent(new Gallery3dEvent(Gallery3dEvent.BACKGROUND_LOADED));		}		/**		 * @method AllItemsLoaded( e : Event ) : void		 * @tooltip Event Listener for BulkLoader - called when all items have been loaded		 * @param e:Event		 */		private function AllItemsLoaded(e : Event) : void {			var le : LoadEvent = new LoadEvent(LoadEvent.COMPLETE);			dispatchEvent(le);		}		/**		 * @method ScrollGallery( e : GalleryEvent ) : void		 * @tooltip View3D event - Called when the gallery scroll has complete		 * @param Gallery3dEvent		 */		private function ScrollGalleryComplete(e : Gallery3dEvent) : void {			trace('ScrollGalleryComplete');			_scrollFlag = false;		}		/**		 * @method ScrollGallery( e : GalleryEvent ) : void		 * @tooltip  View3D event - Called when the gallery scroll has started		 * @param Gallery3dEvent		 */		private function ScrollGallery(e : Gallery3dEvent) : void {			_scrollFlag = true;			// ----------------------------------------			// Show / Hide Previous / Next Arrows			if ( e.selectedID == e.totalItems && rBtn != null) {				rBtn.visible = false;			} else if ( e.selectedID == 0 && lBtn != null) {				lBtn.visible = false;			} else {				if ( lBtn != null)					lBtn.visible = true;				if ( rBtn != null)					rBtn.visible = true;			}		}		/**		 * @method OnKeyUp( e : KeyboardEvent ) : void		 * @tooltip KeyBoard Event Handler		 * @param KeyboardEvent		 */		private function OnKeyUp(e : KeyboardEvent) : void {			// ----------------------------------------			// Key Handler			// 37 - Left Arrow Key			// 39 - Right Arrow Key			switch ( e.keyCode ) {				case 37 :					view.previous();					break;				case 39 :					view.next();					break;			}		}		/**		 * @method ClickButton( e : MouseEvent ) : void		 * @tooltip button handler for the  next / previous buttons		 * @param MouseEvent		 */		private function ClickButton(e : MouseEvent) : void {			switch ( e.currentTarget.name ) {				case lBtn.name :					view.previous();					break;				case rBtn.name :					view.next();					break;			}		}		/**		 * @method OnAddedToStage( e : Event ) : void 		 * @tooltip Stage Event Handler - called when the component has been added to the stage		 * @param Event		 */		private function OnAddedToStage(e : Event) : void {			init();			removeEventListener(Event.ADDED_TO_STAGE, OnAddedToStage);			StageResize();		}		/**		 * @method StageResize( e : Event = null ) : void		 * @tooltip Stage Resize Event Handler		 */		private function StageResize(e : Event = null) : void {			resize();		}		/**		 * @method MouseWheelHandler( e : MouseEvent ) : void		 * @tooltip Mouse Wheel event handler		 */		private function MouseWheelHandler(e : MouseEvent) : void {			trace('GalleryController3D.MouseWheelHandler')			if ( mouseWheelFlag ) {				if ( hitTestPoint(stage.mouseX, stage.mouseY) ) {					if ( e.delta > 0 ) {						view.previous();					} else {						view.next();					}					startMouseWheelTimer();				}			} else { 							// Event skipped to avoid double scrolls.			}		}		/**		 * @method progressHandler( e : ProgressEvent ) : void		 * @tooltip Event Handler for bulk loader load progress		 * @param ProgressEvent		 */		private function progressHandler(e : ProgressEvent) : void {			// ----------------------------------------			// Relay / Disptach LoadEvent			var le : LoadEvent = new LoadEvent(LoadEvent.PROGRESS);			le.bytesLoaded = e.bytesLoaded			le.bytesTotal = e.bytesTotal			dispatchEvent(le);		}		/**		 * @method completeHandler( e : Event ) : void		 * @tooltip image item load complete handler		 */		private function completeHandler(e : Event) : void {			// ----------------------------------------			// remove event listeners and reference the bitmap			var item : LoadingItem = e.target as LoadingItem;			item.removeEventListener(Event.COMPLETE, completeHandler);			item.removeEventListener(ProgressEvent.PROGRESS, progressHandler);			var sURL : String = item.url.url;			// trace('loadedItem: ' + sURL );			// var imageBinding: String	= ( view.useThumbnail ) ? view.thmbnlDataBinding : view.imageDataBinding;			var imageBinding : String = view.imageDataBinding;			var record : Object = getRecordByKey(sURL, imageBinding);			record.loadid = sURL;			if ( sURL.indexOf('.swf') != -1 ) {				view.addSWF(imgLoader.getMovieClip(record.loadid), record);				// trace( imgLoader.getMovieClip( record.loadid ).loaderInfo.url + ' : ' + imgLoader.getMovieClip( record.loadid ).loaderInfo.bytesTotal );			} else {				// trace('completeHandler - record: ' + record.group );				view.addImage(imgLoader.getBitmap(record.loadid), record);				// trace( imgLoader.getBitmap( record.loadid ).loaderInfo.url + ' : ' + imgLoader.getBitmap( record.loadid ).loaderInfo.bytesTotal );				if ( view.useThumbnail )					FDelayCall.addCall(imgLoader.remove, imgLoader, record.loadid)			}			System.gc();			// ----------------------------------------			// Show / Hide Previous / Next Arrows			if ( view.selectedID == view.totalItems ) {				if ( rBtn != null)					rBtn.visible = false;				if ( view.totalItems > 0 && lBtn != null)					lBtn.visible = true;			} else if ( view.selectedID == 0 ) {				if ( lBtn != null)					lBtn.visible = false;				if ( view.totalItems > 0 && rBtn != null)					rBtn.visible = true;			} else {				if ( lBtn != null)					lBtn.visible = true;				if ( rBtn != null)					rBtn.visible = true;			}			// ----------------------------------------			// Dispatch / Relay loadEvent			var le : LoadEvent = new LoadEvent(LoadEvent.ITEM_COMPLETE);			le.itemsLoaded = imgLoader.itemsLoaded;			le.itemsTotal = imgLoader.itemsTotal;			dispatchEvent(le);		}		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		// -GET/SET----------------------------------------------------------------------------------------------------------------------------------------------------		// ------------------------------------------------------------------------------------------------------------------------------------------------------------		/**		 * @method 		 * @tooltip 		 * @param 		 */		public function get backgroundURI() : String {			return background_uri;		}		/**		 * @method 		 * @tooltip 		 * @param 		 */		public function get pv3dView() : View3D {			return view;		}		/**		 * @method		 * @tooltip		 * @param 		 * @return 		 */		public function get autoSelectFirstImage() : Boolean {			return view.autoSelectFirstImage;		}		public function set autoSelectFirstImage(autoSelectFirstImg : Boolean) : void {			view.autoSelectFirstImage = autoSelectFirstImg;		}		/**		 * @method 		 * @tooltip 		 * @param 		 */		public function get showStats() : Boolean {			return view.showStats;		}		/**		 * @method		 * @tooltip		 * @param 		 */		public function set showStats(useStats : Boolean) : void {			view.showStats = useStats;		}		/**		 * @method		 * @tooltip		 * @param 		 */		public function get useThumbnail() : Boolean {			return view.useThumbnail;		}		public function set useThumbnail(useThumbnail : Boolean) : void {			view.useThumbnail = useThumbnail;		}		/**		 * @method		 * @tooltip		 * @param 		 */		public function get thmbnlDataBinding() : String {			return view.thmbnlDataBinding;		}		public function set thmbnlDataBinding(thmbnlDataBinding : String) : void {			view.thmbnlDataBinding = thmbnlDataBinding;		}		public function get scrollFlag() : Boolean {			return _scrollFlag;		}		public function set scrollFlag(scrollFlag : Boolean) : void {			_scrollFlag = scrollFlag;		}	}}