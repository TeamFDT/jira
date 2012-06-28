package com
{
   import flash.text.TextField;
   import flash.system.System;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.Timer;
   import flash.utils.getTimer;

   public class LoadingTest extends Sprite
   {
      private var _timer : Timer;
      private var _file : Array;
      private var _loader : Loader;
      private var _currentSwf : int = 0;
      private var _action : int = 0;
      private var _tf : TextField;
      private var _startMem : Number;
      private var _timerStart : Timer;
      private var _iteration : Number=0;
      private var _maxIterations : int = 5;

      public function LoadingTest()
      {
         _file = ["P1.swf"];
         _loader = new Loader();

         _tf = new TextField();
         _tf.width = stage.stageWidth;
         _tf.height = stage.stageHeight;
         _tf.text = "";
         addChild(_tf);

         _timerStart = new Timer(1000, 1);
         _timerStart.addEventListener(TimerEvent.TIMER, startTimer);
         _timerStart.start();
      }

      private function startTimer(event : TimerEvent) : void
      {
         _timerStart.removeEventListener(TimerEvent.TIMER, startTimer);

         _timer = new Timer(100);
         _timer.addEventListener(TimerEvent.TIMER, onTimer);
         _timer.start();
         _startMem = System.privateMemory;
      }

      private function onTimer(event : TimerEvent) : void
      {
         if (_action == 0)
         {
            _timer.stop();
            if (_currentSwf == _file.length)
            {
               _iteration++;
               _currentSwf = 0;
               _tf.appendText("next iteration" + "\n" + "\n");
            }
            if (_iteration >= _maxIterations)
               return;

            _tf.appendText("before loading   " + _file[_currentSwf] + " " + toMB(System.privateMemory) + "\n");

            var ldrContext : LoaderContext = new LoaderContext(false, new ApplicationDomain(ApplicationDomain.currentDomain));
            _loader.contentLoaderInfo.addEventListener(Event.INIT, onAppLoaded);
            _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            var filename : String = _file[_currentSwf];
            _currentSwf++;

            _loader.load(new URLRequest(filename)/*, ldrContext*/);
         }
         else if (_action == 1)
         {
            _tf.appendText("before unloading " + _file[_currentSwf - 1] + " " + toMB(System.privateMemory) + "\n");
            _loader.unload();
            _action = 2;
         }
         else
         {
            _tf.appendText("before gc        " + _file[_currentSwf - 1] + " " + toMB(System.privateMemory) + "\n");
            System.gc();
            _tf.appendText("after  gc        " + _file[_currentSwf - 1] + " " + toMB(System.privateMemory) + "\n" + "\n");
            _action = 0;
         }
      }

      private function onIOError(event : IOErrorEvent) : void
      {
      }

      private function onAppLoaded(event : Event) : void
      {
         _action = 1;
         _timer.start();
      }

      private function toMB(n : Number) : String
      {
         return ((n - _startMem) * 0.000000954).toFixed(3);
      }
   }
}
