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
package ui.controls {
	
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	import onyx.controls.Control;
	import onyx.controls.ControlUInt;
	
	import ui.assets.AssetColorPicker;
	import ui.core.UIObject;

	public final class ColorPicker extends UIControl {
		
		/**
		 * 	@private
		 */
		private static var _picker:Picker;

		/**
		 * 	@private
		 */
		private var _preview:Shape		= new Shape();

		/**
		 * 	@private
		 */
		private var _lastX:int			= 0;

		/**
		 * 	@private
		 */
		private var _lastY:int			= 0;

		/**
		 * 	@constructor
		 */		
		public function ColorPicker(options:UIOptions, control:Control):void {
			
			super(options, control, true, control.display);
			
			_draw(options.width, options.height);
			
			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			
			useHandCursor	= true;
			buttonMode		= true;
			mouseChildren	= false;
		}
		
		/**
		 * 	Begin initial fill
		 */
		private function _draw(width:int, height:int):void {
			
			_preview.graphics.beginFill(0x000000);
			_preview.graphics.drawRect(1, 1, width - 1, height - 1);
			_preview.graphics.endFill();

			addChild(_preview);
		}
		
		/**
		 * 	@private
		 */
		private function _onMouseDown(event:MouseEvent):void {
			
			_picker		= new Picker();
			_picker.x	= -_lastX + mouseX;
			_picker.y	= -_lastY + mouseY;
			
			addChild(_picker);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			
			_onMouseMove(event);

		}

		/**
		 * 	@private
		 */
		private function _onMouseMove(event:MouseEvent):void {
			
			var transform:ColorTransform = new ColorTransform();
			
			_lastX = Math.min(Math.max(_picker.mouseX,0),99);
			_lastY = Math.min(Math.max(_picker.mouseY,0),99);

			_picker.cursor.x = _lastX;
			_picker.cursor.y = _lastY;
			
			transform.color = _picker.asset.bitmapData.getPixel(_lastX, _lastY);
			
			control as ControlUInt
			_control.value = transform.color;
			_preview.transform.colorTransform = transform;
			
		}

		/**
		 * 	@private
		 */
		public function _onMouseUp(event:MouseEvent):void {

			removeChild(_picker);
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			
		}
		
		/**
		 * 	Changes color
		 */
		public function set color(c:int):void {
			var transform:ColorTransform = new ColorTransform();
			transform.color = c;
			_preview.transform.colorTransform = transform;
		}
		
		override public function dispose():void {
			removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			
			super.dispose();			
		}
	}
}

import flash.display.Sprite;
import ui.assets.AssetColorPicker;
import flash.display.Shape;	

/**
 *
 */
final class Picker extends Sprite {
	
	public var cursor:Shape				= new Shape();
	public var asset:AssetColorPicker	= new AssetColorPicker();
	
	/**
	 * 	@constructor
	 */
	public function Picker():void {

		addChild(asset);
		addChild(cursor);

		cursor.graphics.lineStyle(0, 0x000000);
		cursor.graphics.drawRect(0,0,2,2);
		
		mouseEnabled = false;
	}
}