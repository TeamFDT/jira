/*********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.controls.gallery3d.data.GalleryDataLoader
 * Version 	  	: 1
 * Description 	: this object is responsible for loading image data / gallery settings and managing the render settings data. 
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti	
 * Date 			: 16/10/09
 * 
 ********************************************************************************************************************************************************************************
 * 
 * METHODS

 	LOAD DATA
 	  
		loadUserSettings ( uri : String ) 
		loadImageData( uri : String , baseUri : String = ''  )
		
	GalleryController3D:
	 
		setGalleryRenderer ( galleryController3D : GalleryController3D , galType : String )
		getRenderSettings( galleryType : String) : Object
		getGallerySettings( ) : GallerySettings

 	DATA:
 	 
		saveSetting( group : String , settingName : String , value : * )
		getSavedSetting( group : String , settingName : String ) : *
		getAllSavedSettings( group : String ) : Object
		
		
 
 * PROPERTIES

		randomizeImages ( Boolean )
		usePixelPost ( Boolean )
  
 * 
 *
 * EVENTS
 
 		Gallery3dEvent.GALLERY_LOADED
		Gallery3dEvent.USERSETTINGS_LOADED
		Gallery3dEvent.ALL_DATA_LOADED* 
 * 
 * 
 ********************************************************************************************************************************************************************************
 * 				:
 *
 *
 *********************************************************************************************************************************************************************************
 * NOTES			:
 **********************************************************************************************************************************************************************************/
