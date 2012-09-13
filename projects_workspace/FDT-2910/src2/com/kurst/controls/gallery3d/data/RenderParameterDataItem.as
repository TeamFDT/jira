/*
<preset>
<name 			type="string">scale</name>
<max 			type="number">1</max>
<min 			type="number">0</min>
<type			type="string">number</type>
<group			type="string">image</group>
</preset>
 */
/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: 
 * Version 	  	: 
 * Description 	: 
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
	import flash.display.Sprite;

	public class RenderParameterDataItem {
		public var id : String;
		private var _name : String
		private var _min : Number
		private var _max : Number
		private var _group : String
		private var _settings : Array;
		private var _type : String

		public function RenderParameterDataItem() {
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -GET/SET----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function get type() : String {
			return _type;
		}

		public function set type(value : String) : void {
			_type = value;
		}

		public function get settings() : Array {
			return _settings;
		}

		public function set settings(value : Array) : void {
			_settings = value;
		}

		public function get name() : String {
			return _name;
		}

		public function set name(value : String) : void {
			_name = value;
		}

		public function get group() : String {
			return _group;
		}

		public function set group(value : String) : void {
			_group = value;
		}

		public function get max() : Number {
			return _max;
		}

		public function set max(value : Number) : void {
			_max = value;
		}

		public function get min() : Number {
			return _min;
		}

		public function set min(value : Number) : void {
			_min = value;
		}
	}
}