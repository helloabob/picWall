package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class ItemSprite extends Sprite
	{
		public var id:String;
		public function ItemSprite(bitmapData:BitmapData)
		{
			super();
			var bm:Bitmap = new Bitmap(bitmapData);
			this.addChild(bm);
		}
	}
}