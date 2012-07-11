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
		private const I : int = stage.stageHeight;;
		private const EXRADCTEd : int = 10;
		private var _output : TextField;
		private var zippy : int;


		public function ExtendedProfileSample() 
		{
			EXRADCTEd;
			
			zippy = 10;
			
			_output = new TextField();
			var i : int = stage.stageWidth;
			_output.width = i;
			_output.height = I
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
