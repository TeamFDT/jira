/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.controls.gallery3d.assets.GalleryMaterialAsset
 * Version 	  	: 1
 * Description 	: This class adds some CSS styling to the DynamicMaterialAsset, as well as Title and Description fields
 * 					for the PixelPost / XML gallery system. 	
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
 *	 See com.kurst.controls.gallery3d.assets.DynamicMaterialAsset for inherited Methods
 *	
 *
 * PROPERTIES
 * 
 * 	See com.kurst.controls.gallery3d.assets.DynamicMaterialAsset for inherited Properties
 * 	
 *
 * EVENTS
 * 
 *	See com.kurst.controls.gallery3d.assets.DynamicMaterialAsset for inherited Events
 * 
 ********************************************************************************************************************************************************************************
 * 				:
 *
 *
 *********************************************************************************************************************************************************************************
 * NOTES			: Started adding functions to load hi-res image / thumbnail to this class, however
 * 					i am not happy with the results and this feature still needs some work.
 **********************************************************************************************************************************************************************************/
package com.kurst.controls.gallery3d.assets {
	// import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.display.Sprite;

	import com.kurst.utils.StrUtils;
	import com.kurst.utils.FDelayCall;

	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import com.kurst.events.Gallery3dEvent

	public class GalleryMaterialAsset extends DynamicMaterialAsset {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private var _font : Class;
		private var _fontName : String;
		private var _border : Number = 50;
		private var _title : TextField;
		private var _description : TextField;
		private var _bgColour : uint = 0x000000
		private var _border_left : int = 0
		private var _border_right : int = 0
		private var _border_bottom : int = 0
		private var _border_top : int = 0
		private var _embedTitleFont : Boolean = true;
		private var _embedDescFont : Boolean = true;
		private var _useTitle : Boolean = true;
		private var _useDescription : Boolean = true;

		public function GalleryMaterialAsset() {
			super();

			_title = new TextField();
			_title.height = 25;
			_title.visible = false;

			_description = new TextField();
			_description.height = 25;
			_description.visible = false;

			addChild(_title);
			addChild(_description);
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
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function destroy() : void {
			super.destroy();
			if ( contains(_title)) {
				removeChild(_title);
				_title = null;
			}

			if ( contains(_description)) {
				removeChild(_description);
				_description = null;
			}
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function selectedAnimationComplete() : void {
			super.selectedAnimationComplete();
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function select() : void {
			super.select();
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function unSelect() : void {
			super.unSelect();

			doLayout();

			_description.visible = false;
			_title.visible = false;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function addSWF(s : MovieClip) : void {
			super.addSWF(s);
			doLayout();
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function addImage(bm : Bitmap) : void {
			super.addImage(bm);
			doLayout();
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function onSetStyleSheet() : void {
			// trace('onSetStyleSheet');

			parseStyles(styleSheet)

			_title.embedFonts = _embedTitleFont;
			_title.styleSheet = styleSheet;

			_description.embedFonts = _embedDescFont;
			_description.styleSheet = styleSheet;

			setTitle();
			setDescription();
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function onSetContent() : void {
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
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function parseStyles(s : StyleSheet) : void {
			if ( s == null ) return;
			// return if there is not stylesheet

			var o : Object

			// Parse Background Styles
			o = s.getStyle('.background')
			_bgColour = ( o.color != null ) ? uint("0x" + o.color.slice(1, o.color.length)) : _bgColour ;
			_border_left = ( o.borderLeft != null ) ? int(o.borderLeft) : _border_left ;
			// To Implement
			_border_right = ( o.borderRight != null ) ? int(o.borderRight) : _border_right ;
			// To Implement
			_border_top = ( o.borderTop != null ) ? int(o.borderTop) : _border_top ;
			// To Implement
			_border_bottom = ( o.borderBottom != null ) ? int(o.borderBottom) : _border_bottom ;
			// To Implement

			// Parse Title Styles
			o = s.getStyle('.title')
			_embedTitleFont = ( o.embedFont != null ) ? Boolean(StrUtils.convertString(o.embedFont, 'boolean')) : _embedTitleFont ;
			// To Implement

			// Parse Description Styles
			o = s.getStyle('.description')
			_embedDescFont = ( o.embedFont != null ) ? Boolean(StrUtils.convertString(o.embedFont, 'boolean')) : _embedDescFont ;
			// To Implement
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function setTitle() : void {
			if ( _useTitle ) {
				_title.multiline = false;
				_title.htmlText = '<span class="title">' + data.title + '</span>';
				_title.height = _title.textHeight + 2;
			}
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function setDescription() : void {
			if ( _useDescription ) {
				_description.multiline = true
				_description.width = width
				_description.wordWrap = true;
				_description.autoSize = TextFieldAutoSize.LEFT;

				_description.htmlText = '<span class="description">' + data.description + '</span>';
			}
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function doLayout() : void {
			if ( data == null ) return;

			if ( data.title != null && useTitle ) {
				_title.x = 0 ;
				_title.y = 0 ;
				_title.width = width;
				_title.visible = true;
				container.y = _title.height
			} else {
				_title.visible = false;

				if ( contains(_title))
					removeChild(_title)
			}

			if ( data.description != null && useDescription ) {
				_description.y = container.height + container.y + 1;
				// + _border_top / 2;
				_description.width = width;
				_description.visible = true;
			} else {
				_description.visible = false;

				if ( contains(_title))
					removeChild(_description)
			}

			if (data.description != null || data.title != null  ) {
				background.graphics.beginFill(_bgColour)
				background.graphics.drawRect(0, 0, width, height)
				background.graphics.endFill();

				background.visible = isSelected;
			}

			if ( movieMaterial != null ) {
				if ( movieMaterial.bitmap != null ) {
					FDelayCall.addCall(draw, this);
				}
			}
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
		 *  
		 * 
		 * @param
		 * @return
		 */
		override public function MouseDown(e : MouseEvent = null) : void {
			super.MouseDown(e);

			if ( !_description.visible && isSelected ) {
				_description.visible = true;
				_title.visible = true;
			} else {
				_description.visible = true;
				_title.visible = true;
			}

			doLayout();
		}

		public function get useTitle() : Boolean {
			return _useTitle;
		}

		public function set useTitle(useTitle : Boolean) : void {
			_useTitle = useTitle;
		}

		public function get useDescription() : Boolean {
			return _useDescription;
		}

		public function set useDescription(useDescription : Boolean) : void {
			_useDescription = useDescription;
		}
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// TEST
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// Loading thumbnail, then loading the large image. I am not happy with the results
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
	}
}