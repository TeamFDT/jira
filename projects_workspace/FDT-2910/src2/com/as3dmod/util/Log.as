package com.as3dmod.util {
	// import nl.demonsters.debugger.MonsterDebugger;
	/**
	 * @author Bartek Drozdz
	 */
	public class Log {
		// private static var debugger:MonsterDebugger;
		public static function init(root : Object) : void {
			// debugger = new MonsterDebugger(root);
		}

		public static function info(target : Object, msg : Object) : void {
			// MonsterDebugger.trace(target, msg);
			trace(target, msg);
		}

		public static function error(target : Object, msg : Object) : void {
			// MonsterDebugger.trace(target, msg, 0xff0000);
			trace(target, msg, 0xff0000);
		}
	}
}
