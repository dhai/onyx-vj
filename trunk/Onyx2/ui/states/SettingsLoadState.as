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
package ui.states {
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import onyx.constants.*;
	import onyx.core.Console;
	import onyx.filter.Filter;
	import onyx.plugin.Plugin;
	import onyx.states.*;
	import onyx.utils.string.parseBoolean;
	
	import ui.window.WindowRegistration;
	import flash.geom.Rectangle;

	/**
	 * 	Load settings
	 */
	public final class SettingsLoadState extends ApplicationState {

		/**
		 * 	Path
		 */
		public static const PATH:String = 'settings/settings.xml';

		/**
		 * 
		 */
		public function SettingsLoadState():void {
		}

		/**
		 * 
		 */
		override public function initialize():void {
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,			_onLoad);
			loader.addEventListener(IOErrorEvent.IO_ERROR,	_onLoad);
			loader.load(new URLRequest(PATH));
		}
		
		/**
		 * 	@private
		 */
		private function _onLoad(event:Event):void {
			var loader:URLLoader = event.currentTarget as URLLoader;
			loader.removeEventListener(IOErrorEvent.IO_ERROR,	_onLoad);
			loader.removeEventListener(Event.COMPLETE,			_onLoad);
			
			try {
				var xml:XML = new XML(loader.data);
			} catch (e:Error) {
				return Console.error(e);
			}

			parse(xml);
		}

		/**
		 * 	@private
		 * 	Parses the settings
		 */
		private function parse(xml:XML):void {
			
			// set default core settings
			if (xml.core.bitmapData) {
				BITMAP_WIDTH	= xml.core.bitmapData.@width;
				BITMAP_HEIGHT	= xml.core.bitmapData.@height;
				BITMAP_RECT		= new Rectangle(0, 0, BITMAP_WIDTH, BITMAP_HEIGHT);
			}
			
			// set blend modes
			if (xml.core.blendModes) {
				while (BLEND_MODES.length) {
					BLEND_MODES.pop();
				}
				
				for each (var mode:XML in xml.core.blendModes.*) {
					BLEND_MODES.push(String(mode.name()));
				}
			}
			
			// re-order the filters based on settings
			for each (var filter:XML in xml.filters.order.filter) {
				var plugin:Plugin = Filter.getDefinition(filter.@name);
				plugin.index = filter.@index;
			}
			
			// stored keys
			if (xml.keys) {
				
				for each (var key:XML in xml.keys.*) {
					try {
						KeyListenerState[key.name()] = key;
					} catch (e:Error) {
						Console.error(e.message);
					}
				}
			}
			
			// set window locations / enabled
			if (xml.windows) {
				for each (var windowXML:XML in xml.windows.*) {
					var reg:WindowRegistration = WindowRegistration.getWindow(windowXML.@name);
					if (reg) {
						reg.x		= windowXML.@x;
						reg.y		= windowXML.@y;
						reg.enabled = parseBoolean(windowXML.@enabled);
					}
				}
			}

			// kill myself
			StateManager.removeState(this);
		}
		
		override public function terminate():void {
		}
	}
}