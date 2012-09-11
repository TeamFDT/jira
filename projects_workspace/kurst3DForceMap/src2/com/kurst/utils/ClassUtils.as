package com.kurst.utils {
	import flash.display.MovieClip;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author karim
	 */
	public class ClassUtils {
		public static  function getSuperClass(obj : Object) : String {
			var superClass : String = describeType(obj).@base;
			var isBase : Boolean = ( superClass == '' )

			if ( isBase )
				return getClassName(obj);
			else
				return StrUtils.replaceChar(superClass, '::', '.')

			return '';
		}

		public static function getFullClassPath(obj : *) : String {
			var className : String = getQualifiedClassName(obj);

			if ( className != null ) {
				if ( className.indexOf('::') == -1 ) {
					return className;
				} else {
					return StrUtils.replaceChar(className, '::', '.')
				}
			} else {
				return '';
			}
		}

		public static function getClassName(obj : *) : String {
			var className : String = getQualifiedClassName(obj);

			if ( className != null ) {
				if ( className.indexOf('::') == -1 ) {
					return className;
				} else {
					return className.substr(className.indexOf('::') + 2, className.length)
				}
			} else {
				return '';
			}
		}

		public static function createMcFromClassString(_symbol : String) : MovieClip {
			// Reference the class
			var classDefintion : Class = getDefinitionByName(_symbol) as Class;
			// create a new MovieClip;
			return new classDefintion();
		}

		public static function createMcFromLinkageID(_symbol : String) : MovieClip {
			// Reference the class
			var classDefintion : Class = getDefinitionByName(_symbol) as Class;
			// create a new MovieClip;
			return ( new classDefintion() as MovieClip )
		}
	}
}
