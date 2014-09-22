package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class BigImageItem extends Sprite
	{
		private static var _instance:BigImageItem;
		public static function get instance():BigImageItem{
			if(_instance==null)_instance=new BigImageItem();
			return _instance;
		}
		private var imageSize:int;
		private var imageName:String;
		private var _stage:Stage;
		
		private var _imageLoader:Loader = new Loader();
		private var _titleSprite:Sprite = new Sprite();
		private var _title:TextField = new TextField();
		private var _clsBtn:CloseBtn = new CloseBtn();
		
		public function BigImageItem()
		{
			super();
			_imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,oncomp);
			addChild(_imageLoader);
			addChild(_titleSprite);
			addChild(_title);
			addChild(_clsBtn);
			
			//title properties
			_title.textColor = 0xffffff;
			var tf:TextFormat = new TextFormat();
			tf.size = 14;
			tf.align = TextFormatAlign.CENTER;
			_title.defaultTextFormat = tf;
			_title.setTextFormat(tf);
			
			//close button property
			_clsBtn.width = 20;
			_clsBtn.height = 20;
			_clsBtn.addEventListener(MouseEvent.CLICK, onClose);
			
			//self event listener
			this.addEventListener(MouseEvent.MOUSE_DOWN,onStartDrag);
			this.addEventListener(MouseEvent.MOUSE_UP,onStopDrag);
		}
		private function onClose(evt:MouseEvent):void{
			evt.stopPropagation();
			this.hideImage();
		}
		private function onStartDrag(evt:MouseEvent):void{
			this.startDrag();
		}
		private function onStopDrag(evt:MouseEvent):void{
			this.stopDrag();
		}
		public function showImage(fileName:String,stg:Stage):void{
			if(imageName!=null&&imageName == fileName)return;
			else{
				_stage = stg;
				hideImage();
				imageSize = _stage.stageHeight / 2;
				imageName = fileName;
				var request:URLRequest=new URLRequest(fileName);
				_imageLoader.load(request);
			}
		}
		private function hideImage():void{
			if(_stage.contains(this))_stage.removeChild(this);
		}
		private function oncomp(evt:Event):void{
			var loader:Loader = evt.target.loader
			var originalWidth:Number = loader.content.width;
			var originalHeight:Number = loader.content.height;
			var newWidth:int,newHeight:int;
			if(originalWidth>originalHeight){
				newWidth = imageSize;
				newHeight = Number(imageSize)/originalWidth * originalHeight;
			}else {
				newHeight = imageSize;
				newWidth = Number(imageSize)/originalHeight * originalWidth;
			}
			loader.content.height = newHeight;
			loader.content.width = newWidth;
			this.x = _stage.stageWidth/2 - newWidth/2;
			this.y = _stage.stageHeight/2 - newHeight/2;
			
			
			drawBackColor(_titleSprite,0x000000,newWidth);
			_titleSprite.y = newHeight;
			
			
			_title.text = "测试demo";
			_title.width = newWidth;
			_title.height = 30;
//			_title.autoSize = TextFieldAutoSize.CENTER;
			_title.selectable = false;
			_title.y = newHeight;
			
			_stage.addChild(this);
			
		}
		private function drawBackColor(contain:Sprite,color:uint,wid:int):void{
			contain.graphics.clear();
			contain.graphics.beginFill(color,0.7);
			contain.graphics.drawRect(0,0,wid,30);
			contain.graphics.endFill();
		}
		private function getMaxSpriteY(contain:Sprite):int{
			return contain.y + contain.height;
		}
	}
}