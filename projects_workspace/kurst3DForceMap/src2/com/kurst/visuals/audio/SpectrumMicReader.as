/**
 * Copyright (c) 2008 Bartek Drozdz (http://www.everydayflash.com)
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */
/********************************************************************************************************************************************************************************
 * 
 * Class Name  	: com.everydayflash.equalizer.util.SpectrumMicReader
 * Version 	  	: 1.1
 * Description 	:	This utility class read the byets from the SoundMixer.computeSpectrum byte array
 * 					and transform it into an Array of numbers renging from 0 to 1 of the given size.
 * 
 * 					It has several different methods to reduce to 512 values from  the spectrum to the size expected, 
 * 					including arithmetic and geometric means and a median. 
 * 
 * 					@param _size Size of the result array - corrseponds to the number of bars in the Equalizer.
 * 
 * 					It is strongly recommeded that size is a value that is a power of 2. It was not tested on any other
 * 					values.
 * 					
 ********************************************************************************************************************************************************************************
 * 
 * Author 		:
 *
 *	 @version 1.1
 *	 @author Karim Beyrouti (http://www.kurst.co.uk )\
 *	   
 *	 @version 1.0
 *	 @author Bartek Drozdz (http://www.everydayflash.com)
 *
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
package com.kurst.visuals.audio {
	import flash.media.SoundChannel;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;

	public class SpectrumMicReader {
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public static var GEOMETRIC_MEAN : String = 'GEOMITRIC_MEAN';
		public static var MEDIAN : String = 'MEDIAN';
		public static var BY_ARITHMETIC_MEAN : String = 'byArithmeticMean'
		public static var BY_MAXIMUM_VALUES : String = "BY_MAXIMUM_VALUES";
		public static var BY_MEDIAN_NO_ZERO : String = "BY_MEDIAN_NO_ZERO";
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private var micEnabled : Boolean = false;
		private var _useRawMicData : Boolean = false;
		private var _multiplier : Number = 1;
		private var SPECTRUM_LENGTH : Number = 512;
		private var bytes : ByteArray;
		private var reduction : int;
		private var _size : int;
		private var resultTemplate : Array;
		private var sound : Sound;
		private var micSoundBytes : ByteArray;
		private var soundTrans : SoundTransform;
		private var audioProcessFunct : Function = byArithmeticMean
		private var soundChannel : SoundChannel;

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function SpectrumMicReader(size : int, spectrumLength : Number = 512) {
			SPECTRUM_LENGTH = spectrumLength;
			_size = size;
			reduction = Math.round(SPECTRUM_LENGTH / _size);
			bytes = new ByteArray();
			resultTemplate = new Array();

			for (var i : int = 0; i < _size; i++) resultTemplate.push(0);
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function getLeftChannel() : void {
			if ( soundChannel )
				trace(soundChannel.leftPeak);
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function destroy() : void {
			if ( micEnabled ) {
				MicrophoneUtils.getMicrophone().removeEventListener(SampleDataEvent.SAMPLE_DATA, onMicSampleData);
			}

			if ( sound != null ) {
				sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, soundPlaybackSampleHandler);
				sound = null;
			}

			if ( micSoundBytes != null ) {
				micSoundBytes.clear()
				micSoundBytes = null;
			}

			resultTemplate = null;
			if ( bytes != null ) {
				bytes.clear();
			}
			bytes = null;
			audioProcessFunct = null;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function enableMicrophone(_useRawData : Boolean = true, index : int = -1) : void {
			micEnabled = true;
			_useRawMicData = _useRawData;

			MicrophoneUtils.getMicrophone().addEventListener(SampleDataEvent.SAMPLE_DATA, onMicSampleData);

			if ( !_useRawMicData ) {
				micSoundBytes = new ByteArray();
				sound = new Sound();

				sound.addEventListener(SampleDataEvent.SAMPLE_DATA, soundPlaybackSampleHandler);

				soundTrans = new SoundTransform();
				soundTrans.volume = 0;

				soundChannel = sound.play(0, 0);

				// trace('initChannel')
			}

			// trace('enableMicrophone')
		}

		public function getRawAudioSpectrum() : Array {
			var result : Array;
			SoundMixer.computeSpectrum(bytes, true, 0);
			result = getRawArray(bytes) ;

			return reverseLeftChannel(result);
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function getSpectrum() : Array {
			SoundMixer.computeSpectrum(bytes, true, 0);
			return multiply(reverseLeftChannel(audioProcessFunct(bytes)), _multiplier);
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function getMicSpectrum() : Array {
			if ( !_useRawMicData ) {
				SoundMixer.computeSpectrum(bytes, true, 0);
			} else {
				bytes = micSoundBytes;
			}

			if ( bytes == null ) return null;

			if ( bytes.length > 0 ) {
				try {
					return multiply(reverseLeftChannel(audioProcessFunct(bytes)), _multiplier);
				} catch (e : Error) {
					return null;
				}
			}

			return null;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function getSize() : int {
			return _size;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function setAudioFunction(mode : String) : void {
			switch ( mode ) {
				case SpectrumMicReader.MEDIAN :
					audioProcessFunct = byMedian
					break;
				case SpectrumMicReader.GEOMETRIC_MEAN :
					audioProcessFunct = byGeometricMean
					break;
				case SpectrumMicReader.BY_ARITHMETIC_MEAN :
					audioProcessFunct = byGeometricMean
					break;
				case SpectrumMicReader.BY_MAXIMUM_VALUES :
					audioProcessFunct = byMaximumValues
					break;
				case SpectrumMicReader.BY_MEDIAN_NO_ZERO :
					audioProcessFunct = byMedianNoZero
					break;
			}
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private function getRawArray(spectrum : ByteArray) : Array {
			var result : Array = new Array();

			for (var i : int = 0; i < SPECTRUM_LENGTH; i++) {
				result.push(spectrum.readFloat())
				// byArMean[  int( i / reduction) ] += ;
			}

			return result;
		}

		/**
		 * This and the following methods reduce the data from the spectrum bytearray to an array of Numbers of the correct size 
		 * (= value of the 'size' property). 
		 * 
		 * This method returns the maximum value from each group. 
		 */
		private function byMaximumValues(spectrum : ByteArray) : Array {
			var byMax : Array = resultTemplate.concat();

			for (var i : uint = 0; i < SPECTRUM_LENGTH; i++)
				byMax[Math.floor(i / reduction)] = Math.max(spectrum.readFloat(), byMax[Math.floor(i / reduction)]);

			return byMax;
		}

		/**
		 * This method returns the common average value ('arithmetic mean') from each group.
		 */
		private function byArithmeticMean(spectrum : ByteArray) : Array {
			var byArMean : Array = resultTemplate.concat();

			for (var i : int = 0; i < SPECTRUM_LENGTH; i++) {
				byArMean[  int(i / reduction) ] += spectrum.readFloat();
			}

			for (i = 0; i < _size; i++) {
				byArMean[i] = byArMean[i] / reduction;
			}

			return byArMean;
		}

		/**
		 * This method returns the geometric mean from each group.
		 * (Anybody has any idea how to deal with 0 values when calculating geometric means?)
		 */
		private function byGeometricMean(spectrum : ByteArray) : Array {
			var byGeomMean : Array = resultTemplate.concat();

			for (var i : int = 0; i < SPECTRUM_LENGTH; i++) {
				var float : Number = spectrum.readFloat();
				var pos : Number = Math.floor(i / reduction);

				if (byGeomMean[pos] == 0) byGeomMean[pos] = float;
				else if (float > 0) byGeomMean[Math.floor(i / reduction)] *= float;
			}

			for (i = 0; i < _size; i++)
				byGeomMean[i] = Math.pow(byGeomMean[i], 1 / reduction);

			return byGeomMean;
		}

		/**
		 * This method returns the median value from each group.
		 * 
		 * NOTE. The method always assumes that the value 'reduction' is even. If, as recommeded, the size 
		 * is a power of 2 that it is even all the time indeed. 
		 */
		private function byMedian(spectrum : ByteArray) : Array {
			var floats : Array = new Array;
			var byMed : Array = resultTemplate.concat();

			for (var i : int = 0; i < SPECTRUM_LENGTH; i++)
				floats.push(spectrum.readFloat());

			for (i = 0; i < SPECTRUM_LENGTH; i += reduction)
				byMed[Math.floor(i / reduction)] = (floats[i + reduction / 2] + floats[(i + reduction / 2) + 1]) / 2;

			return byMed;
		}

		/**
		 * ++ EXPERIMENTAL ++ 
		 * This method returns the median value from each group, except the situation if the median is 0.
		 * In this case it will look for the first non-zero value in the set and return it. If all values
		 * in the set are 0, only then 0 will be returned.
		 * 
		 * NOTE. The method always assumes that the value 'reduction' is even. If, as recommeded, the size 
		 * is a power of 2 that it is even all the time indeed. 
		 */
		private function byMedianNoZero(spectrum : ByteArray) : Array {
			var floats : Array = new Array;
			var byMed : Array = resultTemplate.concat();

			for (var i : int = 0; i < SPECTRUM_LENGTH; i++)
				floats.push(spectrum.readFloat());

			for (i = 0; i < SPECTRUM_LENGTH; i += reduction) {
				if (floats[i + reduction / 2] != 0) {
					byMed[Math.floor(i / reduction)] = (floats[i + reduction / 2] + floats[(i + reduction / 2) + 1]) / 2;
				} else {
					for (var j : int = 0; j < reduction; j++) {
						byMed[Math.floor(i / reduction)] = floats[i + j];
						if (byMed[Math.floor(i / reduction)] > 0) break;
					}
				}
			}

			return byMed;
		}

		/**
		 * Multiplies each value by factor but forces it to be < 1.
		 */
		private function multiply(result : Array, factor : Number) : Array {
			var multiplied : Array = new Array()
			for (var i : int = 0; i < _size; i++)
				multiplied.push(Math.min((result[i] * factor), 1));

			return multiplied;
		}

		/**
		 * Reverses the left half of the result values so that Equalizer 
		 * has the form of a pyramid '/\' rather than of two triangles '|\|\'
		 */
		private function reverseLeftChannel(result : Array) : Array {
			if ( _useRawMicData ) {
				// Do not reverse if using MicData ( it's mono );
				return result;
			}

			var reversed : Array = new Array();

			for (var i : int = 0; i < _size; i++) {
				var si : uint = (i < (_size / 2)) ? (_size / 2) - i - 1 : i;
				reversed[si] = result[i];
			}

			return reversed;
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -GET/SET----------------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get multiplier() : Number {
			return _multiplier;
		}

		public function set multiplier(multiplier : Number) : void {
			_multiplier = multiplier;
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		public function get size() : int {
			return _size;
		}

		public function set size(size : int) : void {
			_size = size;
			reduction = Math.round(SPECTRUM_LENGTH / _size);
			resultTemplate = new Array();
			for (var i : int = 0; i < _size; i++) resultTemplate.push(0);
		}

		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		// -EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function onMicSampleData(event : SampleDataEvent) : void {
			micSoundBytes = event.data

			if ( !_useRawMicData )
				sound.play();
		}

		/**
		 *  
		 * 
		 * @param
		 * @return
		 */
		private function soundPlaybackSampleHandler(event : SampleDataEvent) : void {
			for (var i : int = 0; i < 8192 && micSoundBytes.bytesAvailable > 0; i++) {
				var sample : Number = micSoundBytes.readFloat();
				event.data.writeFloat(sample);
				event.data.writeFloat(sample);
			}
		}
	}
}















