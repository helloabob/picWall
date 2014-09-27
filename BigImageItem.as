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
	
	/*global width  788
	* global height 517
	* image width	758
	* image height  442
	* padding 15
	*
	*/
	public class BigImageItem extends Sprite
	{
		private static var _instance:BigImageItem;
		public static function get instance():BigImageItem{
			if(_instance==null)_instance=new BigImageItem();
			return _instance;
		}
		
		public const contentWidth:int = 788;
		public const contentHeight:int = 517;
		private const imageHeight:int = 442;
		private const imageWidth:int = 758;
		private const padding:int = 15;
		private const lovePadding:int = 40;
		private const closePadding:int = 30;
		private const titleSpriteHeight:int = 114;
		private const clickTitleWidth:int = 120;
		
		private var imageName:String;
		private var _parent:Sprite;
		private var _stage:Stage;
		
		private var _whiteBackSprite:Sprite = new Sprite();
		private var _imageMask:Sprite = new Sprite();
		private var _imageLoader:Loader = new Loader();
		private var _titleSprite:Sprite = new Sprite();
		private var _title:TextField = new TextField();
		private var _clickTitle:TextField = new TextField();
		private var _clsBtn:CloseBtn = new CloseBtn();
		private var _loveBtn:LoveBtn = new LoveBtn();
		
		private var _is_first_play:Boolean = true;
		private var _close_timer:Timer = new Timer(60000);
		
		public var isShowing:Boolean = false;
		private var imageCountArray:Dictionary=new Dictionary();
		
		public function BigImageItem()
		{
			_close_timer.addEventListener(TimerEvent.TIMER, onCloseTimer);
			_imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,oncomp);
			
			_whiteBackSprite.graphics.beginFill(0xffffff,1);
			_whiteBackSprite.graphics.drawRect(0,0,contentWidth,contentHeight);
			_whiteBackSprite.graphics.endFill();
			
			_imageLoader.x = padding;
			_imageLoader.y = padding;
			_imageLoader.mask = _imageMask;
			
			_imageMask.graphics.beginFill(0xffffff,0);
			_imageMask.graphics.drawRect(0,0,contentWidth-2*padding,imageHeight);
			_imageMask.graphics.endFill();
			_imageMask.x = padding;
			_imageMask.y = padding;
			
			_loveBtn.x = lovePadding;
			_loveBtn.y = lovePadding;
			_clsBtn.x = contentWidth-closePadding-_clsBtn.width;
			_clsBtn.y = closePadding;
			
			//title properties
			_title.textColor = 0xffffff;
			_clickTitle.textColor = 0x000000;
			var tf:TextFormat = new TextFormat();
			tf.size = 20;
			tf.align = TextFormatAlign.LEFT;
			_title.defaultTextFormat = tf;
			_title.setTextFormat(tf);
			_clickTitle.defaultTextFormat = tf;
			_clickTitle.setTextFormat(tf);
			
			_title.wordWrap = true;
			
			//close button property
//			_clsBtn.width = 20;
//			_clsBtn.height = 20;
			_clsBtn.addEventListener(MouseEvent.CLICK, onClose);
			
			drawBackColor(_titleSprite,0x000000,contentWidth-2*padding,titleSpriteHeight);
			_titleSprite.y = padding+imageHeight-titleSpriteHeight;
			_titleSprite.x = padding;
			
			_title.width = contentWidth-2*padding;
			_title.height = _titleSprite.height;
			_title.selectable = false;
			_title.y = _titleSprite.y;
			_title.x = _titleSprite.x;
			
//			_clickTitle.height = 
			_clickTitle.selectable = false;
			_clickTitle.x = contentWidth-padding-clickTitleWidth;
			_clickTitle.y = contentHeight-padding-30;
			
			addChild(_whiteBackSprite);
			addChild(_imageLoader);
			addChild(_imageMask);
			addChild(_titleSprite);
			addChild(_title);
			addChild(_clickTitle);
			addChild(_clsBtn);
			addChild(_loveBtn);
			
			
			
			
			
			//self event listener
//			this.addEventListener(MouseEvent.MOUSE_DOWN,onStartDrag);
//			this.addEventListener(MouseEvent.MOUSE_UP,onStopDrag);
		}
		private function addLoveCount():void{
			var count:int = 0;
			if(imageCountArray[imageName]==null){
				count = 1;
			} else {
				count = imageCountArray[imageName];
				count ++;
			}
			imageCountArray[imageName] = count;
			
			_clickTitle.text = "赞次数: "+count;
		}
		public function zoomImage(evt:TableViewEvent):void{
			_imageLoader.content.scaleX = evt.deltaX;
			_imageLoader.content.scaleY = evt.deltaY;
			this.restartTimer();
		}
		public function tapImage(evt:TableViewEvent):void{
			var ox:int = evt.offsetX-x;
			var oy:int = evt.offsetY-y;
			if(ox>=_loveBtn.x
				&&ox<=_loveBtn.x+_loveBtn.width
				&&oy>=_loveBtn.y
				&&oy<=_loveBtn.y+_loveBtn.height){
				addLoveCount();
			}else if(ox>=_clsBtn.x
				&&ox<=_clsBtn.x+_clsBtn.width
				&&oy>=_clsBtn.y
				&&oy<=_clsBtn.x+_clsBtn.height){
				hideImage();
			}
		}
		public function moveImage(offsetX:int,offsetY:int):void{
			_imageLoader.x += offsetX;
			_imageLoader.y += offsetY;
			this.restartTimer();
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
				if(_is_first_play){
					this.x = _stage.stageWidth/2 - contentWidth/2;
					this.y = _stage.stageHeight/2 - contentHeight/2;
				}
				
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
			
			var portion:Number = 442.0/758.0;
			var new_por:Number = originalHeight/originalWidth;
			if(new_por<portion){
				newHeight = imageHeight;
				newWidth = newHeight/new_por;
			}else{
				newWidth = imageWidth;
				newHeight = newWidth*new_por;
			}
//			if(originalWidth>originalHeight){
//				newWidth = imageSize;
//				newHeight = Number(imageSize)/originalWidth * originalHeight;
//			}else {
//				newHeight = imageSize;
//				newWidth = Number(imageSize)/originalHeight * originalWidth;
//			}
			
			_imageLoader.x = padding;
			_imageLoader.y = padding;
			_imageLoader.content.height = newHeight;
			_imageLoader.content.width = newWidth;
			if(_is_first_play){
				
				_is_first_play = false;
			}
			
			var blackBackHeight:int = 150;
			
			
			_title.text = "图片简介: "+Constants.imageDescription;
			
			var count:int = 0;
			if(imageCountArray[imageName]!=null){
				count = imageCountArray[imageName];
			}
			_clickTitle.text = "赞次数: "+count;

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