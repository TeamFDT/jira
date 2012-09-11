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
 * NOTES			:
			
			// var myThumb:thumbnail = new thumbnail(); // where thumbnail is the linkageID in the library
			// addChild(myCircle_mc);
 
 **********************************************************************************************************************************************************************************/
package com.kurst.data.items {
	import flash.events.EventDispatcher;

	public class PixelpostGalleryItem extends EventDispatcher {
		private var _id : Number
		private var _title : String
		private var _link : String
		private var _description : String
		private var _shortdescription : String
		private var _pubDate : String
		private var _thumb : String
		private var _image : String
		private var _loadid : String
		private var _video : String
		private var _date : Date
		private var _autoplay : Boolean
		private var _group : String;
		private var _numberingroup : Number;
		private var _uri : String;
		private var _background : String;
		private var _slideControlsEnabled : Boolean;
		private var _tooltip : String;
		private var _infoSlide : Boolean;
		private var _menuitem : Boolean;
		private var _subtitle : String;
		private var _slideshowFiles : Array;
		private var _slideshowPath : String;
		private var _slideshowEnabled : Boolean;
		private var _interactive : Boolean = false;
		private var _captionsubtitle : String;
		private var _youtubeid : String;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function PixelpostGalleryItem() {
			super();
		}

		public function copyToObject(obj : Object) : void {
			obj.id = _id
			obj.title = _title
			obj.link = _link
			obj.description = _description
			obj.pubDate = _pubDate
			obj.thumb = _thumb
			obj.image = _image
			obj.loadid = _loadid
			obj.video = _video
			obj.date = _date
			obj.autoplay = _autoplay
			obj.group = _group
			obj.numberingroup = _numberingroup
			obj.uri = _uri;
			obj.slideControlsEnabled = _slideControlsEnabled;
			obj.background = _background;
			obj.shortdescription = _shortdescription;
			obj.tooltip = _tooltip;
			obj.infoSlide = _infoSlide;
			obj.subtitle = _subtitle
			obj.menuitem = _menuitem
			obj.slideshowFiles = _slideshowFiles
			obj.slideshowPath = _slideshowPath
			obj.slideshowEnabled = _slideshowEnabled
			obj.interactive = _interactive;
			obj.captionsubtitle = _captionsubtitle;
			obj.youtubeid = _youtubeid;
			// trace('obj.slideshowEnabled: ' + obj.slideshowEnabled );
		}

		// -GET/SET----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		//
		// GGGGG  EEEEEEE TTTTTT          SSSSS EEEEEEE TTTTTT
		// GG      EE        TT           SS     EE        TT
		// GG  GGG EEEE      TT            SSSS  EEEE      TT
		// GG   GG EE        TT               SS EE        TT
		// GGGGG  EEEEEEE   TT           SSSSS  EEEEEEE   TT
		//
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		[Bindable]
		public function get loadid() : String {
			return _loadid;
		}

		public function set loadid(s : String) : void {
			_loadid = s;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		[Bindable]
		public function get title() : String {
			return _title;
		}

		public function set title(title : String) : void {
			_title = title;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		[Bindable]
		public function get link() : String {
			return _link;
		}

		public function set link(link : String) : void {
			_link = link;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		[Bindable]
		public function get description() : String {
			return _description;
		}

		public function set description(description : String) : void {
			_description = description;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		[Bindable]
		public function get pubDate() : String {
			return _pubDate;
		}

		public function set pubDate(pubDate : String) : void {
			_pubDate = pubDate;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		[Bindable]
		public function get thumb() : String {
			return _thumb;
		}

		public function set thumb(thumb : String) : void {
			_thumb = thumb;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		[Bindable]
		public function get image() : String {
			return _image;
		}

		public function set image(image : String) : void {
			_image = image;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		[Bindable]
		public function get date() : Date {
			return _date;
		}

		public function set date(date : Date) : void {
			_date = date;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		[Bindable]
		public function get id() : Number {
			return _id;
		}

		public function set id(i : Number) : void {
			_id = i;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		[Bindable]
		public function get video() : String {
			return _video;
		}

		public function set video(video : String) : void {
			_video = video;
		}

		[Bindable]
		public function get autoplay() : Boolean {
			return _autoplay;
		}

		public function set autoplay(autoplay : Boolean) : void {
			_autoplay = autoplay;
		}

		[Bindable]
		public function get group() : String {
			return _group;
		}

		public function set group(group : String) : void {
			_group = group;
		}

		public function get numberingroup() : Number {
			return _numberingroup;
		}

		public function set numberingroup(numberingroup : Number) : void {
			_numberingroup = numberingroup;
		}

		public function get uri() : String {
			return _uri;
		}

		public function set uri(uri : String) : void {
			_uri = uri;
		}

		public function get slideControlsEnabled() : Boolean {
			return _slideControlsEnabled;
		}

		public function set slideControlsEnabled(slideControlsEnabled : Boolean) : void {
			_slideControlsEnabled = slideControlsEnabled;
		}

		public function get background() : String {
			return _background;
		}

		public function set background(background : String) : void {
			_background = background;
		}

		public function get shortdescription() : String {
			return _shortdescription;
		}

		public function set shortdescription(shortdescription : String) : void {
			_shortdescription = shortdescription;
		}

		public function get tooltip() : String {
			return _tooltip;
		}

		public function set tooltip(tooltip : String) : void {
			_tooltip = tooltip;
		}

		public function get infoSlide() : Boolean {
			return _infoSlide;
		}

		public function set infoSlide(infoSlide : Boolean) : void {
			_infoSlide = infoSlide;
		}

		public function get menuitem() : Boolean {
			return _menuitem;
		}

		public function set menuitem(menuitem : Boolean) : void {
			_menuitem = menuitem;
		}

		public function get subtitle() : String {
			return _subtitle;
		}

		public function set subtitle(subtitle : String) : void {
			_subtitle = subtitle;
		}

		public function get slideshowFiles() : Array {
			return _slideshowFiles;
		}

		public function set slideshowFiles(slideshowFiles : Array) : void {
			_slideshowFiles = slideshowFiles;
		}

		public function get slideshowPath() : String {
			return _slideshowPath;
		}

		public function set slideshowPath(slideshowPath : String) : void {
			_slideshowPath = slideshowPath;
		}

		public function get slideshowEnabled() : Boolean {
			return _slideshowEnabled;
		}

		public function set slideshowEnabled(slideshowEnabled : Boolean) : void {
			_slideshowEnabled = slideshowEnabled;
		}

		public function get interactive() : Boolean {
			return _interactive;
		}

		public function set interactive(interactive : Boolean) : void {
			_interactive = interactive;
		}

		public function get captionsubtitle() : String {
			return _captionsubtitle;
		}

		public function set captionsubtitle(captionsubtitle : String) : void {
			_captionsubtitle = captionsubtitle;
		}

		public function get youtubeid() : String {
			return _youtubeid;
		}

		public function set youtubeid(youtubeid : String) : void {
			_youtubeid = youtubeid;
		}
	}
}