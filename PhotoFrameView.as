package
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	public class PhotoFrameView extends BaseSprite
	{
		
		public function PhotoFrameView()
		{
			super();
			
			/*初始化相框加载器*/
			photo_loader = new Loader();
			photo_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPhotoComplete);
			this.addChild(photo_loader);
			
			/*相框图加载完成后回调方法*/
			function onPhotoComplete(evt:Event):void{
				photo_loader.content.width = photoWidth;
				photo_loader.content.height = photoHeight;
			}
			
			/*初始化关闭按钮*/
			clsBtn = new CloseBtn();
			clsBtn.x = photoWidth-clsBtn.width;
			clsBtn.addEventListener(MouseEvent.CLICK, onClose);
			this.addChild(clsBtn);
		}
		
		/*关闭方法，当用户点击相框的关闭按钮触发*/
		private function onClose(evt:MouseEvent):void {
			closeHandler(this);
		}
		
		/**
		 * 加载并显示相框图*/
		public function show(imageId:String):void {
			var url:String = Constants.getBigImageName(imageId);
			photo_loader.load(new URLRequest(url));
		}
		
		/**
		 * 退出并隐藏相框*/
		public function hide():void {
			photo_loader.unloadAndStop();
		}
		
		/*关闭按钮对象*/
		private var clsBtn:CloseBtn;
		
		/*相框图加载器*/
		/**
		 * 4-----5
		 *  2---3
		 *    1
		 */
		private var photo_loader:Loader = null;
		private var photo_loader2:Loader = null;
		private var photo_loader3:Loader = null;
		private var photo_loader4:Loader = null;
		private var photo_loader5:Loader = null;
		
		/*相框定宽*/
		public const photoWidth:int = 300;
		
		/*相框定高*/
		public const photoHeight:int = 200;
		
		private const pic1Width:int = 200;
		private const pic2Width:int = 150;
		private const pic3Width:int = 100;
		private const pic1Height:int = 150;
		private const pic2Height:int = 100;
		private const pic3Height:int = 70;
		
		/**
		 * 关闭相框代理，回调时需传this对象*/
		public var closeHandler:Function;
	}
}