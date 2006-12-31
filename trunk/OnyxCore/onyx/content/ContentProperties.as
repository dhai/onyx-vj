		/**
		 * 	@private
		 * 	Stores the filters for this content
		 */
		private var _filters:Array							= [];

		/**
		 * 	@private
		 */
		private var _filter:ColorFilter						= new ColorFilter();
		
		/**
		 * 	@private
		 * 	Stores the matrix for the content
		 */
		private var _matrix:Matrix							= new Matrix();
		
		/**
		 * 	@private
		 */
		private var _rotation:Number						= 0;

		/**
		 * 	@private
		 */
		private var _colorTransform:ColorTransform			= new ColorTransform(); 
		
		/**
		 * 	@private
		 */
		private var _scaleX:Number							= 1;

		/**
		 * 	@private
		 */
		private var _scaleY:Number							= 1;

		/**
		 * 	@private
		 */
		private var _x:int									= 0;

		/**
		 * 	@private
		 */
		private var _y:int									= 0;

		/**
		 * 	@private
		 */
		private var _tint:Number							= 0;

		/**
		 * 	@private
		 */
		private var _color:Number							= 0;
		
		/**
		 * 	Tint
		 */
		public function set tint(value:Number):void {		
			
			_tint = value;
			
			var r:Number = ((_color & 0xFF0000) >> 16) * value;
			var g:Number = ((_color & 0x00FF00) >> 8) * value;
			var b:Number = (_color & 0x0000FF) * value;

			var amount:Number = 1 - value;
			
			_colorTransform = new ColorTransform(amount,amount,amount,1,r,g,b);
		}
		
		/**
		 * 	Sets color
		 */
		public function set color(value:uint):void {
			
			_color = value;
			
			var r:Number = ((_color & 0xFF0000) >> 16) * _tint;
			var g:Number = ((_color & 0x00FF00) >> 8) * _tint;
			var b:Number = (_color & 0x0000FF) * _tint;

			var amount:Number = 1 - _tint;

			_colorTransform = new ColorTransform(amount,amount,amount,1,r,g,b);
		}

		
		/**
		 * 	Gets color
		 */
		public function get color():uint {
			return _color;
		}

		/**
		 * 	Gets tint
		 */
		public function get tint():Number {
			return _tint;
		}
		
		/**
		 * 	Sets x
		 */
		override public function set x(value:Number):void {
			_x = value;
		}

		/**
		 * 	Sets y
		 */
		override public function set y(value:Number):void {
			_y = value;
		}

		override public function set scaleX(value:Number):void {
			_scaleX = value;
		}

		override public function set scaleY(value:Number):void {
			_scaleY = value;
		}
		
		override public function get scaleX():Number {
			return _scaleX;
		}

		override public function get scaleY():Number {
			return _scaleY;
		}

		override public function get x():Number {
			return _x;
		}

		override public function get y():Number {
			return _y;
		}
		
		/**
		 * 	Gets saturation
		 */
		public function get saturation():Number {
			return _filter._saturation;
		}
		
		/**
		 * 	Sets saturation
		 */
		public function set saturation(value:Number):void {
			_filter.saturation = value;
		}

		/**
		 * 	Gets contrast
		 */
		public function get contrast():Number {
			return _filter._contrast;
		}

		/**
		 * 	Sets contrast
		 */
		public function set contrast(value:Number):void {
			_filter.contrast = value;
		}

		/**
		 * 	Gets brightness
		 */
		public function get brightness():Number {
			return _filter._brightness;
		}
		
		/**
		 * 	Sets brightness
		 */
		public function set brightness(value:Number):void {
			_filter.brightness = value;
		}

		/**
		 * 	Gets threshold
		 */
		public function get threshold():int {
			return _filter._threshold;
		}
		
		/**
		 * 	Sets threshold
		 */
		public function set threshold(value:int):void {
			_filter.threshold = value;
		}

		/**
		 *
		 */
		override public function set rotation(value:Number):void {
			_rotation = value;
		}
		

		/**
		 *
		 */
		override public function get rotation():Number {
			return _rotation;
		}