package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	public class BigImageItem extends Sprite
	{
		private static var _instance:BigImageItem;
		public static function get instance():BigImageItem{
			if(_instance==null)_instance=new BigImageItem();
			return _instance;
		}
		private var imageWidth:int;
		private var imageHeight:int;
		private var imageName:String;
		private var _stage:Stage;
		private var _parent:Sprite;
		
		private var _imageLoader:Loader = new Loader();
		private var _titleSprite:Sprite = new Sprite();
		private var _title:TextField = new TextField();
		private var _clickTitle:TextField = new TextField();
		private var _clsBtn:CloseBtn = new CloseBtn();
		
		private var _is_first_play:Boolean = true;
		private var _close_timer:Timer = new Timer(60000);
		
		public var isShowing:Boolean = false;
		private var imageCountArray:Dictionary=new Dictionary();
		
		public function BigImageItem()
		{
			_close_timer.addEventListener(TimerEvent.TIMER, onCloseTimer);
			_imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,oncomp);
			addChild(_imageLoader);
			addChild(_titleSprite);
			addChild(_title);
			addChild(_clickTitle);
			addChild(_clsBtn);
			
			//title properties
			_title.textColor = 0xffffff;
			_clickTitle.textColor = 0xffffff;
			var tf:TextFormat = new TextFormat();
			tf.size = 14;
			tf.align = TextFormatAlign.LEFT;
			_title.defaultTextFormat = tf;
			_title.setTextFormat(tf);
			_clickTitle.defaultTextFormat = tf;
			_clickTitle.setTextFormat(tf);
			
			_title.wordWrap = true;
			
			//close button property
			_clsBtn.width = 20;
			_clsBtn.height = 20;
			_clsBtn.addEventListener(MouseEvent.CLICK, onClose);
			
			//self event listener
//			this.addEventListener(MouseEvent.MOUSE_DOWN,onStartDrag);
//			this.addEventListener(MouseEvent.MOUSE_UP,onStopDrag);
		}
		private function onClose(evt:MouseEvent):void{
			evt.stopPropagation();
			this.hideImage();
		}
//		private function onStartDrag(evt:MouseEvent):void{
//			this.startDrag();
//		}
//		private function onStopDrag(evt:MouseEvent):void{
//			this.stopDrag();
//		}
		public function showImage(imageId:String,stg:Stage,par:Sprite):void{
			_close_timer.reset();
			if(imageName!=null&&imageName == imageId)return;
			else{
				_stage = stg;
				_parent = par;
				imageWidth = _stage.stageWidth / 6;
//				imageHeight = _stage.stageHeight / 6;
				imageHeight = 240;
				hideImage();
				imageName = imageId;
				var request:URLRequest=new URLRequest(Constants.bigImageUrl.replace("{0}",imageId));
				_imageLoader.load(request);
			}
		}
		public function restartTimer():void{
			_close_timer.reset();
			_close_timer.start();
		}
		private function onCloseTimer(evt:TimerEvent):void{
			hideImage();
		}
		private function hideImage():void{
			if(_parent.contains(this))_parent.removeChild(this);
			_close_timer.reset();
		}
		private function oncomp(evt:Event):void{
			var loader:Loader = evt.target.loader
			var originalWidth:Number = loader.content.width;
			var originalHeight:Number = loader.content.height;
			var newWidth:int,newHeight:int;
//			if(originalWidth>originalHeight){
//				newWidth = imageSize;
//				newHeight = Number(imageSize)/originalWidth * originalHeight;
//			}else {
//				newHeight = imageSize;
//				newWidth = Number(imageSize)/originalHeight * originalWidth;
//			}
			
			
			loader.content.height = imageHeight;
			loader.content.width = imageWidth;
			if(_is_first_play){
				this.x = _stage.stageWidth/2 - imageWidth/2;
				this.y = _stage.stageHeight/2 - imageHeight/2;
				_is_first_play = false;
			}
			
			var blackBackHeight:int = 150;
			drawBackColor(_titleSprite,0x000000,imageWidth,blackBackHeight);
			_titleSprite.y = imageHeight;
			
			_title.text = "图片简介: "+Constants.imageDescription;
			_title.width = imageWidth;
			_title.height = blackBackHeight/7*6;
			_title.selectable = false;
			_title.y = imageHeight;
			
			var count:int = 0;
			if(imageCountArray[imageName]==null){
				count = 1;
			} else {
				count = imageCountArray[imageName];
				count ++;
			}
			imageCountArray[imageName] = count;
			
			_clickTitle.text = "展示次数: "+count++;
			_clickTitle.width = imageWidth;
			_clickTitle.height = blackBackHeight/7;
			_clickTitle.selectable = false;
			_clickTitle.y = imageHeight+_title.height;

			_parent.addChild(this);
			_close_timer.start();
			
		}
		private function drawBackColor(contain:Sprite,color:uint,wid:int,hei:int):void{
			contain.graphics.clear();
			contain.graphics.beginFill(color,0.7);
			contain.graphics.drawRect(0,0,wid,hei);
			contain.graphics.endFill();
		}
		private function getMaxSpriteY(contain:Sprite):int{
			return contain.y + contain.height;
		}
	}
}