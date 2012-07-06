package
{
    import com.bit101.components.PushButton;

    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.utils.ByteArray;

    /**
     * (c) HuzuTech 2011
     */
    [SWF(width="640",height="480")]
    public class Main extends Sprite
    {
        public var _button : PushButton;

        public var _currentState : int = 0;
        public static var NOTHING : int = 0;
        public static var LOADED : int = 1;
        public static var UNLOADED : int = 2;
        public static var LOADED_AGAIN : int = 3;

        public var externalSWF : ITestInterface;

        private var _loader : URLLoader;
        private var _loaderData : ByteArray;

        public function Main()
        {
            _button = new PushButton();
            _button.label = "Load Other SWF";

            addChild(_button);
            _button.addEventListener(MouseEvent.CLICK, onButtonClicked);
        }

        private function onButtonClicked(event : MouseEvent) : void
        {
            switch(_currentState)
            {
                case NOTHING:
                    loadSWF();
                    _button.label = "Unload Other SWF";
                    _currentState = LOADED;
                    break;

                case LOADED:
                    unloadSWF();
                    _button.label = "Load Other SWF";
                    _currentState = UNLOADED;
                    break;
                case UNLOADED:
                    loadSWF();
                    _button.label = "SWF has been reloaded";
                    _button.enabled = false;
                    _currentState = LOADED_AGAIN;
                    break;

                default:

            }

        }

        private function unloadSWF() : void
        {
            externalSWF.getDisplayObjectContainer().addEventListener(Event.REMOVED_FROM_STAGE, onExternalRemoved);
            removeChild(externalSWF.getDisplayObjectContainer());
        }

        private function onExternalRemoved(event : Event) : void
        {
            externalSWF.getDisplayObjectContainer().removeEventListener(Event.REMOVED_FROM_STAGE, onExternalRemoved);
            externalSWF.getDisplayObjectContainer().loaderInfo.loader.unloadAndStop();
            externalSWF = null;
        }

        private function loadSWF() : void
        {
            var urlRequest : URLRequest = new URLRequest("External.swf");
            _loader = new URLLoader();
            _loader.dataFormat = URLLoaderDataFormat.BINARY;

            _loader.addEventListener(Event.COMPLETE, onLoadComplete);

            try
            {
                _loader.load(urlRequest);
            }
            catch (error : Error)
            {
                throw new Error("Loading External.swf failed - " + error.message);
            }

        }

        private function onLoadComplete(event : Event) : void
        {
            _loader.removeEventListener(Event.COMPLETE, onLoadComplete);
            var byteArray : ByteArray = new ByteArray();
            _loaderData = _loader.data as ByteArray;
            _loaderData.readBytes(byteArray);

            loadContentFromBytes();
        }

        private function loadContentFromBytes() : void
        {
            var applicationDomain : ApplicationDomain;
            applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);

            var context : LoaderContext = new LoaderContext(false, applicationDomain);
            var loader : Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onContentLoaded);
            loader.loadBytes(_loaderData , context);
        }

        private function onContentLoaded(event : Event) : void
        {
            var loaderInfo : LoaderInfo = event.currentTarget as LoaderInfo;
            loaderInfo.removeEventListener(Event.COMPLETE, onContentLoaded);

            externalSWF = loaderInfo.content as ITestInterface;

            addChild(externalSWF.getDisplayObjectContainer());
            externalSWF.getDisplayObjectContainer().x = externalSWF.getDisplayObjectContainer().y = 200;
        }
    }
}
