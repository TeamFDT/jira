/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.kurst.controls.listbox.renderer.DynamicListItem
 * Version 	  	: 1
 * Description 	: Basic list item - that is dynamic and does not rely on library assets
 ********************************************************************************************************************************************************************************
 * 
 * Author 		: Kb
 * Date 			: 08/02/09
 * 
 ********************************************************************************************************************************************************************************
 * 
 * METHODS
 * 
 *		destroy():void
 *		function draw():void
 *		setData( obj : Object ) : void
 *		setSelected( flag : Boolean ):void
 *		setSelectable( flag : Boolean ):void
 *		setText ( t : String ) : void 
 *		getText ():String
 *
 * PROPERTIES
 * 
 *		id ():Number
 *		data ():Object
 *		selected () : Boolean
 *		selectable ():Boolean 
 *		text ():String
 *
 * EVENTS
 * 
 * 		ListBoxEvent.SELECT_ITEM
 * 
 **********************************************************************************************************************************************************************************/
package com.kurst.controls.listbox {
	import com.kurst.controls.listbox.core.ListItem;
	import com.kurst.events.ListBoxEvent;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class SimpleListItem extends ListItem {
		
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var rollOver 			: Sprite;
		private var label 				: TextField;
		private var addedToStageFlag 	: Boolean = false;
		private var buttonClip 			: Sprite;
		private var tf 					: TextFormat;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		public function SimpleListItem() {
			addEventListener(Event.ADDED_TO_STAGE, AddedToStage, false, 0, true);
			addChild(label = new TextField());

			rollOver = new Sprite();
			buttonClip = new Sprite();

			_height = height = 20;
			_width = width = 193;

			label.x = 5;
			label.selectable = false;
			label.y = 2;
			label.height = _height;
			// label.background	= true;

			tf = new TextFormat();
			tf.font = "Arial";
			tf.size = 12;
			tf.bold = false;
			tf.color = 0x36A03B;

			cacheAsBitmap = true;
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
		 * @method setSize(w:Number, h:Number ):void
		 * @tooltip set the size of the list item
		 */
		override public function setSize(w : Number, h : Number) : void {
			if ( isNaN(height) && height != 0 ) {
				super.setSize(w, h);
			} else {
				super.setSize(w, height);
			}

			if ( label != null )
				label.width = w;

			draw();
		}
		/**
		 * @method destroy() : void
		 * @tooltip destroy the list item
		 */
		override public function destroy() : void {
			data = null;

			buttonClip.removeEventListener(MouseEvent.ROLL_OVER, RollOver);
			buttonClip.removeEventListener(MouseEvent.ROLL_OUT, RollOut);
			buttonClip.removeEventListener(MouseEvent.CLICK, Click);
		}
		/**
		 * @method draw() : void 
		 * @tooltip draw the list item
		 */
		override protected function draw() : void {
			if ( isNaN(width) || isNaN(height)) return ;

			label.width = width - 10;

			if ( addedToStageFlag ) {
				rollOver.graphics.clear();
				rollOver.graphics.beginFill(0x76df6a, .24);
				rollOver.graphics.drawRect(0, 0, width, height);
				rollOver.graphics.endFill();
				rollOver.visible = false;

				buttonClip.graphics.clear();
				buttonClip.graphics.beginFill(0x000FF0, 0);
				buttonClip.graphics.drawRect(0, 0, width, height);
				buttonClip.graphics.endFill();
			}
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
		 * @method setData( obj : Object ) : void
		 * @tooltip assign a Object as Data to the list item
		 * @param Object - 
		 */
		override protected function setData(obj : Object) : void {
			if ( obj != null ) {
				label.text = obj['label'];
				label.setTextFormat(tf);
			}
		}
		/**
		 * @method setSelected( flag : Boolean ):void
		 * @tooltip select / de-select the list item
		 * @param Flag
		 */
		override protected function setSelected(flag : Boolean) : void {
			if ( flag ) {
				rollOver.visible = true;
				// arrowContainer.visible = true;
			} else {
				rollOver.visible = false;
				// arrowContainer.visible = false;
			}
		}
		/**
		 * @method setSelectable( flag : Boolean ):void
		 * @tooltip set whether the list item is selectable
		 * @param flag - boolean
		 */
		override protected function setSelectable(value : Boolean) : void {
			buttonClip.removeEventListener(MouseEvent.ROLL_OVER, RollOver);
			buttonClip.removeEventListener(MouseEvent.ROLL_OUT, RollOut);
			buttonClip.removeEventListener(MouseEvent.CLICK, Click);

			if ( value ) {
				buttonClip.addEventListener(MouseEvent.ROLL_OVER, RollOver, false, 0, true);
				buttonClip.addEventListener(MouseEvent.ROLL_OUT, RollOut, false, 0, true);
				buttonClip.addEventListener(MouseEvent.CLICK, Click, false, 0, true);
			} else {
				buttonClip.removeEventListener(MouseEvent.ROLL_OVER, RollOver);
				buttonClip.removeEventListener(MouseEvent.ROLL_OUT, RollOut);
				buttonClip.removeEventListener(MouseEvent.CLICK, Click);

				selected = false;
			}
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
		 * @method setText ( t:String):Void
		 * @tooltip set the text
		 * @param string - text to apply to label
		 */
		override public function setText(t : String) : void {
			label.text = t;

			label.setTextFormat(tf);
		}
		/**
		 * @method getText ():String
		 * @tooltip return the label text
		 * @return string
		 */
		override public function getText() : String {
			var l : TextField = label;
			return l.text;
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
		 * @method 
		 * @tooltip
		 * @return 
		 */
		override public function Click(e : MouseEvent = null) : void {
			var sItem : ListBoxEvent = new ListBoxEvent(ListBoxEvent.SELECT_ITEM, true);
			sItem.data = data;
			dispatchEvent(sItem);
		}
		/**
		 * @method 
		 * @tooltip
		 * @return 
		 */
		private function AddedToStage(e : Event) : void {
			addedToStageFlag = true;
			selectable = selectable;

			addChild(rollOver);
			addChild(label);
			addChild(buttonClip);
			draw();
		}
		/**
		 * @method 
		 * @tooltip
		 * @return 
		 */
		override protected function RollOut(e : MouseEvent) : void {
			if ( !selected )
				rollOver.visible = false;
		}
		/**
		 * @method 
		 * @tooltip
		 * @return 
		 */
		override protected function RollOver(e : MouseEvent) : void {
			if ( !selected )
				rollOver.visible = true;
		}
	}
}