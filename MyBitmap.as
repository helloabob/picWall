package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class MyBitmap extends Bitmap
	{
		public var id:String;
		public function MyBitmap(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
		}
	}
}