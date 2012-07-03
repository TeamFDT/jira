package 
{

	import flash.display.LoaderInfo;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	use namespace flash_proxy;
	
		
	/**
	 * 
	 * 	Application parameters manager.
	 * 
	 *	@author Rafael Rinaldi (rafaelrinaldi.com)
	 *	@since 10/11/2010
	 * 
	 */
	// TODO: Create a mock dictionary to save mock data?
	dynamic public class Parameters extends Proxy {
		protected var parameters : Dictionary;
		// Dictionary instance that will store all the parameters
		public var overrideParameters : Boolean;

		/**
		 *	@param p_overrideParameters Can parameters be overridden? (false by default)
		 */
		public function Parameters(p_overrideParameters : Boolean = false) {
			overrideParameters = p_overrideParameters;

			/** Initializing parameters. **/
			parameters = new Dictionary(true);
		}

		/**
		 * 
		 *	Parse parameters from flashvars. Just executes once.
		 * 
		 *	@param p_loaderInfo LoaderInfo instance.
		 * 
		 */
		public function injectLoaderInfo(p_loaderInfo : LoaderInfo) : void {
			const parameters : Object = p_loaderInfo.parameters;

			var name : String;
			var value : String;

			for (name in parameters) {
				value = parameters[name];

				flash_proxy::setProperty(name, value);
			}
		}

		/**
		 * 
		 *	Parse parameters. Just executes once.
		 * 
		 *	@param p_xml <code>parameters</code> node from config file.
		 * 
		 */
		public function injectXML(p_xml : *) : void {
			if (p_xml.length() == 0) return;

			var node : XML;
			var name : String;
			var value : String;

			for each (node in p_xml.children()) {
				name = node.name();
				value = node.text();

				flash_proxy::setProperty(name, value);
			}
		}

		/**
		 * 
		 *	@param p_name Property name.
		 *	@param p_value Property value.
		 * 
		 * */
		flash_proxy override function setProperty(p_name : *, p_value : *) : void {
			if (overrideParameters)
				parameters[p_name] = p_value;
			else if (isPropertyUndefined(p_name)) parameters[p_name] = p_value;
		}

		/**
		 * 
		 *	@param p_name Property name.
		 * 
		 *	@return Property value if exists.
		 * 
		 * */
		flash_proxy override function getProperty(p_name : *) : * {
			var value : *;
			var type : String;

			if (isPropertyUndefined(p_name)) return null;

			value = printf(parameters[p_name], this);
			// Applying printf to the value.
			type = guessType(value);
			// Discovering value type.

			/** Forcing value conversion. **/
			switch(type) {
				case BasicVariableType.BOOLEAN :
					value = toBoolean(value);
					break;
				case BasicVariableType.NUMBER :
					value = toNumber(value);
					break;
				case BasicVariableType.UNASSIGNED :
					value = null;
					break;
			}

			return value;
		}

		/**
		 * 	
		 * 	@private
		 * 
		 * 	Must be implemented to enable object indexes looping.
		 * 
		 * 	@param p_index Object index.
		 * 	@param Object index value.
		 * 
		 * */
		flash_proxy override function nextNameIndex(p_index : int) : int {
			if (p_index < keys.length)
				return p_index + 1;
			else
				return 0;
		}

		/**
		 * 
		 * 	@private	
		 * 
		 * 	Must be implemented to enable object indexes looping.
		 * 
		 * 	@param p_index Object index.
		 * 
		 * 	@return Object index key.
		 * 
		 * */
		flash_proxy override function nextName(p_index : int) : String {
			return keys[p_index - 1];
		}

		/**
		 * 
		 *	@private
		 * 
		 *	Must be implemented to extend Proxy class.
		 * 
		 * 	@param p_name Property name.
		 * 	@param ...rest Parameters.
		 * 
		 * 	@return Property value.
		 * 
		 * */
		flash_proxy override function callProperty(p_name : *, ...rest) : * {
		}

		/**
		 * 
		 *	@private
		 * 
		 *	@param p_name Property name.
		 * 
		 *	@return True if property was successfully deleted, false otherwise.
		 * 
		 * */
		flash_proxy override function deleteProperty(p_name : *) : Boolean {
			if (isPropertyUndefined(p_name)) return false;
			return Boolean(delete parameters[p_name]);
		}

		/**
		 * 
		 *	@param p_name Property name.
		 * 
		 *	@return True if property value is null, false otherwise.
		 * 
		 * */
		public function isPropertyNull(p_name : String) : Boolean {
			return Boolean(parameters[p_name] == null);
		}

		/**
		 * 
		 *	@param p_name Property name.
		 *	@return True if property value is undefined, false otherwise.
		 * 
		 * */
		public function isPropertyUndefined(p_name : String) : Boolean {
			return Boolean(parameters[p_name] == undefined);
		}

		/**
		 *	@return A String Vector with all registered keys.
		 * */
		internal function get keys() : Vector.<String> {
			var items : Vector.<String> = new Vector.<String>();

			for (var key : String in parameters)
				items.push(key);

			return items;
		}

		/**
		 *	@return A * Vector (aka black hole) with all registered values.
		 * */
		public function get values() : Vector.<*> {
			var items : Vector.<*> = new Vector.<*>();

			for (var key : String in parameters)
				items.push(parameters[key]);

			return items;
		}

		/**
		 *	Clear all the parameters and remove the Dictionary instance.
		 * */
		public function dispose() : void {
			var key : String;

			for each (key in keys)
				flash_proxy::deleteProperty(key);

			parameters = null;
		}

		public function toString() : String {
			return "[object Parameters]";
		}
	}
}