package com.kurst.controls.gallery3d.data {
	import com.kurst.controls.gallery3d.renderer.RandomRenderer;
	import com.kurst.controls.gallery3d.settings.RandomSettings;
	import com.kurst.events.eventDispatcher;
	
	// import com.geditor.events.GDataEvent;
	import com.kurst.controls.gallery3d.GalleryController3D;
	import com.kurst.controls.gallery3d.constants.GalleryType;
	import com.kurst.controls.gallery3d.renderer.CarouselRenderer;
	import com.kurst.controls.gallery3d.renderer.CoverFlowRenderer;
	import com.kurst.controls.gallery3d.renderer.GridRenderer;
	import com.kurst.controls.gallery3d.renderer.StripRenderer;
	import com.kurst.controls.gallery3d.settings.CarouselSettings;
	import com.kurst.controls.gallery3d.settings.CoverflowSettings;
	import com.kurst.controls.gallery3d.settings.GallerySettings;
	import com.kurst.controls.gallery3d.settings.GridSettings;
	import com.kurst.controls.gallery3d.settings.StripSettings;
	import com.kurst.data.ImageGallery;
	import com.kurst.data.Pixelpost;
	import com.kurst.data.XmlToCollection;
	import com.kurst.events.Gallery3dEvent;
	import com.kurst.events.LoadEvent;
	import com.kurst.utils.ArrayUtils;

	import flash.display.Sprite;

	import mx.collections.ArrayCollection;

	// extends Sprite
	public class GalleryDataLoader extends eventDispatcher {
		[Bindable]
		public var imageCollection : ArrayCollection;
		private var savedUserSettingsObjectCollection : Object;
		private var xImageData : ImageGallery
		private var imageData : Pixelpost
		private var savedUserSettings : XmlToCollection;
		private var imageDataLoaded : Boolean = false;
		private var userSettingsLoaded : Boolean = false;
		private var _usePixelPost : Boolean = true;
		private var _randomizeImages : Boolean = true;
		private var _selectedGalleryType : String = '';
		private var coverflowSettings : CoverflowSettings = new CoverflowSettings();
		private var gridSettings : GridSettings = new GridSettings();
		private var stripSettings : StripSettings = new StripSettings();
		private var carouselSettings : CarouselSettings = new CarouselSettings();
		private var randomSettings : RandomSettings = new RandomSettings();
		private var gallerySettings : GallerySettings = new GallerySettings();
		private var _backgroundColour : uint = 0;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function GalleryDataLoader() {
			super();

			coverflowSettings = new CoverflowSettings();
			gridSettings = new GridSettings();
			stripSettings = new StripSettings();
			carouselSettings = new CarouselSettings();
			gallerySettings = new GallerySettings();

			xImageData = new ImageGallery
			imageData = new Pixelpost();
			savedUserSettings = new XmlToCollection();
			savedUserSettingsObjectCollection = new Object();

			// rendererSettings					= new XmlToCollection();
		}

		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		//
		// PPPPPP  UU   UU BBBBBB  LL      IIIIII  CCCCC
		// PP   PP UU   UU BB   BB LL        II   CC   CC
		// PPPPPP  UU   UU BBBBBB  LL        II   CC
		// PP      UU   UU BB   BB LL        II   CC   CC
		// PP       UUUUU  BBBBBB  LLLLLLL IIIIII  CCCCC
		//
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function updateGallerySettings(galleryController3D : GalleryController3D) : void {
			loadSavedSettings(GalleryType.GALLERY);
			galleryController3D.setGallerySettings(gallerySettings);
			galleryController3D.updateView();
		}

		/**
		 * @method 						loadImageData( uri : String , baseUri : String = ''  ) : void
		 * @tooltip 						load image Data.  when loaded it a Gallery Loaded event is dispatched: 
		 * 								Gallery3dEvent( Gallery3dEvent.GALLERY_LOADED ) 
		 * @param 	uri : String		relative / full URL of data source
		 * @param 	baseUri : String	base url of data source
		 */
		public function loadImageData(uri : String, baseUri : String = '') : void {
			if ( usePixelPost ) {
				imageData.addEventListener(LoadEvent.LOADED_PIXELPOST_DATA, PxDataLoaded) ;

				if ( baseUri != '' )
					imageData.uri = baseUri;

				imageData.load(uri);
			} else {
				xImageData.addEventListener(LoadEvent.LOADED_PIXELPOST_DATA, PxDataLoaded) ;

				if ( baseUri != '' )
					xImageData.uri = baseUri;

				xImageData.load(uri);
			}
		}

		/**
		 * @method loadUserSettings ( uri : String ) : void 
		 * @tooltip load user / saved gallery settings
		 * @param uri : String		relative / full URL of data source
		 */
		public function loadUserSettings(uri : String) : void {
			savedUserSettings.addEventListener(LoadEvent.LOADED_DATA, UserSettingsLoaded) ;
			savedUserSettings.load(uri, true);
		}

		// ----------------------------------------------------
		// Data Functions - Use Once Data is Loaded
		// ----------------------------------------------------
		public function getSavedSettings() : Object {
			return savedUserSettingsObjectCollection;
		}

		/**
		 * @method setGalleryRenderer ( galleryController3D : GalleryController3D , galType : String )
		 * @tooltip assign a new renderer to the gallery - uses the loaded settings
		 * @param galleryController3D : GalleryController3D
		 * @param galType : String 
		 */
		public function setGalleryRenderer(galleryController3D : GalleryController3D, galType : String) : void {
			if ( !GalleryType.validate(galType) ) return;

			switch ( galType ) {
				case GalleryType.CAROUSEL:
					var carouselSettings : CarouselSettings = getRenderSettings(galType) as CarouselSettings;
					galleryController3D.setRenderer(new CarouselRenderer(carouselSettings));
					break;
				case GalleryType.COVERFLOW:
					var coverflowSettings : CoverflowSettings = getRenderSettings(galType) as CoverflowSettings;
					galleryController3D.setRenderer(new CoverFlowRenderer(coverflowSettings));
					break;
				case GalleryType.GRID:
					var gridSettings : GridSettings = getRenderSettings(galType) as GridSettings;
					galleryController3D.setRenderer(new GridRenderer(gridSettings));
					break;
				case GalleryType.STRIP:
					var stripSettings : StripSettings = getRenderSettings(galType) as StripSettings;
					galleryController3D.setRenderer(new StripRenderer(stripSettings));
					break;
				case GalleryType.RANDOM:
					var randomSettings : RandomSettings = getRenderSettings(galType) as RandomSettings;
					galleryController3D.setRenderer(new RandomRenderer(randomSettings));
					break;
			}

			galleryController3D.updateView();

			_selectedGalleryType = galType;
		}

		/**
		 * @method getRenderSettings( galleryType : String) : Object
		 * @tooltip return the render settings - 
		 * @param galleryType : String
		 * @return Object of type : 	com.kurst.controls.gallery3d.settings.CoverflowSettings
		 * 							com.kurst.controls.gallery3d.settings.GridSettings
		 * 							com.kurst.controls.gallery3d.settings.StripSettings
		 * 							com.kurst.controls.gallery3d.settings.CarouselSettings
		 * 							com.kurst.controls.gallery3d.settings.GallerySettings
		 */
		public function getRenderSettings(galleryType : String) : Object {
			GalleryType.validate(galleryType);
			// Validate the gallery Type
			loadSavedSettings(galleryType);
			// refresh / load the saved settings
			return getlocalRendererSettings(galleryType);
			// return the settings object
		}

		/**
		 * @method getGallerySettings( ) : GallerySettings
		 * @tooltip refresh and load the gallery settings
		 * @return GallerySetting
		 */
		public function getGallerySettings() : GallerySettings {
			// get the saved presets
			var savedPresets : Object = getAllSavedSettings(GalleryType.GALLERY);

			// refresh the gallery settings object
			for ( var i : String in savedPresets )
				gallerySettings[i] = savedPresets[i];

			// and return
			return gallerySettings;
		}

		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		//
		// PPPPPP  RRRRR   IIIIII V     V   AAA   TTTTTT EEEEEEE
		// PP   PP RR  RR    II   V     V  AAAAA    TT   EE
		// PPPPPP  RRRRR     II    V   V  AA   AA   TT   EEEE
		// PP      RR  RR    II     V V   AAAAAAA   TT   EE
		// PP      RR   RR IIIIII    V    AA   AA   TT   EEEEEEE
		//
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * @method loadSavedSettings( galleryType : String ) : void
		 * @tooltip load / refresh the saved settings from local object
		 * @param GalleryType reference
		 */
		private function loadSavedSettings(galleryType : String) : void {
			if ( !GalleryType.validate(galleryType) ) return;

			var selectedGalleryObj : Object = getlocalRendererSettings(galleryType);
			var savedPresets : Object = getAllSavedSettings(galleryType);

			var i : String;

			if ( savedPresets == null ) {
				trace('GalleryDataLoader.loadSavedSettings ( savedPresets == null );');
				return;
			}
			// if ( savedPresets == null ) return

			for ( i in savedPresets ) {
				if ( selectedGalleryObj.hasOwnProperty(i) )
					selectedGalleryObj[i] = savedPresets[i]
				else
					trace('Setting: ' + galleryType + ': ' + i + ' Does not exist');
			}
		}

		/**
		 * @method getlocalRendererSettings( galleryType : String) : Object
		 * @tooltip get the local render settings object
		 * @param GalleryType
		 * @return Object of type : 	com.kurst.controls.gallery3d.settings.CoverflowSettings
		 * 							com.kurst.controls.gallery3d.settings.GridSettings
		 * 							com.kurst.controls.gallery3d.settings.StripSettings
		 * 							com.kurst.controls.gallery3d.settings.CarouselSettings
		 * 							com.kurst.controls.gallery3d.settings.GallerySettings
		 */
		private function getlocalRendererSettings(galleryType : String) : Object {
			GalleryType.validate(galleryType);

			switch ( galleryType ) {
				case GalleryType.COVERFLOW :
					return coverflowSettings;
					break;
				case GalleryType.GRID :
					return gridSettings;
					break;
				case GalleryType.STRIP :
					return stripSettings;
					break;
				case GalleryType.CAROUSEL :
					return carouselSettings;
					break;
				case GalleryType.RANDOM :
					return randomSettings;
					break;
				case GalleryType.GALLERY :
					return gallerySettings;
					break;
			}

			return {};
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
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -DATA -----------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * @method getAllSavedSettings
		 * @tooltip get all saved settings for a data group
		 * @param groupName : String
		 */
		public function getAllSavedSettings(group : String) : Object {
			return savedUserSettingsObjectCollection[ group ];
		}

		/**
		 * @method getSavedSetting( group : String , settingName : String ) : *
		 * @tooltip get a saved value settings for any GalleryType
		 * @param group : String - GalleryType
		 * @param 
		 * @return setting 
		 */
		public function getSavedSetting(group : String, settingName : String) : * {
			if ( savedUserSettingsObjectCollection == null ) return null;

			if ( savedUserSettingsObjectCollection[ group ] != null ) {
				if ( savedUserSettingsObjectCollection[ group ] [ settingName ] != null ) {
					return savedUserSettingsObjectCollection[ group ] [ settingName ];
				} else {
					// No Saved Setting - Check if there is a default in the RenderSettings

					var obj : Object = getRenderSettings(group);

					if ( obj.hasOwnProperty(settingName) ) {
						return obj [ settingName ]
					} else {
						// No Value for this object - must be an error in configuration file
						return null;
					}

					// return null ;
				}
			} else {
				return null;
			}
		}

		/**
		 * @method saveSetting( group : String , settingName : String , value : * )
		 * @tooltip save a setting
		 * @param group : String - name of group ( GalleryType )
		 * 
		 */
		public function saveSetting(group : String, settingName : String, value : *) : void {
			if ( value != undefined ) {
				if ( savedUserSettingsObjectCollection [ group ] == null )
					savedUserSettingsObjectCollection[ group ] = new Object();

				savedUserSettingsObjectCollection[ group ] [ settingName ] = value;
			}
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PROPERTIES -----------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * @method usePixelPost
		 * @tooltip use a pixelpost RSS feed
		 * @param Boolean. 
		 */
		public function get selectedGalleryType() : String {
			return _selectedGalleryType;
		}

		public function set selectedGalleryType(value : String) : void {
			_selectedGalleryType = value;
		}

		/**
		 * @method usePixelPost
		 * @tooltip use a pixelpost RSS feed
		 * @param Boolean. 
		 */
		public function get usePixelPost() : Boolean {
			return _usePixelPost;
		}

		public function set usePixelPost(usePixelPost : Boolean) : void {
			_usePixelPost = usePixelPost;
		}

		/**
		 * @method randomizeImages
		 * @tooltip randomizeImages the images in the gallery
		 * @param Boolean
		 */
		public function get randomizeImages() : Boolean {
			return _randomizeImages;
		}

		public function set randomizeImages(randomizeImages : Boolean) : void {
			_randomizeImages = randomizeImages;
		}

		/**
		 * @method 
		 * @tooltip
		 * @param
		 */
		public function get backgroundColour() : uint {
			return _backgroundColour;
		}

		public function set backgroundColour(backgroundColour : uint) : void {
			_backgroundColour = backgroundColour;
		}

		// -EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		//
		// EEEEEEE V     V EEEEEEE NN  NN TTTTTT         HH   HH   AAA   NN  NN DDDDDD  LL      EEEEEEE RRRRR    SSSSS
		// EE      V     V EE      NNN NN   TT           HH   HH  AAAAA  NNN NN DD   DD LL      EE      RR  RR  SS
		// EEEE     V   V  EEEE    NNNNNN   TT           HHHHHHH AA   AA NNNNNN DD   DD LL      EEEE    RRRRR    SSSS
		// EE        V V   EE      NN NNN   TT           HH   HH AAAAAAA NN NNN DD   DD LL      EE      RR  RR      SS
		// EEEEEEE    V    EEEEEEE NN  NN   TT           HH   HH AA   AA NN  NN DDDDDD  LLLLLLL EEEEEEE RR   RR SSSSS
		//
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * @method checkAllLoaded()
		 * @tooltip 	check all the data is loaded, image and gallery settings.  If it's all loaded -
		 * 			dispatch a  Gallery3dEvent.ALL_DATA_LOADED event 
		 */
		private function checkAllLoaded() : void {
			if ( userSettingsLoaded && imageDataLoaded ) {
				dispatchEvent(new Gallery3dEvent(Gallery3dEvent.ALL_DATA_LOADED));
			}
		}

		/**
		 * @method UserSettingsLoaded( e : LoadEvent ) : void
		 * @tooltip user settings loaded
		 * @param e : LoadEvent
		 */
		private function UserSettingsLoaded(e : LoadEvent) : void {
			savedUserSettings.removeEventListener(LoadEvent.LOADED_DATA, UserSettingsLoaded) ;

			var groupNames : Array = savedUserSettings.enumerateGroups();
			var userPresets : ArrayCollection
			var groupName : String
			var rec : Object

			for ( var s : String in groupNames ) {
				groupName = groupNames[s] ;
				userPresets = savedUserSettings.getGroup(groupName);

				for ( var c : int = 0 ; c < userPresets.length ; c++ ) {
					rec = userPresets.getItemAt(c) ;
					saveSetting(groupName, rec.name, rec.value);
				}
			}

			userSettingsLoaded = true;
			dispatchEvent(new Gallery3dEvent(Gallery3dEvent.USERSETTINGS_LOADED));

			checkAllLoaded()
		}

		/**
		 * @method PxDataLoaded( e : LoadEvent ) : void 
		 * @tooltip image data loaded
		 * @param e : Load Event
		 * @return e : LoadEvent
		 */
		private function PxDataLoaded(e : LoadEvent) : void {
			if ( usePixelPost ) {
				// Pixelpost data

				if ( _randomizeImages ) ArrayUtils.ShuffleCollection(imageData.data)
				imageCollection = imageData.data
				imageDataLoaded = true;
			} else {
				// Custom / user data

				if ( _randomizeImages ) ArrayUtils.ShuffleCollection(xImageData.data)
				imageCollection = xImageData.data
				imageDataLoaded = true;
			}

			dispatchEvent(new Gallery3dEvent(Gallery3dEvent.GALLERY_LOADED));
			checkAllLoaded()
		}
	}
}