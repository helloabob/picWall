package
{
	import com.greensock.TweenLite;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.TransformGestureEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	import org.tuio.TouchEvent;
	
	public class PhotoFrameView extends BaseSprite
	{
		
		/*关闭按钮对象*/
//		private var clsBtn:CloseBtn;
		
		/**
		 * 相框索引
		 */
		public var photoIndex:int = -1;
		
		/*相框定宽*/
		public const photoWidth:int = 904;
		
		/*相框定高*/
		public const photoHeight:int = 504;
		
		/*箭头尺寸*/
		private const arrowSize:int = 63;
		
		private const padding:int = 35;
		
		/**
		 * 默认数组索引
		 */
		private const defaultIndex:int = 2;
		
		/**
		 * 当前大图所在数组索引
		 */
		private var currentIndex:int = 2;
		
		/**
		 * 5个图片数组
		 */
		private var photoArray:Array = [];
		
		/**
		 * 宽度数组
		 */
		private var imageWidthArray:Array = [284, 425, 567, 425, 284];
		
		/**
		 * 高度数组
		 */
		private var imageHeightArray:Array = [218, 319, 425, 319, 218];
		
		/**
		 * 偏移量数组
		 */
		private var imageOffsetArray:Array = [{x:arrowSize+padding,y:114}, {x:133,y:61}, {x:166,y:8}, {x:346,y:61}, {x:522,y:114}];
		
		/**
		 * 是否可互动
		 */
		private var canInteractive:Boolean = false;
		
		private var btnLeft:ButtonLeft = new ButtonLeft();
		private var btnRight:ButtonRight = new ButtonRight();
		private var btnFavor:ButtonFavor = new ButtonFavor();
		private var btnBarcode:ButtonBarcode = new ButtonBarcode();
		private var btnClose:ButtonClose = new ButtonClose();
		private var sprFav:SpriteFav = new SpriteFav();
		private var txtFav:TextField = new TextField();
		private var _viewBarcode:BarcodeView = new BarcodeView();
		
		private var scrollView:Sprite = new Sprite();
		
		/*是否动画*/
		private var isAnimation:Boolean = false;
		
		private var barcodeTimer:Timer = null;
		
		private function onSwipe(evt:TransformGestureEvent):void{
			if(evt.offsetX == 1){
				this.onLeft(null);
			}else if(evt.offsetX == -1){
				this.onRight(null);
			}
		}
		
		public function PhotoFrameView()
		{
			super();
			
			var padding:int = 20;
			
			this.graphics.beginFill(0x000000,0.7);
//			this.graphics.drawRect(-padding,-padding,photoWidth+2*padding,photoHeight+2*padding);
			this.graphics.drawRoundRect(-padding,-padding,photoWidth+2*padding,photoHeight+2*padding,padding,padding);
			this.graphics.endFill();
			this
			
			this.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
			
			/*初始化相框加载器*/
//			photo_loader = new Loader();
//			photo_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPhotoComplete);
			
//			this.addChild(photo_loader);
			this.addChild(scrollView);
			for(var i:int=0;i<5;i++){
				var ld:PhotoLoader = new PhotoLoader();
				ld.index = i;
				ld.contentLoaderInfo.addEventListener(Event.COMPLETE, onPhotoComplete);
				ld.x = imageOffsetArray[i].x;
				ld.y = imageOffsetArray[i].y;
				scrollView.addChild(ld);
				photoArray.push(ld);
			}
			
			/*初始化箭头按钮*/
			btnLeft.x = 0;
			btnLeft.y = 252;
			btnLeft.width = arrowSize;
			btnLeft.height = arrowSize;
//			btnLeft.addEventListener(MouseEvent.CLICK, onLeft);
			btnLeft.addEventListener(Constants.debugger?MouseEvent.CLICK:TouchEvent.TAP, onLeft);
			this.addChild(btnLeft);
			
			btnRight.x = 841;
			btnRight.y = 252;
			btnRight.width = arrowSize;
			btnRight.height = arrowSize;
//			btnRight.addEventListener(MouseEvent.CLICK, onRight);
			btnRight.addEventListener(Constants.debugger?MouseEvent.CLICK:TouchEvent.TAP, onRight);
			this.addChild(btnRight);
			
			btnBarcode.x = photoWidth/2 - arrowSize/2;
			btnBarcode.y = photoHeight - arrowSize;
			btnBarcode.width = arrowSize;
			btnBarcode.height = arrowSize;
//			btnBarcode.addEventListener(MouseEvent.CLICK, onBarcode);
//			btnBarcode.addEventListener(TouchEvent.TAP, onBarcode);
			btnBarcode.addEventListener(Constants.debugger?MouseEvent.MOUSE_OVER:TouchEvent.TOUCH_OVER, onBarcodeOver);
			btnBarcode.addEventListener(Constants.debugger?MouseEvent.MOUSE_OUT:TouchEvent.TOUCH_OUT, onBarcodeOut);
			this.addChild(btnBarcode);
			
			barcodeTimer = new Timer(1000,1);
			barcodeTimer.addEventListener(TimerEvent.TIMER, onTimer);
			
			_viewBarcode.x = photoWidth/2 - _viewBarcode.width/2;
			_viewBarcode.y = btnBarcode.y - _viewBarcode.height - 20;
			this.addChild(_viewBarcode);
			
			btnFavor.x = photoWidth/2 - arrowSize*3/2 - 20;
			btnFavor.y = photoHeight - arrowSize;
			btnFavor.width = arrowSize;
			btnFavor.height = arrowSize;
//			btnFavor.addEventListener(MouseEvent.CLICK, onFavor);
			btnFavor.addEventListener(Constants.debugger?MouseEvent.CLICK:TouchEvent.TAP, onFavor);
			this.addChild(btnFavor);
			
			btnClose.x = photoWidth/2 + arrowSize/2 + 20;
			btnClose.y = photoHeight - arrowSize;
			btnClose.width = arrowSize;
			btnClose.height = arrowSize;
//			btnClose.addEventListener(MouseEvent.CLICK, onClose);
			btnClose.addEventListener(Constants.debugger?MouseEvent.CLICK:TouchEvent.TAP, onClose);
			this.addChild(btnClose);
			
			sprFav.x = imageOffsetArray[2].x + 20;
			sprFav.y = imageOffsetArray[2].y + 20;
			sprFav.width = 20;
			sprFav.height = 20;
			this.addChild(sprFav);
			
			var tf:TextFormat = new TextFormat();
			tf.size = 20;
			tf.font = "Georgia";
			tf.align = TextFormatAlign.LEFT;
			txtFav.x = sprFav.x + 30;
			txtFav.y = sprFav.y - 5;
			txtFav.textColor = 0xe43322;
			txtFav.selectable = false;
			txtFav.defaultTextFormat = tf;
			txtFav.setTextFormat(tf);
			txtFav.text = "0";
			this.addChild(txtFav);
			
			/*初始化关闭按钮*/
//			clsBtn = new CloseBtn();
//			clsBtn.x = photoWidth-clsBtn.width;
//			clsBtn.addEventListener(MouseEvent.CLICK, onClose);
//			this.addChild(clsBtn);
		}
		
		private function showBarcode():void{
			if(_viewBarcode.alpha==0)_viewBarcode.alpha = 1;
			else _viewBarcode.alpha = 0;
			
		}
		
		private function onFavor(evt:Event):void{
			var count:int = 0;
			var imageIndex:int = photoArray[currentIndex].imageIndex;
			if(Constants.favCountArray[imageIndex]==null){
				count = 1;
			} else {
				count = Constants.favCountArray[imageIndex];
				count ++;
			}
			Constants.favCountArray[imageIndex] = count;
			
			txtFav.text = count.toString();
		}
		
		private function onBarcode(evt:Event):void{
			this.showBarcode();
		}
		
		private function onBarcodeOver(evt:Event):void{
			if(barcodeTimer.running == false){
				barcodeTimer.start();
			}
		}
		
		private function onBarcodeOut(evt:Event):void{
			if(barcodeTimer.running == true){
				barcodeTimer.stop();
			}
		}
		
		private function onTimer(evt:TimerEvent):void{
			this.onBarcode(null);
		}
		
		private function onLeft(evt:Event):void{
			trace("left");
			if(canInteractive==false)return;
			canInteractive = false;
			currentIndex = fixOutOfRange(currentIndex-1);
			var ld:PhotoLoader = photoArray[fixOutOfRange(currentIndex-2)];
			ld.imageIndex = Constants.getPrevImageIndex(photoArray[fixOutOfRange(currentIndex-1)].imageIndex);
			isAnimation = true;
		}
		
		private function onRight(evt:Event):void{
			trace("right");
			if(canInteractive==false)return;
			canInteractive = false;
			currentIndex = fixOutOfRange(currentIndex+1);
			var ld:PhotoLoader = photoArray[fixOutOfRange(currentIndex+2)];
			ld.imageIndex = Constants.getNextImageIndex(photoArray[fixOutOfRange(currentIndex+1)].imageIndex);
			isAnimation = true;
		}
		
		private function fixOutOfRange(value:int):int{
			if(value<0)value+=5;
			else if(value>4)value-=5;
			return value;
		}
		
		/*相框图加载完成后回调方法*/
		private function onPhotoComplete(evt:Event):void{
			var ld:PhotoLoader = evt.target.loader as PhotoLoader;
			if(ld==null){
				trace("null pointer");
				return;
			}
			var delta:int = currentIndex - defaultIndex;
			var tmp:int = ld.index - delta;
			tmp = fixOutOfRange(tmp);
			var con:* = ld.content;
			con.width = imageWidthArray[tmp];
			con.height = imageHeightArray[tmp];
			this.tidyup();
			canInteractive = true;
		}
		
		private function tidyup():void{
			var sort:Array = [];
			if(currentIndex==0){
				scrollView.addChild(photoArray[3]);
				scrollView.addChild(photoArray[2]);
				scrollView.addChild(photoArray[4]);
				scrollView.addChild(photoArray[1]);
				scrollView.addChild(photoArray[0]);
				sort = [3,4,0,1,2];
			}else if(currentIndex==1){
				scrollView.addChild(photoArray[3]);
				scrollView.addChild(photoArray[4]);
				scrollView.addChild(photoArray[2]);
				scrollView.addChild(photoArray[0]);
				scrollView.addChild(photoArray[1]);
				sort = [4,0,1,2,3];
			}else if(currentIndex==2){
				scrollView.addChild(photoArray[4]);
				scrollView.addChild(photoArray[0]);
				scrollView.addChild(photoArray[1]);
				scrollView.addChild(photoArray[3]);
				scrollView.addChild(photoArray[2]);
				sort = [0,1,2,3,4];
			}else if(currentIndex==3){
				scrollView.addChild(photoArray[1]);
				scrollView.addChild(photoArray[0]);
				scrollView.addChild(photoArray[2]);
				scrollView.addChild(photoArray[4]);
				scrollView.addChild(photoArray[3]);
				sort = [1,2,3,4,0];
			}else if(currentIndex==4){
				scrollView.addChild(photoArray[2]);
				scrollView.addChild(photoArray[1]);
				scrollView.addChild(photoArray[3]);
				scrollView.addChild(photoArray[0]);
				scrollView.addChild(photoArray[4]);
				sort = [2,3,4,0,1];
			}
			var imageIndex:int = photoArray[currentIndex].imageIndex;
			var count:int = Constants.favCountArray[imageIndex]==null?0:Constants.favCountArray[imageIndex];
			txtFav.text = count.toString();
			if(isAnimation){
				for(var i:int=0;i<sort.length;i++){
//					TweenLite.to(tmp,Constants.photoAnimationDuration,{x:offset_x,y:offset_y});
//					photoArray[sort[i]].content.width = imageWidthArray[i];
//					photoArray[sort[i]].content.height = imageHeightArray[i];
//					photoArray[sort[i]].x = imageOffsetArray[i].x;
//					photoArray[sort[i]].y = imageOffsetArray[i].y;
					TweenLite.to(photoArray[sort[i]].content,Constants.photoAnimationDuration,{width:imageWidthArray[i],height:imageHeightArray[i]});
					TweenLite.to(photoArray[sort[i]],Constants.photoAnimationDuration,{x:imageOffsetArray[i].x,y:imageOffsetArray[i].y});
				}
				isAnimation = false;
			}
		}
		
		/*关闭方法，当用户点击相框的关闭按钮触发*/
		private function onClose(evt:Event):void {
			closeHandler(this);
		}
		
		/**
		 * 加载并显示相框图*/
		public function show(imageId:String):void {
			/*加载图片1*/
			canInteractive = false;
			currentIndex = 2;
			var index:int = int(imageId) - 1;
			index = Constants.getPrevImageIndex(index);
			index = Constants.getPrevImageIndex(index);
			for(var i:int=0;i<photoArray.length;i++){
				var ld:PhotoLoader = photoArray[i] as PhotoLoader;
				ld.imageIndex = index;
				ld.x = imageOffsetArray[i].x;
				ld.y = imageOffsetArray[i].y;
				trace("load:"+index.toString());
				index = Constants.getNextImageIndex(index);
			}
			/*clear children at viewBarcode*/
			if(_viewBarcode.numChildren>0)_viewBarcode.removeChildAt(0);
			
			/*load barcode image*/
			var bar:Loader = new Loader();
			bar.contentLoaderInfo.addEventListener(Event.COMPLETE,onBarcodeComplete);
			bar.load(new URLRequest(Constants.getBarcodeImageName(imageId)));
			_viewBarcode.addChild(bar);
			_viewBarcode.alpha = 0;
		}
		private function onBarcodeComplete(evt:Event):void{
			var ld:Loader = evt.target.loader;
			ld.content.width = 137;
			ld.content.height = 137;
			ld.contentLoaderInfo.removeEventListener(Event.COMPLETE, onBarcodeComplete);
		}
		
		/**
		 * 退出并隐藏相框*/
		public function hide():void {
//			photo_loader.unloadAndStop();
			for(var i:int=0;i<photoArray.length;i++){
				var ld:PhotoLoader = photoArray[i] as PhotoLoader;
				ld.unloadAndStop();
			}
		}
		
		/**
		 * 关闭相框代理，回调时需传this对象*/
		public var closeHandler:Function;
	}
}