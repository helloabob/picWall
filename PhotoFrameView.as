package
{
	import com.greensock.TweenLite;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import org.tuio.TouchEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;

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
		private const arrowSize:int = 141;
		//由之前的63改为了141 qinwg 2015-06-15
		
		private const padding:int = 50;
		//由之前的35改为了50 qinwg 2015-06-15
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
		// 移除了左右按钮后最左边的图片不表示修正 CAOZQ 20150617 STR
		// private var imageOffsetArray:Array = [{x:arrowSize+padding,y:114}, {x:133,y:61}, {x:166,y:8}, {x:346,y:61}, {x:522,y:114}];
		private var imageOffsetArray:Array = [{x:97,y:114}, {x:133,y:61}, {x:166,y:8}, {x:346,y:61}, {x:522,y:114}];
		// 移除了左右按钮后最左边的图片不表示修正 CAOZQ 20150617 END
		
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

		// (二维码按钮/关闭按钮/点赞按钮)鼠标悬停2秒触发点击事件 CAOZQ 20150617 STR
		private var btnBarcodeTimer:Timer = new Timer(2000, 1);
		private var btnCloseTimer:Timer = new Timer(2000, 1);
		private var btnFavorTimer:Timer = new Timer(2000, 1);
		// (二维码按钮/关闭按钮/点赞按钮)鼠标悬停2秒触发点击事件 CAOZQ 20150617 END
		
		// 相框自动关闭功能添加 CAOZQ 20150617 STR
		private var autoCloseTimer:Timer = new Timer(120000, 1);
		// 相框自动关闭功能添加 CAOZQ 20150617 END

		private function onSwipe(evt:TransformGestureEvent):void{
			if(evt.offsetX == 1){
				this.onLeft(null);
			}else if(evt.offsetX == -1){
				this.onRight(null);
			}
		}

		// (二维码按钮/关闭按钮/点赞按钮)鼠标悬停2秒触发点击事件 CAOZQ 20150617 STR
		function onBtnFavorTouchOver(e:Event):void 
		{
			// 开启自关闭倒计时 CAOZQ 20150617 STR
			autoCloseTimerRestart();
			// 开启自关闭倒计时 CAOZQ 20150617 END
			btnFavorTimer.reset();
			btnFavorTimer.start();
		}
		function onBtnFavorTouchOut(e:Event):void 
		{
			// 开启自关闭倒计时 CAOZQ 20150617 STR
			autoCloseTimerRestart();
			// 开启自关闭倒计时 CAOZQ 20150617 END

			btnFavorTimer.stop();
		}
		function onBtnBarcodeTouchOver(e:Event):void 
		{
			// 开启自关闭倒计时 CAOZQ 20150617 STR
			autoCloseTimerRestart();
			// 开启自关闭倒计时 CAOZQ 20150617 END

			btnBarcodeTimer.reset();
			btnBarcodeTimer.start();
		}
		function onBtnBarcodeTouchOut(e:Event):void 
		{
			// 开启自关闭倒计时 CAOZQ 20150617 STR
			autoCloseTimerRestart();
			// 开启自关闭倒计时 CAOZQ 20150617 END

			btnBarcodeTimer.stop();
		}
		function onBtnCloseTouchOver(e:Event):void 
		{
			// 开启自关闭倒计时 CAOZQ 20150617 STR
			autoCloseTimerRestart();
			// 开启自关闭倒计时 CAOZQ 20150617 END

			btnCloseTimer.reset();
			btnCloseTimer.start();
		}
		function onBtnCloseTouchOut(e:Event):void 
		{
			// 开启自关闭倒计时 CAOZQ 20150617 STR
			autoCloseTimerRestart();
			// 开启自关闭倒计时 CAOZQ 20150617 END

			btnCloseTimer.stop();
		}
		function onBtnBarcodeTimer(e:Event):void 
		{
			this.onBarcode(null);
		}
		function onBtnCloseTimer(e:Event):void 
		{
			this.onClose(null);
		}
		function onBtnFavorTimer(e:Event):void 
		{
			this.onFavor(null);
		}
		// (二维码按钮/关闭按钮/点赞按钮)鼠标悬停2秒触发点击事件 CAOZQ 20150617 END

		// 相框自动关闭功能添加 CAOZQ 20150617 STR
		function onAutoCloseTimer(e:Event):void 
		{
			this.onClose(null);
		}
		// 相框自动关闭功能添加 CAOZQ 20150617 END

		// 图片改变二维码不刷新BUG修正 CAOZQ 20150617 STR
		private var bar:Loader = new Loader();
		// 图片改变二维码不刷新BUG修正 CAOZQ 20150617 END

		public function PhotoFrameView()
		{
			super();

			// 图片改变二维码不刷新BUG修正 CAOZQ 20150617 STR
			bar.contentLoaderInfo.addEventListener(Event.COMPLETE,onBarcodeComplete);
			// 图片改变二维码不刷新BUG修正 CAOZQ 20150617 END

			// 相框自动关闭功能添加 CAOZQ 20150617 STR
			autoCloseTimer.addEventListener(TimerEvent.TIMER, onAutoCloseTimer);
			// 相框自动关闭功能添加 CAOZQ 20150617 END

			// (二维码按钮/关闭按钮/点赞按钮)鼠标悬停2秒触发点击事件 CAOZQ 20150617 STR
			btnBarcodeTimer.addEventListener(TimerEvent.TIMER, onBtnBarcodeTimer);
			btnCloseTimer.addEventListener(TimerEvent.TIMER, onBtnCloseTimer);
			btnFavorTimer.addEventListener(TimerEvent.TIMER, onBtnFavorTimer);

			btnFavor.addEventListener(TouchEvent.TOUCH_OVER, onBtnFavorTouchOver);
			btnFavor.addEventListener(TouchEvent.TOUCH_OUT, onBtnFavorTouchOut);

			btnBarcode.addEventListener(TouchEvent.TOUCH_OVER, onBtnBarcodeTouchOver);
			btnBarcode.addEventListener(TouchEvent.TOUCH_OUT, onBtnBarcodeTouchOut);

			btnClose.addEventListener(TouchEvent.TOUCH_OVER, onBtnCloseTouchOver);
			btnClose.addEventListener(TouchEvent.TOUCH_OUT, onBtnCloseTouchOut);
			// (二维码按钮/关闭按钮/点赞按钮)鼠标悬停2秒触发点击事件 CAOZQ 20150617 END

			// 设定添加的先后顺序 CAOZQ 20150615 STR
			this.addChild(txtFav);
			this.addChild(_viewBarcode);
			this.addChild(btnFavor);
			this.addChild(btnBarcode);
			this.addChild(btnClose);
			// 设定添加的先后顺序 CAOZQ 20150615 END
			
			this.graphics.beginFill(0x000000,0);
			this.graphics.drawRect(0,0,photoWidth,photoHeight);
			this.graphics.endFill();
			
			this.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
			
			/*初始化相框加载器*/
//			photo_loader = new Loader();
//			photo_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPhotoComplete);
			
//			this.addChild(photo_loader);
			this.addChild(scrollView);

			// 相框添加阴影 CAOZQ 20150618 STR
			function getBitmapFilter():BitmapFilter {
				var color:Number = 0x000000;
				var alpha:Number = 0.9;
				var blurX:Number = 35;
				var blurY:Number = 35;
				var strength:Number = 2;
				var inner:Boolean = false;
				var knockout:Boolean = false;
				var quality:Number = BitmapFilterQuality.HIGH;

				return new GlowFilter(color,
					alpha,
					blurX,
					blurY,
					strength,
					quality,
					inner,
					knockout);
        	}
        	var photoGlowFilter = getBitmapFilter();
        	var myFilters:Array = new Array();
			myFilters.push(photoGlowFilter);
			// 相框添加阴影 CAOZQ 20150618 END

			for (var i:int = 0; i < 5; i++) 
			{
				var ld:PhotoLoader = new PhotoLoader();
				ld.index = i;
				ld.contentLoaderInfo.addEventListener(Event.COMPLETE, onPhotoComplete);
				ld.x = imageOffsetArray[i].x;
				ld.y = imageOffsetArray[i].y;
				// 相框添加阴影 CAOZQ 20150618 STR
				ld.filters = myFilters;
				// 相框添加阴影 CAOZQ 20150618 END
				scrollView.addChild(ld);
				photoArray.push(ld);
			}
			
			/*初始化箭头按钮*/
			btnLeft.x = 0;
			btnLeft.y = 252;
			btnLeft.width = arrowSize;
			btnLeft.height = arrowSize;
//			btnLeft.addEventListener(MouseEvent.CLICK, onLeft);
			btnLeft.addEventListener(TouchEvent.TAP, onLeft);
			// 隐藏向左按钮 CAOZQ 20150615 STR
			// this.addChild(btnLeft);
			// 隐藏向左按钮 CAOZQ 20150615 END
			
			btnRight.x = 841;
			btnRight.y = 252;
			btnRight.width = arrowSize;
			btnRight.height = arrowSize;
//			btnRight.addEventListener(MouseEvent.CLICK, onRight);
			btnRight.addEventListener(TouchEvent.TAP, onRight);
			// 隐藏向右按钮 CAOZQ 20150615 STR
			// this.addChild(btnRight);
			// 隐藏向右按钮 CAOZQ 20150615 END
			
			btnBarcode.x = photoWidth/2 - arrowSize/2;
			btnBarcode.y = photoHeight - arrowSize + 35;//在之前基础上增加30 QINWG 2015-06-15
			btnBarcode.width = arrowSize;
			btnBarcode.height = arrowSize;
//			btnBarcode.addEventListener(MouseEvent.CLICK, onBarcode);
			btnBarcode.addEventListener(TouchEvent.TAP, onBarcode);
			// this.addChild(btnBarcode);// 先后顺序 CAOZQ 20150615
			
			_viewBarcode.x = photoWidth/2 - _viewBarcode.width/2;
			// 二维码图片整体下移 CAOZQ 20150615 STR
			// _viewBarcode.y = btnBarcode.y - _viewBarcode.height - 20;
			_viewBarcode.y = btnBarcode.y + 120;
			// 二维码图片整体下移 CAOZQ 20150615 END
			// this.addChild(_viewBarcode);// 先后顺序 CAOZQ 20150615
			
			btnFavor.x = photoWidth/2 - arrowSize*3/2 - 40;//由之前20改为40，点赞按钮较之前左移20 QINWG 2015-06-15
			btnFavor.y = photoHeight - arrowSize + 35;//在之前基础上增加30 QINWG 2015-06-15
			btnFavor.width = arrowSize;
			btnFavor.height = arrowSize;
//			btnFavor.addEventListener(MouseEvent.CLICK, onFavor);
			btnFavor.addEventListener(TouchEvent.TAP, onFavor);
			// this.addChild(btnFavor);// 先后顺序 CAOZQ 20150615
			
			btnClose.x = photoWidth/2 + arrowSize/2 + 40;//由之前20改为40，关闭按钮较之前右移20 QINWG 2015-06-15
			btnClose.y = photoHeight - arrowSize + 35;//在之前基础上增加30 QINWG 2015-06-15
			btnClose.width = arrowSize;
			btnClose.height = arrowSize;
//			btnClose.addEventListener(MouseEvent.CLICK, onClose);
			btnClose.addEventListener(TouchEvent.TAP, onClose);
			// this.addChild(btnClose);// 先后顺序 CAOZQ 20150615
			
			sprFav.x = imageOffsetArray[2].x + 20;
			sprFav.y = imageOffsetArray[2].y + 20;
			sprFav.width = 20;
			sprFav.height = 20;
			// this.addChild(sprFav);// 心形不显示 CAOZQ 20150615
			
			var tf:TextFormat = new TextFormat();
			tf.size = 20;
			tf.font = "Georgia";
			tf.align = TextFormatAlign.LEFT;
			// 点赞数量位置调整 CAOZQ 20150615 STR
			// txtFav.x = sprFav.x + 30;
			// txtFav.y = sprFav.y - 5;
			txtFav.x = btnFavor.x + 100;
			txtFav.y = btnFavor.y + 58;
			// 点赞数量位置调整 CAOZQ 20150615 END
			txtFav.textColor = 0xe43322;
			txtFav.selectable = false;
			txtFav.defaultTextFormat = tf;
			txtFav.setTextFormat(tf);
			txtFav.text = "0";
			// this.addChild(txtFav);// 先后顺序 CAOZQ 20150615
			
			/*初始化关闭按钮*/
//			clsBtn = new CloseBtn();
//			clsBtn.x = photoWidth-clsBtn.width;
//			clsBtn.addEventListener(MouseEvent.CLICK, onClose);
//			this.addChild(clsBtn);
		}
		
		private function showBarcode():void{
			if (_viewBarcode.alpha==0) {
				_viewBarcode.alpha = 1;
			} else {
				_viewBarcode.alpha = 0;
			}
		}
		
		private function onFavor(evt:Event):void{

			// 开启自关闭倒计时 CAOZQ 20150617 STR
			autoCloseTimerRestart();
			// 开启自关闭倒计时 CAOZQ 20150617 END

			// 添加点赞按钮动画效果 CAOZQ 20150623 STR
			btnFavor.gotoAndPlay(2);
			// 添加点赞按钮动画效果 CAOZQ 20150623 END

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
		
		private function onBarcode(evt:Event):void {

			// 开启自关闭倒计时 CAOZQ 20150617 STR
			autoCloseTimer.reset();
			autoCloseTimer.start();
			// 开启自关闭倒计时 CAOZQ 20150617 END

			this.showBarcode();
		}
		
		private function onLeft(evt:Event):void {
			if(canInteractive==false)return;
			canInteractive = false;

			// 首张图片的左右拖放 CAOZQ 20150612 STR
			// 先移走监听事件
			var ld:PhotoLoader = photoArray[currentIndex];
			// 移除TAP_DOWN
			ld.removeEventListener(TouchEvent.TOUCH_DOWN, onCurrentImgTouchDown);
			// 移除TAP_MOVE
			ld.removeEventListener(TouchEvent.TOUCH_MOVE, onCurrentImgTouchMove);
			// 移除TAP_UP
			ld.removeEventListener(TouchEvent.TOUCH_UP, onCurrentImgTouchUp);
			// 移除TAP_OUT
			ld.removeEventListener(TouchEvent.TOUCH_OUT, onCurrentImgTouchOut);
			// 首张图片的左右拖放 CAOZQ 20150612 END

			currentIndex = fixOutOfRange(currentIndex-1);
			ld = photoArray[fixOutOfRange(currentIndex-2)];
			ld.imageIndex = Constants.getPrevImageIndex(photoArray[fixOutOfRange(currentIndex-1)].imageIndex);
			isAnimation = true;
		}
		
		private function onRight(evt:Event):void {
			if(canInteractive==false)return;
			canInteractive = false;

			// 首张图片的左右拖放 CAOZQ 20150612 STR
			// 先移走监听事件
			var ld:PhotoLoader = photoArray[currentIndex];
			// 移除TAP_DOWN
			ld.removeEventListener(TouchEvent.TOUCH_DOWN, onCurrentImgTouchDown);
			// 移除TAP_MOVE
			ld.removeEventListener(TouchEvent.TOUCH_MOVE, onCurrentImgTouchMove);
			// 移除TAP_UP
			ld.removeEventListener(TouchEvent.TOUCH_UP, onCurrentImgTouchUp);
			// 移除TAP_OUT
			ld.removeEventListener(TouchEvent.TOUCH_OUT, onCurrentImgTouchOut);
			// 首张图片的左右拖放 CAOZQ 20150612 END

			currentIndex = fixOutOfRange(currentIndex+1);
			ld = photoArray[fixOutOfRange(currentIndex+2)];
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

			// 图片不再统一大小，而是锁定长宽比 CAOZQ 20150618 STR
			var breWidth:Number = ld.contentLoaderInfo.width;
			var breHeight:Number = ld.contentLoaderInfo.height;
			var pantograph:Number = breWidth/breHeight;

			var newImgWidth:Number = 0;
			var newImgHeight:Number = 0;

			if (breWidth > breHeight) {
				newImgWidth	= imageWidthArray[tmp];
				newImgHeight = newImgWidth/pantograph;
			} else {
				newImgHeight = imageHeightArray[tmp];
				newImgWidth = newImgHeight * pantograph;
			}

			var con:* = ld.content;
			// con.width = imageWidthArray[tmp];
			// con.height = imageHeightArray[tmp];
			con.width = newImgWidth;
			con.height = newImgHeight;
			// 图片不再统一大小，而是锁定长宽比 CAOZQ 20150618 END

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

			// 首张图片的左右拖放 CAOZQ 20150612 STR
			// 先添加监听事件
			var ld:PhotoLoader = photoArray[currentIndex];
			// 添加TAP_DOWN
			ld.addEventListener(TouchEvent.TOUCH_DOWN, onCurrentImgTouchDown);
			// 添加TAP_MOVE
			ld.addEventListener(TouchEvent.TOUCH_MOVE, onCurrentImgTouchMove);
			// 添加TAP_UP
			ld.addEventListener(TouchEvent.TOUCH_UP, onCurrentImgTouchUp);
			// 添加TAP_OUT
			ld.addEventListener(TouchEvent.TOUCH_OUT, onCurrentImgTouchOut);
			// 首张图片的左右拖放 CAOZQ 20150612 END

			var imageIndex:int = photoArray[currentIndex].imageIndex;
			var count:int = Constants.favCountArray[imageIndex]==null?0:Constants.favCountArray[imageIndex];
			txtFav.text = count.toString();

			// 图片改变二维码不刷新BUG修正 CAOZQ 20150617 STR
			bar.load(new URLRequest(Constants.getBarcodeImageName((imageIndex + 1).toString())));
			// 图片改变二维码不刷新BUG修正 CAOZQ 20150617 END

			if(isAnimation){
				for(var i:int=0;i<sort.length;i++){
//					TweenLite.to(tmp,Constants.photoAnimationDuration,{x:offset_x,y:offset_y});
//					photoArray[sort[i]].content.width = imageWidthArray[i];
//					photoArray[sort[i]].content.height = imageHeightArray[i];
//					photoArray[sort[i]].x = imageOffsetArray[i].x;
//					photoArray[sort[i]].y = imageOffsetArray[i].y;

					// 图片不再统一大小，而是锁定长宽比 CAOZQ 20150618 STR
					var imgObj = photoArray[sort[i]].content;
					var breWidth:Number = imgObj.width;
					var breHeight:Number = imgObj.height;
					var pantograph:Number = breWidth/breHeight;

					var newImgWidth:Number = 0;
					var newImgHeight:Number = 0;

					if (breWidth > breHeight) {
						newImgWidth	= imageWidthArray[i];
						newImgHeight = newImgWidth/pantograph;
					} else {
						newImgHeight = imageHeightArray[i];
						newImgWidth = newImgHeight * pantograph;
					}
					// TweenLite.to(photoArray[sort[i]].content,Constants.photoAnimationDuration,{width:imageWidthArray[i],height:imageHeightArray[i]});
					TweenLite.to(photoArray[sort[i]].content,Constants.photoAnimationDuration,{width:newImgWidth,height:newImgHeight});
					// 图片不再统一大小，而是锁定长宽比 CAOZQ 20150618 END
					
					TweenLite.to(photoArray[sort[i]],Constants.photoAnimationDuration,{x:imageOffsetArray[i].x,y:imageOffsetArray[i].y});
				}
				isAnimation = false;
			}
		}
		
		/*关闭方法，当用户点击相框的关闭按钮触发*/
		private function onClose(evt:Event):void {

			// 开启自关闭倒计时 CAOZQ 20150617 STR
			autoCloseTimer.reset();
			// 开启自关闭倒计时 CAOZQ 20150617 END

			closeHandler(this);
		}
		
		/**
		 * 加载并显示相框图*/
		public function show(imageId:String):void 
		{
			// 开启自关闭倒计时 CAOZQ 20150617 STR
			autoCloseTimerRestart();
			// 开启自关闭倒计时 CAOZQ 20150617 END

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
			// 图片改变二维码不刷新BUG修正 CAOZQ 20150617 STR
			// var bar:Loader = new Loader();
			// bar.contentLoaderInfo.addEventListener(Event.COMPLETE,onBarcodeComplete);
			// 图片改变二维码不刷新BUG修正 CAOZQ 20150617 END
			bar.load(new URLRequest(Constants.getBarcodeImageName(imageId)));
			_viewBarcode.addChild(bar);
			_viewBarcode.alpha = 0;
		}
		private function onBarcodeComplete(evt:Event):void{
			var ld:Loader = evt.target.loader;
			ld.content.width = 137;
			ld.content.height = 137;
			// 图片改变二维码不刷新BUG修正 CAOZQ 20150617 STR
			// ld.contentLoaderInfo.removeEventListener(Event.COMPLETE, onBarcodeComplete);
			// 图片改变二维码不刷新BUG修正 CAOZQ 20150617 END
		}

		// 开启自关闭倒计时 CAOZQ 20150617 STR
		function autoCloseTimerRestart() {
			autoCloseTimer.reset();
			autoCloseTimer.start();
		}
		// 开启自关闭倒计时 CAOZQ 20150617 END

		// 首张图片的左右拖放 CAOZQ 20150612 STR
		private function onCurrentImgTouchDown(e:TouchEvent):void {

			// 开启自关闭倒计时 CAOZQ 20150617 STR
			autoCloseTimerRestart();
			// 开启自关闭倒计时 CAOZQ 20150617 END

			var ld:PhotoLoader = e.target as PhotoLoader;
			ld.isTouchDown = true;
			ld.initTouchDown(e.stageX, e.stageY);
		}
		private function onCurrentImgTouchMove(e:TouchEvent):void {
			// 开启自关闭倒计时 CAOZQ 20150617 STR
			autoCloseTimerRestart();
			// 开启自关闭倒计时 CAOZQ 20150617 END

			var ld:PhotoLoader = e.target as PhotoLoader;
			if (ld.isTouchDown) {
				// trace("onCurrentImgTouchMove");
				ld.x = e.stageX + ld.lenX;
			}
		}
		private function onCurrentImgTouchUp(e:TouchEvent):void {
			// 开启自关闭倒计时 CAOZQ 20150617 STR
			autoCloseTimerRestart();
			// 开启自关闭倒计时 CAOZQ 20150617 END

			var ld:PhotoLoader = e.target as PhotoLoader;
			if (ld.isTouchDown) {
				// trace("onCurrentImgTouchUp");
				ld.isTouchDown = false;
				var curX = ld.x;
				ld.x = ld.firstX;
				ld.y = ld.firstY;
				// 判断loader的边界有没有过中线准备切换
				if (curX >= (ld.x + 300)) {
					// 右划
					onLeft(e);
				} else if (curX <= (ld.x - 300)) {
					// 左划
					onRight(e);
				}
			}

		}
		private function onCurrentImgTouchOut(e:TouchEvent):void {
			// 开启自关闭倒计时 CAOZQ 20150617 STR
			autoCloseTimerRestart();
			// 开启自关闭倒计时 CAOZQ 20150617 END

			onCurrentImgTouchUp(e);
		}
		// 首张图片的左右拖放 CAOZQ 20150612 END
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