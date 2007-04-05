/** 
 * Copyright (c) 2007, www.onyx-vj.com
 * All rights reserved.	
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 * -  Redistributions of source code must retain the above copyright notice, this 
 *    list of conditions and the following disclaimer.
 * 
 * -  Redistributions in binary form must reproduce the above copyright notice, 
 *    this list of conditions and the following disclaimer in the documentation 
 *    and/or other materials provided with the distribution.
 * 
 * -  Neither the name of the www.onyx-vj.com nor the names of its contributors 
 *    may be used to endorse or promote products derived from this software without 
 *    specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 * IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 * 
 */
 package onyx.events {

	/**
	 * 	Midi event
	 */
	public class MidiEvent extends NthEvent {
		
		public static const NOTEON:String  			= "noteon";
		public static const NOTEOFF:String 			= "noteoff";
		public static const CONTROLLER:String		= "controller";
		public static const PROGRAM:String			= "program";
		public static const PRESSURE:String			= "pressure";
		public static const PITCHBEND:String		= "pitchbend";
		public static const CHANNELPRESSURE:String	= "channelpressure";
		public static const REALTIME:String			= "realtime";
		public static const SYSEX:String			= "sysex";
		
		public var time:Number;
		public var deviceIndex:uint;
		public var channel:uint;
		public var pitch:uint;
		public var velocity:uint;
		public var controller:uint;
		public var value:uint;

		/**
		 * 	@constructor
		 */
		public function MidiEvent(t:String, tm:Number, x:XML):void {
			time = tm;
			deviceIndex = x.attribute("devindex");
			channel = x.attribute("channel");
			if ( t == NOTEON || t == NOTEOFF ) {
				velocity = x.attribute("velocity");
				pitch = x.attribute("pitch");
			} else if ( t == CONTROLLER ) {
				controller = x.attribute("controller");
				value = x.attribute("value");
			} else if ( t == PROGRAM ) {
				value = x.attribute("value");
			}
			super(t)
		}
	}
}