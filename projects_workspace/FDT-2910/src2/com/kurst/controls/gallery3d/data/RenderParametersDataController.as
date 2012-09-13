/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.controls.gallery3d.data.RenderParametersDataController
 * Version 	  	: 1
 * Description 	: Load Render Parameters - controll parameters for each gallery type
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti
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
 **********************************************************************************************************************************************************************************/
package com.kurst.controls.gallery3d.data {
	import com.kurst.controls.gallery3d.constants.GalleryType;
	import com.kurst.controls.gallery3d.data.RenderParameterDataItem;
	import com.kurst.data.XmlToCollection;
	import com.kurst.events.Gallery3dEvent;
	import com.kurst.events.LoadEvent;
	import com.kurst.events.eventDispatcher;

	import mx.collections.ArrayCollection;

	public class RenderParametersDataController extends eventDispatcher {
		private var rendererSettings : XmlToCollection;
		private var importPresetDataItem : RenderParameterDataItem;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function RenderParametersDataController() {
			rendererSettings = new XmlToCollection();
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * @method loadUserSettings ( uri : String ) : void 
		 * @tooltip load user / saved gallery settings
		 * @param uri : String		relative / full URL of data source
		 */
		public function loadRendererParameters(uri : String) : void {
			rendererSettings.customDataClass = RenderParameterDataItem;
			rendererSettings.addEventListener(LoadEvent.LOADED_DATA, RendererPresetsLoaded) ;
			rendererSettings.load(uri, true);
		}

		/**
		 * @method 
		 * @tooltip
		 * @param 
		 */
		public function getParametersByGroup(galleryType : String, presetGroup : String) : ArrayCollection {
			var results : ArrayCollection = new ArrayCollection();
			var ac : ArrayCollection = getParameters(galleryType);

			for ( var c : int = 0 ; c < ac.length ; c++ ) {
				var rec : Object = ac.getItemAt(c);

				if ( rec.group == presetGroup )
					results.addItem(rec);
			}

			return results;
		}

		/**
		 * @method 
		 * @tooltip
		 * @param 
		 */
		public function getParameters(galleryType : String) : ArrayCollection {
			if ( !GalleryType.validate(galleryType) ) {
				trace('com.kurst.controls.gallery3d.data.RenderPresetsDataController.getPresets( g ) GalleryType - Error')
				return new ArrayCollection();
			}

			var allPresetsForGalleryType : ArrayCollection = getGalleryTypePresetList(galleryType);

			return allPresetsForGalleryType;
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * @method 
		 * @tooltip
		 * @param 
		 */
		private function getGalleryTypePresetList(galleryType : String) : ArrayCollection {
			var galleryTypes : ArrayCollection = rendererSettings.getGroup('GalleryTypes');
			var settingsGroups : Array

			for ( var gt : int = 0 ; gt < galleryTypes.length ; gt++ ) {
				var gtRec : Object = galleryTypes.getItemAt(gt);

				if ( gtRec.id == galleryType  ) {
					settingsGroups = gtRec.settings as Array;
				}
			}

			if ( settingsGroups == null ) {
				trace('com.kurst.controls.gallery3d.data.RenderParametersDataController.getGalleryTypePresetList( g ) settingsGroups - Error')
				return new ArrayCollection();
			}

			var returnArrayCollection : ArrayCollection = new ArrayCollection();

			for ( var sg : int = 0 ; sg < settingsGroups.length ; sg++ ) {
				var settingsGroup : ArrayCollection = rendererSettings.getGroup(settingsGroups[sg]);

				for ( var c : int = 0 ; c < settingsGroup.length ; c++ ) {
					returnArrayCollection.addItem(settingsGroup.getItemAt(c));
				}
			}

			return returnArrayCollection;
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -GET/SET----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 * @method AppSettingsLoaded( e : LoadEvent ) : void
		 * @tooltip application settings loaded
		 * @param e : LoadEvent
		 */
		private function RendererPresetsLoaded(e : LoadEvent) : void {
			rendererSettings.removeEventListener(LoadEvent.LOADED_DATA, RendererPresetsLoaded) ;
			dispatchEvent(new Gallery3dEvent(Gallery3dEvent.RENDER_PARAMETERS_LOADED));
		}
	}
}