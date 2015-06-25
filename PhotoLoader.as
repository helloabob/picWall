package
{
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	public class PhotoLoader extends Loader
	{
		// 首张图片的左右拖放 CAOZQ 20150612 STR
		public var isTouchDown:Boolean = false;// 是否按下
		public var firstX:Number = 0;// 原始坐标X
		public var firstY:Number = 0;// 原始坐标Y
		public var lenX:Number = 0;// 初次按下的差值X方向
		public var lenY:Number = 0;// 初次按下的差值Y方向
		// 首张图片的左右拖放 CAOZQ 20150612 END
		private var _imageIndex:int = -1;
		
		private var _index:int = -1;
		
		public function PhotoLoader()
		{
			super();
		}
		
		/**
		 * 数组索引
		 */
		public function get index():int
		{
			return _index;
		}

		/**
		 * @private
		 */
		public function set index(value:int):void
		{
			_index = value;
		}

		/**
		 * 图片索引
		 */
		public function get imageIndex():int
		{
			return _imageIndex;
		}

		/**
		 * @private
		 */
		public function set imageIndex(value:int):void
		{
			isTouchDown = false;
			_imageIndex = value;
			this.imageUrl = Constants.getBigImagePathWithIndex(imageIndex);
		}

		public function set imageUrl(value:String):void {
			this.load(new URLRequest(value));
		}
		// 首张图片的左右拖放 CAOZQ 20150612 STR
		// 第一次按下初始化
		public function initTouchDown(eventX:Number, eventY:Number):void {
			if (firstX == 0 && firstY == 0) {
				firstX = this.x;
				firstY = this.y;
			}
			lenX = firstX - eventX;
			lenY = firstY - eventY;
		}
		// 首张图片的左右拖放 CAOZQ 20150612 END
	}
}