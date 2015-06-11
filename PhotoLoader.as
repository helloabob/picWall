package
{
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	public class PhotoLoader extends Loader
	{
		
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
			if(_imageIndex!=-1&&_imageIndex!=value){
				this.unloadAndStop();
			}
			_imageIndex = value;
			this.imageUrl = Constants.getBigImagePathWithIndex(imageIndex);
		}

		public function set imageUrl(value:String):void {
			this.load(new URLRequest(value));
		}
	}
}