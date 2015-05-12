package
{
	import com.greensock.TweenLite;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	public class PhotoFrameView extends BaseSprite
	{
		
		/*关闭按钮对象*/
		private var clsBtn:CloseBtn;
		
		
		/*相框定宽*/
		public const photoWidth:int = 904;
		
		/*相框定高*/
		public const photoHeight:int = 567;
		
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
		private var imageOffsetArray:Array = [{x:arrowSize+padding,y:177}, {x:133,y:124}, {x:166,y:71}, {x:346,y:124}, {x:522,y:177}];
		
		private var btnLeft:ButtonLeft = new ButtonLeft();
		private var btnRight:ButtonRight = new ButtonRight();
		private var btnFavor:ButtonFavor = new ButtonFavor();
		private var btnBarcode:ButtonBarcode = new ButtonBarcode();
		
		/*是否动画*/
		private var isAnimation:Boolean = false;
		
		public function PhotoFrameView()
		{
			super();
			
			/*初始化相框加载器*/
//			photo_loader = new Loader();
//			photo_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPhotoComplete);
			
//			this.addChild(photo_loader);
			for(var i:int=0;i<5;i++){
				var ld:PhotoLoader = new PhotoLoader();
				ld.index = i;
				ld.contentLoaderInfo.addEventListener(Event.COMPLETE, onPhotoComplete);
				ld.x = imageOffsetArray[i].x;
				ld.y = imageOffsetArray[i].y;
				this.addChild(ld);
				photoArray.push(ld);
			}
			
			/*初始化箭头按钮*/
			btnLeft.x = 0;
			btnLeft.y = 252;
			btnLeft.width = arrowSize;
			btnLeft.height = arrowSize;
			btnLeft.addEventListener(MouseEvent.CLICK, onLeft);
			this.addChild(btnLeft);
			
			btnRight.x = 841;
			btnRight.y = 252;
			btnRight.width = arrowSize;
			btnRight.height = arrowSize;
			btnRight.addEventListener(MouseEvent.CLICK, onRight);
			this.addChild(btnRight);
			
			btnFavor.x = photoWidth/2 - arrowSize - 10;
			btnFavor.y = photoHeight - arrowSize;
			btnFavor.width = arrowSize;
			btnFavor.height = arrowSize;
			btnFavor.addEventListener(MouseEvent.CLICK, onFavor);
			this.addChild(btnFavor);
			
			btnBarcode.x = photoWidth/2 + 10;
			btnBarcode.y = photoHeight - arrowSize;
			btnBarcode.width = arrowSize;
			btnBarcode.height = arrowSize;
			btnBarcode.addEventListener(MouseEvent.CLICK, onBarcode);
			this.addChild(btnBarcode);
			
			
			/*初始化关闭按钮*/
			clsBtn = new CloseBtn();
			clsBtn.x = photoWidth-clsBtn.width;
			clsBtn.addEventListener(MouseEvent.CLICK, onClose);
			this.addChild(clsBtn);
		}
		
		private function onFavor(evt:MouseEvent):void{
			
		}
		
		private function onBarcode(evt:MouseEvent):void{
			
		}
		
		private function onLeft(evt:MouseEvent):void{
			trace("left");
			currentIndex = fixOutOfRange(currentIndex-1);
			var ld:PhotoLoader = photoArray[fixOutOfRange(currentIndex-2)];
			ld.imageIndex = Constants.getPrevImageIndex(photoArray[fixOutOfRange(currentIndex-1)].imageIndex);
			isAnimation = true;
		}
		
		private function onRight(evt:MouseEvent):void{
			trace("right");
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
		}
		
		private function tidyup():void{
			var sort:Array = [];
			if(currentIndex==0){
				this.addChild(photoArray[3]);
				this.addChild(photoArray[2]);
				this.addChild(photoArray[4]);
				this.addChild(photoArray[1]);
				this.addChild(photoArray[0]);
				sort = [3,4,0,1,2];
			}else if(currentIndex==1){
				this.addChild(photoArray[3]);
				this.addChild(photoArray[4]);
				this.addChild(photoArray[2]);
				this.addChild(photoArray[0]);
				this.addChild(photoArray[1]);
				sort = [4,0,1,2,3];
			}else if(currentIndex==2){
				this.addChild(photoArray[4]);
				this.addChild(photoArray[0]);
				this.addChild(photoArray[1]);
				this.addChild(photoArray[3]);
				this.addChild(photoArray[2]);
				sort = [0,1,2,3,4];
			}else if(currentIndex==3){
				this.addChild(photoArray[1]);
				this.addChild(photoArray[0]);
				this.addChild(photoArray[2]);
				this.addChild(photoArray[4]);
				this.addChild(photoArray[3]);
				sort = [1,2,3,4,0];
			}else if(currentIndex==4){
				this.addChild(photoArray[2]);
				this.addChild(photoArray[1]);
				this.addChild(photoArray[3]);
				this.addChild(photoArray[0]);
				this.addChild(photoArray[4]);
				sort = [2,3,4,0,1];
			}
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
		private function onClose(evt:MouseEvent):void {
			closeHandler(this);
		}
		
		/**
		 * 加载并显示相框图*/
		public function show(imageId:String):void {
			/*加载图片1*/
			var index:int = int(imageId) - 1;
			trace("ind:"+index.toString());
			index = Constants.getPrevImageIndex(index);
			index = Constants.getPrevImageIndex(index);
			trace("ind2:"+index.toString());
			for(var i:int=0;i<photoArray.length;i++){
				var ld:PhotoLoader = photoArray[i] as PhotoLoader;
				ld.imageIndex = index;
				trace("load:"+index.toString());
				index = Constants.getNextImageIndex(index);
			}
		}
		
		/**
		 * 退出并隐藏相框*/
		public function hide():void {
//			photo_loader.unloadAndStop();
		}
		
		/**
		 * 关闭相框代理，回调时需传this对象*/
		public var closeHandler:Function;
	}
}