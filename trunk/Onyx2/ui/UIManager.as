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
package ui {
	
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.events.KeyboardEvent;
	
	import onyx.application.Onyx;
	import onyx.events.DisplayEvent;
	import onyx.events.LayerEvent;
	import onyx.external.files.*;
	
	import ui.assets.*;
	import ui.core.ui_internal;
	import ui.layer.UILayer;
	import ui.window.*;
	import onyx.layer.Layer;

	public class UIManager {

		private static var _root:Stage;
		
		// initialize
		public static function initialize(root:Stage):void {
			
			// store the root
			_root = root;
			
			// low quality
			root.stage.quality = StageQuality.LOW;
			
			// add our windows
			_loadWindows(Console, PerfMonitor, Browser, Filters, TransitionWindow);
			
			// listen for windows created
			Onyx.addEventListener(LayerEvent.LAYER_CREATED, _onLayerCreate);
			Onyx.addEventListener(DisplayEvent.DISPLAY_CREATED, _onDisplayCreate);

			// initializes onyx
			Onyx.initialize(root);
			
			// listen for keys
			root.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyPress);
			
//			var layer:Layer = new Layer();
		}
		
		// add windows
		private static function _loadWindows(... windowsToLoad:Array):void {

			for each (var window:Class in windowsToLoad) {
				_root.addChild(new window());
			}

		}
		
		/**
		 * 
		 */
		private static function _onDisplayCreate(event:DisplayEvent):void {
			var display:SettingsWindow = new SettingsWindow(event.display);
			_root.addChild(display);
		}
		
		// when a layer is created
		private static function _onLayerCreate(event:LayerEvent):void {
			
			var uilayer:UILayer = new UILayer(event.layer);
			uilayer.moveLayer();

			_root.addChild(uilayer);
			
		}
		
		private static function _onKeyPress(event:KeyboardEvent):void {
			
			var layer:UILayer;
			
			switch (event.keyCode) {
				case 37:
					layer = UILayer.getLayerAt(UILayer.selectedLayer.index - 1);
					if (layer) {
						UILayer.selectLayer(layer);
					}
					
					break;
				case 39:
					layer = UILayer.getLayerAt(UILayer.selectedLayer.index + 1);
					if (layer) {
						UILayer.selectLayer(layer);
					}

					break;
				case 38:
				case 40:
					trace('key');
					break;
			}
		}
		
	}
}