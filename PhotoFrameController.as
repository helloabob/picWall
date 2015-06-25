package
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;

	public class PhotoFrameController
	{
		/*堆栈里的相框字典*/
		private var photoFramesStack:Array = new Array();
		
		/*已展示相框字典*/
		private var photoFramesShown:Array = [null,null,null,null,null,null,null,null];
		
		/*画布，相框显示在该画布上，由外部类直接赋值*/
		public var canvas:Sprite;
		
		public function PhotoFrameController()
		{
			/*初始化8个相框元素*/
			for(var i:int = 0;i<8;i++){
				var photo:PhotoFrameView = new PhotoFrameView();
//				photo.graphics.beginFill(0x000000,1);
//				photo.graphics.drawRect(0,0,200,200);
//				photo.graphics.endFill();
				photoFramesStack.push(photo);
				photo.closeHandler = hidePhotoFrame;
			}
		}
		
		/*展示8个相框通用方法*/
		public function showPhotoFrame(imageId:String, offset_x:int):void {
//------------QINWG图框出现在点击所在屏幕 START 2015-06-15 10:06:55-------------
			//if(photoFramesStack.length<=0)return;
			/*计算摆放位置*/
			var tmp:int = 0;
			for(var i:int=1;i<=8;i++){
				if(offset_x<=i*960){
					tmp=i;
					break;
				}
			}
			
/* 
			var photo:PhotoFrameView = photoFramesStack.pop();
			
			if(tmp==0)tmp=8;
			tmp = tmp-1;
			var res:int = 0;
			for(var j:int=0;j<8;j++){
				res = tmp + j;
				if(res>=8)res=res-8;
				if(photoFramesShown[res]==null){
					photoFramesShown[res]=photo;
					break;
				}
			}
			
			photo.photoIndex = res;
			photo.x = res*960 + (960-photo.photoWidth)/2;
			photo.y = (540-photo.photoHeight)/2;
*/
			if(tmp==0)tmp=8;
			tmp = tmp-1;
			var photo:PhotoFrameView = null;
			if(photoFramesShown[tmp]!=null){
				photo = photoFramesShown[tmp];
			}else{
				photo = photoFramesStack.pop();
				photoFramesShown[tmp]=photo;
			}
			photo.photoIndex = tmp;
			photo.x = tmp*960 + (960-photo.photoWidth)/2;
			// 相框整体下移 CAOZQ 20150615 STR
			// photo.y = (540-photo.photoHeight)/2;
			photo.y = (540-photo.photoHeight)/2 + 84;
			// 相框整体下移 CAOZQ 20150615 END
			
			/*end*/
//------------QINWG图框出现在点击所在屏幕 END 2015-06-15 10:06:55--------------			
			
//			photoFramesShown.push(photo);
			canvas.addChild(photo);
//			photo.x = Constants.appWidth/2 - photo.photoWidth/2;
//			photo.y = Constants.appHeight/2 - photo.photoHeight/2;
			/*准备显示*/
			photo.show(imageId);
//			tidyUp();
			
//			var targetX:int = 100;
//			var targetY:int = 200;
//			
		}
		
//		private function tidyUp():void{
//			var len:int = canvas.numChildren;
//			trace(len);
//			var offset_x;
//			var offset_y;
//			for(var i=1;i<len;i++){
//				var tmp:* = canvas.getChildAt(i);
//				if(i<5){
//					offset_x=50+(i-1)*(tmp.photoWidth+10);
//					offset_y=150;
////					TweenLite.to(tmp,Constants.photoAnimationDuration,{x:offset_x,y:offset_y});
//				}else{
//					var y=i-4;
//					offset_x=50+(y-1)*(tmp.photoWidth+10);
//					offset_y=150+tmp.photoHeight+50;
////					TweenLite.to(tmp,Constants.photoAnimationDuration,{x:offset_x,y:offset_y});
//				}
//				tmp.x = offset_x;
//				tmp.y = offset_y;
//			}
//		}
		
		/*隐藏某个相框方法*/
		private function hidePhotoFrame(photoView:PhotoFrameView):void{
			if(photoFramesShown.length<=0)return;
			photoFramesShown[photoView.photoIndex] = null;
			photoView.removeFromSuperView();
			photoFramesStack.push(photoView);
			photoView.hide();
//			for each(var photo:PhotoFrameView in photoFramesShown){
//				if(photo == photoView){
//					photo.removeFromSuperView();
////					photoFramesShown.splice(photoFramesShown.indexOf(photo),1);
//					photoFramesStack.push(photo);
//					/*准备隐藏*/
//					photo.hide();
//					
////					tidyUp();
//				}
//			}
		}
	}
}