/******************************************************************************************************************************************************************************** *  * Class Name  	: com.kurst.controls.scrollbar.assets.ScrollBody * Version 	  	:  * Description 	:  *  ******************************************************************************************************************************************************************************** *  * Author 		:  * Date 			:  *  ******************************************************************************************************************************************************************************** *  * METHODS *  * * PROPERTIES *  * * EVENTS *  *  ******************************************************************************************************************************************************************************** **********************************************************************************************************************************************************************************/package com.kurst.controls.scrollbar.skins.simple {	import com.kurst.controls.scrollbar.assets.ScrollBody;	public class SScrollBody extends ScrollBody {		public function SScrollBody() {			graphics.beginFill(0x888888, 0);			graphics.drawRect(0, 0, 10, 50)			graphics.endFill();		}	}}