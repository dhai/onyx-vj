/** 
 * Copyright (c) 2003-2006, www.onyx-vj.com
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
package filters {
	
	import flash.events.Event;
	import flash.utils.Timer;
	
	import onyx.content.IContent;
	import onyx.controls.*;
	import onyx.filter.Filter;

	public final class Blink extends Filter {
		
		public var count:int		= 0;
		
		public var delay:int		= 2;
		public var min:Number		= 0;
		public var max:Number		= 1;
		
		public function Blink():void {

			super(	
				true,
				new ControlInt('delay',		'delay',		1,	20,	1, { factor: 5 }),
				new ControlNumber('min',	'min alpha',	0,	1,	1),
				new ControlNumber('max',	'max alpha',	0,	1,	1)
			)
		}
		
		/**
		 * 	Initialize
		 */
		override public function initialize():void {
			stage.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		
		/**
		 * 	Per frame function
		 */
		private function _onEnterFrame(event:Event):void {
			count = (count + 1) % delay;
			if (count === 0) {
				content.alpha = ((max - min) * Math.random()) + min;
			}
		}
		
		/**
		 * 	Disposes
		 */
		override public function dispose():void {
			if (stage) {
				stage.removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
				stage = null;
			}
			super.dispose();
		}

	}
}