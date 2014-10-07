package
{
	import com.greensock.TweenLite;
	
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
		
		public var contentWidth:int = 788;
		public const contentHeight:int = 517;
		private const imageHeight:int = 442;
//		private const imageWidth:int = 758;
		private const padding:int = 15;
		private const lovePadding:int = 40;
		private const closePadding:int = 30;
		private const titleSpriteHeight:int = 114;
		private const clickTitleWidth:int = 120;
		
		private var imageName:String;
		private var _parent:Sprite;
		private var _stage:Stage;
		
		private var _whiteBackSprite:Sprite = new Sprite();
//		private var _imageMask:Sprite = new Sprite();
		private var _imageLoader:Loader = new Loader();
		private var _titleSprite:Sprite = new Sprite();
		private var _title:TextField = new TextField();
		private var _viewtitle:TextField = new TextField();
		private var _clickTitle:TextField = new TextField();
		private var _clsBtn:CloseBtn = new CloseBtn();
		private var _loveBtn:LoveBtn = new LoveBtn();
		private var _clickTitleLabel:TextField = new TextField();
		private var _clickTitleLabel2:TextField = new TextField();
		
		private var _btnBarcode:BarcodeButton = new BarcodeButton();
		private var _viewBarcode:BarcodeView = new BarcodeView();
		
		private var _is_first_play:Boolean = true;
		private var _close_timer:Timer = new Timer(60000);
		
		public var isShowing:Boolean = false;
		private var imageCountArray:Dictionary=new Dictionary();
		
		public function BigImageItem()
		{
			/*timer add event listener*/
			_close_timer.addEventListener(TimerEvent.TIMER, onCloseTimer);
			
			/*set big image params*/
			_imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,oncomp);
			_imageLoader.x = padding;
			_imageLoader.y = padding;
//			_imageLoader.mask = _imageMask;
			
//			_imageMask.graphics.beginFill(0xffffff,0);
//			_imageMask.graphics.drawRect(0,0,contentWidth-2*padding,imageHeight);
//			_imageMask.graphics.endFill();
//			_imageMask.x = padding;
//			_imageMask.y = padding;
			
			/*close & love button position*/
			_loveBtn.x = lovePadding;
			_loveBtn.y = lovePadding;
			_clsBtn.y = closePadding;
			
			//title properties
			_title.textColor = 0xffffff;
			var tf:TextFormat = new TextFormat();
			tf.size = 18;
			tf.align = TextFormatAlign.LEFT;
			_title.defaultTextFormat = tf;
			_title.setTextFormat(tf);
			_title.wordWrap = true;
			
//			_viewtitle.defaultTextFormat = tf;
//			_viewtitle.setTextFormat(tf);
//			_viewtitle.text = "fsdaaaaaaaaaaafasdfsdf";
//			_viewtitle.wordWrap = true;
			
			tf = new TextFormat();
			tf.size = 18;
			_clickTitleLabel.defaultTextFormat = tf;
			_clickTitleLabel.setTextFormat(tf);
			_clickTitleLabel2.defaultTextFormat = tf;
			_clickTitleLabel.setTextFormat(tf);
			
			tf = new TextFormat();
			tf.size = 20;
			tf.font = "Georgia";
			_clickTitle.textColor = 0xe43322;
			tf.align = TextFormatAlign.CENTER;
			_clickTitle.defaultTextFormat = tf;
			_clickTitle.setTextFormat(tf);
			
//			
			
			//close button property
//			_clsBtn.width = 20;
//			_clsBtn.height = 20;
//			_clsBtn.addEventListener(MouseEvent.CLICK, onClose);
			
			_titleSprite.y = padding+imageHeight-titleSpriteHeight;
			_titleSprite.x = padding;
			
//			_title.height = _titleSprite.height;
			_title.selectable = false;
			_title.y = _titleSprite.y;
			_title.x = _titleSprite.x;
			_title.width = 400;
			
//			_viewtitle.height = _titleSprite.height;
//			_viewtitle.selectable = false;
//			_viewtitle.y = _titleSprite.y;
//			_viewtitle.x = _titleSprite.x;
//			_viewtitle.width = 400;

//			_clickTitle.height = 
			_clickTitle.selectable = false;
			_clickTitle.text = "99999";
			_clickTitle.y = contentHeight-padding-30;
			
			_btnBarcode.x = 50;
			_btnBarcode.y = contentHeight-padding-_btnBarcode.height + 5;
			
			_viewBarcode.x = 40;
			_viewBarcode.y = _btnBarcode.y-padding-_viewBarcode.height;
			
			
			_clickTitleLabel.y = _clickTitle.y + 5;
			_clickTitleLabel.text = "共收集";
			_clickTitleLabel2.y = _clickTitle.y + 5;
			_clickTitleLabel2.text = "个赞";
			
			
			addChild(_whiteBackSprite);
			addChild(_imageLoader);
			addChild(_titleSprite);
			addChild(_clickTitle);
			addChild(_clickTitleLabel);
			addChild(_clickTitleLabel2);
			addChild(_title);
			addChild(_clsBtn);
			addChild(_loveBtn);
			addChild(_btnBarcode);
			addChild(_viewBarcode);
//			addChild(_viewtitle);
			
			
			
			//self event listener
//			this.addEventListener(MouseEvent.MOUSE_DOWN,onStartDrag);
//			this.addEventListener(MouseEvent.MOUSE_UP,onStopDrag);
		}
		
		/*
		 * rearrange the position of all children view
		*/
		private function resizeView(imageWidth:int):void{
			
			contentWidth = imageWidth+padding*2;
			_whiteBackSprite.graphics.clear();
			_whiteBackSprite.graphics.beginFill(0xffffff,1);
			_whiteBackSprite.graphics.drawRoundRect(0,0,contentWidth,contentHeight,10,10);
			_whiteBackSprite.graphics.endFill();
			
			_clsBtn.x = contentWidth-closePadding-_clsBtn.width;
			
			drawBackColor(_titleSprite,0x000000,contentWidth-2*padding,titleSpriteHeight);

			_title.width = contentWidth-2*padding;


			
			_clickTitle.x = contentWidth-padding-clickTitleWidth;
			
			_clickTitleLabel.x = _clickTitle.x - 25;
			_clickTitleLabel2.x = _clickTitle.x + 70;

			this.x = _stage.stageWidth/2 - contentWidth/2;
			this.y = _stage.stageHeight/2 - contentHeight/2;
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
			
			_clickTitle.text = count.toString();
		}
		public function zoomImage(evt:TableViewEvent):void{
			_imageLoader.content.scaleX = evt.deltaX;
			_imageLoader.content.scaleY = evt.deltaY;
			this.restartTimer();
		}
		public function tapImage(evt:TableViewEvent):void{
			var ox:int = evt.offsetX-x;
			var oy:int = evt.offsetY-y;
			if(ox>=_loveBtn.x-10
				&&ox<=_loveBtn.x+_loveBtn.width+10
				&&oy>=_loveBtn.y-10
				&&oy<=_loveBtn.y+_loveBtn.height+10){
				addLoveCount();
			}else if(ox>=_clsBtn.x-10
				&&ox<=_clsBtn.x+_clsBtn.width+10
				&&oy>=_clsBtn.y-10
				&&oy<=_clsBtn.x+_clsBtn.height+10){
				hideImage();
			}else if(ox>=_btnBarcode.x-10
				&&ox<=_btnBarcode.x+_btnBarcode.width+10
				&&oy>=_btnBarcode.y-10
				&&oy<=_btnBarcode.y+_btnBarcode.height+10){
				showBarcode();
			}
//			else if(ox>=0
//				&&ox<=20
//				&&oy>0
//				&&oy<=20){
//				_imageLoader.content.scaleX += 0.1;
//				_imageLoader.content.scaleY += 0.1;
//			}else if(ox>20
//				&&ox<=40
//				&&oy>0
//				&&oy<=20){
//				_imageLoader.content.scaleX -= 0.1;
//				_imageLoader.content.scaleY -= 0.1;
//			}
		}
		private function showBarcode():void{
			if(_viewBarcode.alpha==0)_viewBarcode.alpha = 1;
			else _viewBarcode.alpha = 0;
			
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
					
				}
				
				imageName = imageId;
