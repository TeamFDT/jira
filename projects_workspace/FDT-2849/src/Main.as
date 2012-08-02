package {
	import swf.bridge.FdtEditorContext;
	import swf.bridge.IFdtActionBridge;
	import swf.plugin.ISwfActionPlugin;

	import flash.display.Sprite;
	import flash.utils.Dictionary;

	[FdtSwfPlugin(name="DemoActionPlugin", pluginType="action", toolTip="Demonstration of proposals")]
	public class Main extends Sprite implements ISwfActionPlugin {
		private var _picture : Class;
		private var _bridge : IFdtActionBridge;

		public function Main() {
			FdtSwfPluginIcon;
		}

		public function init(bridge : IFdtActionBridge) : void {
			_bridge = bridge;
		//	_bridge.ui.registerImage("MyCoolIcon", new _picture()).sendTo(null,null);			
		}

		public function createProposals(ec : FdtEditorContext) : void {
			_bridge.offerProposal("MyProposalId", "MyCoolIcon", "Insert The Phrase 'Hello World'", "Description of our proposal", onSelection);
		}

		private function onSelection(id : String, ec : FdtEditorContext) : void {

		}

		public function callEntryAction(entryId : String) : void {
		}

		public function setOptions(options : Dictionary) : void {
		}

		public function dialogClosed(dialogInstanceId : String, result : String) : void {
		}
	}
}