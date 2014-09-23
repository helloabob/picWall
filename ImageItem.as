package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	
	public class ImageItem extends Sprite
	{
		private var _id:String;
		private var _contentHeight:int;
		private var _contentWidth:int;
		private var _fileName:String;
		private var _content:Sprite;
//		private var _width:int;
//		private var _height:int;
//		private var _view:Sprite;
//		private var _y:int;
//		private var _x:int;
		
		public function ImageItem()
		{
//			_view = new Sprite();
		}

		public function get contentWidth():int
		{
			return _contentWidth;
		}

		public function set contentWidth(value:int):void
		{
			_contentWidth = value;
		}

		public function get fileName():String
		{
			return _fileName;
		}

		public function set fileName(value:String):void
		{
			_fileName = value;
		}

		public function get contentHeight():int
		{
			return _contentHeight;
		}

		public function set contentHeight(value:int):void
		{
			_contentHeight = value;
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
		}
		
		public function get content():Sprite{
			return _content;
		}

//		public function get x():int
//		{
//			return _x;
//		}

//		public function set x(value:int):void
//		{
//			_x = value;
//			_view.x = value;
//		}

//		public function get y():int
//		{
//			return _y;
//		}
//
//		public function set y(value:int):void
//		{
//			_y = value;
//			_view.y = value;
//		}

//		public function get view():Sprite
//		{
//			return _view;
//		}
//
//		public function set view(value:Sprite):void
//		{
//			_view = value;
//		}

//		public function get height():int
//		{
//			return _height;
//		}
//
//		public function set height(value:int):void
//		{
//			_height = value;
//		}
//
//		public function get width():int
//		{
//			return _width;
//		}
//
//		public function set width(value:int):void
//		{
//			_width = value;
//		}

		public function set imageName(name:String):void{
//			_fileName = "images/"+name+".jpg";
			_fileName = Constants.smallImageUrl.replace("{0}",name);
//			trace(url);
			var request:URLRequest=new URLRequest(_fileName);
			var ld:Loader = new Loader();
			ld.contentLoaderInfo.addEventListener(Event.COMPLETE,oncomp);
			ld.load(request);
		}
		
		private function oncomp(evt:Event):void{
			var loader:Loader = evt.target.loader;
			var portion:Number = loader.content.width/loader.content.height;
			var newHeight:int = contentHeight-Constants.verticalPadding*2;
			var newWidth:int = contentWidth-Constants.horizontalPadding*2;
//			var width2:int = newWidth+Constants.horizontalPadding*2;
			
			var back:Sprite = new Sprite();
			back.graphics.beginFill(0x000000,0.1);
			back.graphics.drawRect(0,0,contentWidth,contentHeight);
			back.graphics.endFill();
			addChild(back);
//			_view.addChild(back);
			
			_content = new Sprite();
			_content.x = Constants.horizontalPadding;
			_content.y = Constants.verticalPadding;
			
			loader.content.height = newHeight;
			loader.content.width = newWidth;
//			loader.content.x = Constants.horizontalPadding;
//			loader.content.y = Constants.verticalPadding;
			_content.addChild(loader);
			addChild(_content);
//			_view.addChild(loader);
			
			var event:TableViewEvent=new TableViewEvent(TableViewEvent.ITEMDIDAPPEAR);
			event.itemWidth = width;
			dispatchEvent(event);
		}
	}
}