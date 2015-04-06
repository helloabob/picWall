package
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;

	public class PhotoFrameController
	{
		/*堆栈里的相框字典*/
		private var photoFramesStack:Array = new Array();
		
		/*已展示相框字典*/
		private var photoFramesShown:Array = new Array();
		
		/*画布，相框显示在该画布上，由外部类直接赋值*/
		public var canvas:Sprite;
		
		public function PhotoFrameController()
		{
			/*初始化8个相框元素*/
			for(var i:int = 0;i<8;i++){
				var photo:PhotoFrameView = new PhotoFrameView();
				photo.graphics.beginFill(0xff00ff,1);
				photo.graphics.drawRect(0,0,200,200);
				photo.graphics.endFill();
				photoFramesStack.push(photo);
				photo.closeHandler = hidePhotoFrame;
			}
		}
		
		/*展示8个相框通用方法*/
		public function showPhotoFrame(imageId:String):void {
			if(photoFramesStack.length<=0)return;
			var photo:PhotoFrameView = photoFramesStack.pop();
			photoFramesShown.push(photo);
			canvas.addChild(photo);
			photo.x = Constants.appWidth/2 - photo.photoWidth/2;
			photo.y = Constants.appHeight/2 - photo.photoHeight/2;
			/*准备显示*/
			photo.show(imageId);
			
			var targetX:int = 100;
			var targetY:int = 200;
			
			/*相框显示动画*/
			TweenLite.to(photo,Constants.photoAnimationDuration,{x:targetX,y:targetY});
		}
		
		/*隐藏某个相框方法*/
		private function hidePhotoFrame(photoView:PhotoFrameView):void{
			if(photoFramesShown.length<=0)return;
			for each(var photo:PhotoFrameView in photoFramesShown){
				if(photo == photoView){
					photo.removeFromSuperView();
					photoFramesShown.splice(photoFramesShown.indexOf(photo),1);
					photoFramesStack.push(photo);
					/*准备隐藏*/
					photo.hide();
				}
			}
		}
	}
}