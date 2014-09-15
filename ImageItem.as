package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	
	public class ImageItem extends EventDispatcher
	{
		
		private var _width:int;
		private var _height:int;
		private var _view:Sprite;
		private var _y:int;
		private var _x:int;
		
		public function ImageItem()
		{
			_view = new Sprite();
		}

		public function get x():int
		{
			return _x;
		}

		public function set x(value:int):void
		{
			_x = value;
			_view.x = value;
		}

		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			_y = value;
			_view.y = value;
		}

		public function get view():Sprite
		{
			return _view;
		}

		public function set view(value:Sprite):void
		{
			_view = value;
		}

		public function get height():int
		{
			return _height;
		}

		public function set height(value:int):void
		{
			_height = value;
		}

		public function get width():int
		{
			return _width;
		}

		public function set width(value:int):void
		{
			_width = value;
		}

		public function set imageName(name:String):void{
			var url:String = "images/"+name+".jpg";
			trace(url);
			var request:URLRequest=new URLRequest(url);
			var ld:Loader = new Loader();
			ld.contentLoaderInfo.addEventListener(Event.COMPLETE,oncomp);
			ld.load(request);
			
			
		}
		private function oncomp(evt:Event):void{
//			var loader:Loader = Loader(evt.target.loader);
//			var bm:Bitmap = Bitmap(loader.content);
			
//			addChild(bm);
			var loader:Loader = evt.target.loader;
			var portion:Number = loader.content.width/loader.content.height;
			var newHeight:int = height-10;
//			var newWidth:int = newHeight*portion;
			var newWidth:int = newHeight;
			var width:int = newWidth+10;
			
			var back:Sprite = new Sprite();
			back.graphics.beginFill(0x000000,0.1);
			back.graphics.drawRect(0,0,width,height);
			back.graphics.endFill();
			_view.addChild(back);
			
			
			loader.content.height = newHeight;
			loader.content.width = newWidth;
			loader.content.x = 5;
			loader.content.y = 5;
			_view.addChild(loader);
			
			var event:TableViewEvent=new TableViewEvent(TableViewEvent.ITEMDIDAPPEAR);
			event.itemWidth = width;
			dispatchEvent(event);
		}
	}
}