//				var request:URLRequest=new URLRequest(Constants.bigImageUrl.replace("{0}",imageId));
				var request:URLRequest = new URLRequest(Constants.getBigImageName(imageId));
				_imageLoader.load(request);
				
				/*clear children at viewBarcode*/
				if(_viewBarcode.numChildren>0)_viewBarcode.removeChildAt(0);
				
				/*load barcode image*/
				var ld:Loader = new Loader();
				ld.contentLoaderInfo.addEventListener(Event.COMPLETE,onBarcodeComplete);
				ld.load(new URLRequest(Constants.getBarcodeImageName(imageId)));
				_viewBarcode.addChild(ld);
			}
		}
		private function onBarcodeComplete(evt:Event):void{
			var ld:Loader = evt.target.loader;
			ld.content.width = 137;
			ld.content.height = 137;
			ld.contentLoaderInfo.removeEventListener(Event.COMPLETE, onBarcodeComplete);
		}
		public function restartTimer():void{
			_close_timer.reset();
			_close_timer.start();
		}
		private function onCloseTimer(evt:TimerEvent):void{
			hideImage();
		}
		private function hideImage():void{
			if(_parent.contains(this)){
				_parent.removeChild(this);
			}
			imageName = null;
			_close_timer.reset();
		}
		private function oncomp(evt:Event):void{
			var loader:Loader = evt.target.loader
			var originalWidth:Number = loader.content.width;
			var originalHeight:Number = loader.content.height;
			var newWidth:int,newHeight:int;
			
			var portion:Number = 442.0/758.0;
			var new_por:Number = originalHeight/originalWidth;
//			if(new_por<portion){
//				newHeight = imageHeight;
//				newWidth = newHeight/new_por;
//			}else{
//				newWidth = imageWidth;
//				newHeight = newWidth*new_por;
//			}
			
			/*set new width of big image*/
			newHeight = imageHeight;
			newWidth = imageHeight/new_por;
			
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
			
			resizeView(newWidth);
			
			_viewBarcode.alpha = 0;
			
			var blackBackHeight:int = 150;
			
			
			_title.text = "图片简介: "+Constants.imageDescription;
			
//			_title.text = "图片简介:";
			
			var count:int = 0;
			if(imageCountArray[imageName]!=null){
				count = imageCountArray[imageName];
			}
			_clickTitle.text = count.toString();

			/*animation for show big item*/
			if(!_parent.contains(this)){
				_parent.addChild(this);
				this.alpha = 0;
				TweenLite.to(this,1,{alpha:1});
			}
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