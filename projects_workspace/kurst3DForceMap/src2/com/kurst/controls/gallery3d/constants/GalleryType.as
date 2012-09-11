/*********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.controls.gallery3d.constants.GalleryType
 * Version 	  	: 1
 * Description 	: Enumeration of the various gallery types
 * 
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Karim Beyrouti
 * Date 			: 15.11.09 
 * 
 ********************************************************************************************************************************************************************************
 * 
 * PROPERTIES
 * 		GalleryType.GRID
 * 		GalleryType.STRIP
 *		GalleryType.CAROUSEL
 *		GalleryType.COVERFLOW
 *		GalleryType.GALLERY
 * 
 ********************************************************************************************************************************************************************************
 *********************************************************************************************************************************************************************************
 * NOTES			:
 **********************************************************************************************************************************************************************************/
package com.kurst.controls.gallery3d.constants {
	import mx.collections.ArrayCollection;

	/**
	 * @author karim
	 */
	public class GalleryType {
		private static const _GRID : String = "GridSettings";
		private static const _STRIP : String = "StripSettings";
		private static const _CAROUSEL : String = "CarouselSettings";
		private static const _COVERFLOW : String = "CoverflowSettings";
		private static const _RANDOM : String = "RandomSettings";
		private static const _GALLERY : String = "GallerySettings";
		private static const _RAMDOM_LABEL : String = "Random";
		private static const _GRID_LABEL : String = "Grid";
		private static const _STRIP_LABEL : String = "Strip";
		private static const _CAROUSEL_LABEL : String = "Carousel";
		private static const _COVERFLOW_LABEL : String = "Coverflow";
		private static const _GALLERY_LABEL : String = "GallerySettings";

		public static function validate(t : String) : Boolean {
			// NOTE : TO Implement
			var isValid : Boolean = true ;
			// ( _GRID || _STRIP ||  _CAROUSEL || _COVERFLOW || _GALLERY || _RANDOM );
			if ( !isValid ) trace('com.kurst.controls.gallery3d.constants: ' + t + ' invalidType');
			return isValid ;
		}

		public static function get GRID() : String {
			return _GRID
		}

		public static function get RANDOM() : String {
			return _RANDOM
		}

		public static function get STRIP() : String {
			return _STRIP
		}

		public static function get CAROUSEL() : String {
			return _CAROUSEL
		}

		public static function get COVERFLOW() : String {
			return _COVERFLOW
		}

		public static function get GALLERY() : String {
			return _GALLERY
		}

		[bindable]
		public static function enumerateGalleryTypes() : ArrayCollection {
			var ac : ArrayCollection = new ArrayCollection();

			ac.addItem({label:_RAMDOM_LABEL, data:_RANDOM})
			ac.addItem({label:_GRID_LABEL, data:_GRID})
			ac.addItem({label:_STRIP_LABEL, data:_STRIP})
			ac.addItem({label:_CAROUSEL_LABEL, data:_CAROUSEL})
			ac.addItem({label:_COVERFLOW_LABEL, data:_COVERFLOW});

			return ac;
		}
	}
}
