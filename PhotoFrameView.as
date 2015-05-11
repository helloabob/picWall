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
		private var imageWidthArray:Array = [100, 150, 200, 150, 100];
		
		/**
		 * 高度数组
		 */
		private var imageHeightArray:Array = [70, 100, 150, 100, 50];
		
		/**
		 * 偏移量数组
		 */
		private var imageOffsetArray:Array = [{x:10,y:0}, {x:20,y:10}, {x:30,y:20}, {x:40,y:10}, {x:50,y:0}];
		
		
		
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
			
			/*相框图加载完成后回调方法*/
			function onPhotoComplete(evt:Event):void{
//				photo_loader.content.width = photoWidth;
//				photo_loader.content.height = photoHeight;
				var ld:PhotoLoader = evt.target as PhotoLoader;
				if(ld==null){
					trace("null pointer");
					return;
				}
				ld.unloadAndStop();
				ld.removeChildren();
				var aa:TextField = new TextField();
				aa.text = ld.imageIndex.toString();
				ld.addChild(aa);
				var delta:int = currentIndex - defaultIndex;
				var tmp:int = ld.index - delta;
				if(tmp<0)tmp+=5;
				else if(tmp>4)tmp-=5;
				var con:* = ld.content;
				con.width = imageWidthArray[tmp];
				con.height = imageHeightArray[tmp];
				this.tidyup();
//				TweenLite.to(this,Constants.photoAnimationDuration,{width:photoWidth+50,height:photoHeight+50});
			}
			
			/*初始化关闭按钮*/
			clsBtn = new CloseBtn();
			clsBtn.x = photoWidth-clsBtn.width;
			clsBtn.addEventListener(MouseEvent.CLICK, onClose);
			this.addChild(clsBtn);
		}
		
		private function tidyup():void{
			if(currentIndex==0){
				this.addChild(photoArray[3]);
				this.addChild(photoArray[2]);
				this.addChild(photoArray[4]);
				this.addChild(photoArray[1]);
				this.addChild(photoArray[0]);
			}else if(currentIndex==1){
				this.addChild(photoArray[3]);
				this.addChild(photoArray[4]);
				this.addChild(photoArray[2]);
				this.addChild(photoArray[0]);
				this.addChild(photoArray[1]);
			}else if(currentIndex==2){
				trace("c=2");
				this.addChild(photoArray[4]);
				this.addChild(photoArray[0]);
				this.addChild(photoArray[1]);
				this.addChild(photoArray[3]);
				this.addChild(photoArray[2]);
			}else if(currentIndex==3){
				this.addChild(photoArray[1]);
				this.addChild(photoArray[0]);
				this.addChild(photoArray[2]);
				this.addChild(photoArray[4]);
				this.addChild(photoArray[3]);
			}else if(currentIndex==4){
				this.addChild(photoArray[2]);
				this.addChild(photoArray[1]);
				this.addChild(photoArray[3]);
				this.addChild(photoArray[0]);
				this.addChild(photoArray[4]);
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
			index = Constants.getPrevImageIndex(index);
			index = Constants.getPrevImageIndex(index);
			for(var i:int=0;i<photoArray.length;i++){
				var ld:PhotoLoader = photoArray[i] as PhotoLoader;
				ld.imageIndex = index;
				index = Constants.getNextImageIndex(index);
			}
		}
		
		/**
		 * 退出并隐藏相框*/
		public function hide():void {
//			photo_loader.unloadAndStop();
		}
		
		/*关闭按钮对象*/
		private var clsBtn:CloseBtn;
		
		/*相框图加载器*/
		/**
		 * 4-----5
		 *  2---3
		 *    1
		 */
//		private var photo_loader:Loader = null;
//		private var photo_loader2:Loader = null;
//		private var photo_loader3:Loader = null;
//		private var photo_loader4:Loader = null;
//		private var photo_loader5:Loader = null;
		
		/*相框定宽*/
		public const photoWidth:int = 300;
		
		/*相框定高*/
		public const photoHeight:int = 200;
		
		/**
		 * 关闭相框代理，回调时需传this对象*/
		public var closeHandler:Function;
	}
}