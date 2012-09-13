package com.kurst.visuals.audio {
	import flash.media.Microphone;

	/**
	 * @author karim
	 */
	public class MicrophoneUtils {
		private static var mic : Microphone;

		public static function getMicrophone(micIndec : int = -1, silenceLevel : int = 0) : Microphone {
			if ( MicrophoneUtils.mic == null ) {
				MicrophoneUtils.mic = Microphone.getMicrophone(micIndec);
				MicrophoneUtils.mic.gain = 100;
				MicrophoneUtils.mic.rate = 22
				MicrophoneUtils.mic.setUseEchoSuppression(true)
			}

			MicrophoneUtils.mic.setSilenceLevel(silenceLevel);

			return MicrophoneUtils.mic;
		}
	}
}