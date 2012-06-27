package com.sample {
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.Sprite;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.text.TextField;

	/**
	 * @author marc
	 */
	public class ExtendedProfileSample extends Sprite 
	{
		/**
		 * IMPORTANT NOTE - you will probably have to amend this path
		 * unless you have java installed in it's default location 
		 * on a windows machine
		 */
		private static const JAVA_HOME : String = "C:\\Program Files\\Java\\jre6";
		private var _output : TextField;


		public function ExtendedProfileSample() 
		{
			_output = new TextField();
			_output.width = stage.stageWidth;
			_output.height = stage.stageHeight;
			addChild(_output);
			_createNativeProcess();
		}

		private function _createNativeProcess() : void 
		{
			if(!NativeProcess.isSupported)return;
			
			var file:File = new File(JAVA_HOME);
			file = file.resolvePath("bin/javaw.exe");
			
			var arg:Vector.<String> = new Vector.<String>;
			arg.push("-jar");
			arg.push(File.applicationDirectory.resolvePath("HelloWorldEcho.jar").nativePath);
			
			var npInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			npInfo.executable = file;
			npInfo.arguments = arg;

			var nativeProcess : NativeProcess = new NativeProcess();
			nativeProcess.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, _onStandardOutputData);
			nativeProcess.start(npInfo);
		}

		private function _onStandardOutputData(event : ProgressEvent) : void 
		{
			var nativeProcess : NativeProcess = event.target as NativeProcess;
			var out : String = nativeProcess.standardOutput.readUTFBytes(nativeProcess.standardOutput.bytesAvailable);
			_output.appendText("\n"+out);
		}
	}
}
