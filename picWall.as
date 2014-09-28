package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	[SWF(width=1920,height=1080,backgroundColor=0xffffff)]
//	[SWF(width=800,height=450,backgroundColor=0xffffff)]
	public class picWall extends Sprite
	{
		private var imageList:Array = [];
		private var vc:TableViewController;
		private var activelayer:Sprite;
//		private var bigitemlayer:Sprite;
		private var moveBitmap:Bitmap;
		private var moveloader:Loader;
		private var moveImageId:String;
		private var isBigItem:Boolean;
		public function picWall()
		{
			for(var i:int=1;i<=Constants.imageLists.length;i++){
				imageList.push(i.toString());
			}
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.EXACT_FIT;
			
			vc = new TableViewController();
			vc.addEventListener(TableViewEvent.ITEMWILLSHOW, onItemWillShow);
//			vc.rows = 6;
//			vc.cols = 10;
			vc.rows = 9;
			vc.cols = 15;
			vc.stage = stage;
			vc.lists = imageList;
			addChild(vc.view);
			
			activelayer = new Sprite();
			addChild(activelayer);
			
//			bigitemlayer = new Sprite();
//			addChild(bigitemlayer);
			
			var mask:TUIOLayer = new TUIOLayer(stage);
			mask.addEventListener(TableViewEvent.MASKDIDTAPPED, onMaskTapped);
			mask.addEventListener(TableViewEvent.MASKTOUCHDOWN, onMaskTouchDown);
			mask.addEventListener(TableViewEvent.MASKTOUCHMOVE, onMaskTouchMove);
			mask.addEventListener(TableViewEvent.MASKTOUCHUP, onMaskTouchUp);
			mask.addEventListener(TableViewEvent.ITEMDIDZOOM, onMaskZoom);
			addChild(mask);
			
			vc.start();
			
			
//			
//			stage.addEventListener(TouchEvent.TAP, onTap);
//			stage.addEventListener(TouchEvent.TOUCH_DOWN,onTouchDown);
		}
		
		private function onMaskZoom(evt:TableViewEvent):void{
			if(activelayer.contains(BigImageItem.instance)){
				BigImageItem.instance.zoomImage(evt);
//				BigImageItem.instance.scaleX+=evt.deltaScale;
//				BigImageItem.instance.scaleY+=evt.deltaScale;
//				BigImageItem.instance.restartTimer();
			}
		}
		
		private function onItemWillShow(evt:TableViewEvent):void{
			BigImageItem.instance.showImage(evt.item["imageId"],stage,activelayer);
		}
		
		private function tracelog(str:String):void{
			trace(str);
//			txt.text+=(str+"\n");
		}
		
		private function isInBigItemArea(evt:TableViewEvent):Boolean{
			if(activelayer.numChildren > 0){
				var nx:int = BigImageItem.instance.x;
				var ny:int = BigImageItem.instance.y;
				var nw:int = BigImageItem.instance.contentWidth;
				var nh:int = BigImageItem.instance.contentHeight;
				if(evt.offsetX>=nx&&evt.offsetX<=nx+nw&&evt.offsetY>=ny&&evt.offsetY<=ny+nh){
					return true;
				}
			}
			return false;
		}
		
		private function onMaskTapped(evt:TableViewEvent):void{
			if(isInBigItemArea(evt)==false)vc.showImageWithAnimation(evt.offsetX,evt.offsetY);
			else{
				BigImageItem.instance.tapImage(evt);
			}
		}
		private function onMaskTouchDown(evt:TableViewEvent):void{
			isBigItem = isInBigItemArea(evt);
			if(isBigItem==true)return;
			
			var item:ImageItem = vc.getSpriteAtPoint(evt.offsetX,evt.offsetY);if(item==null)return;
			moveImageId = item.id;
			var sp:Sprite = item.content;
			
			var bmd:BitmapData = new BitmapData(sp.width,sp.height);
			bmd.draw(sp);
			moveBitmap = new Bitmap(bmd);
			moveBitmap.x = evt.offsetX-bmd.width/2;
			moveBitmap.y = evt.offsetY-bmd.height/2;
		}
		private function onMaskTouchMove(evt:TableViewEvent):void{
//			vc.showImageWithAnimation(evt.offsetX,evt.offsetY);
			if(isBigItem){
				BigImageItem.instance.moveImage(evt.offsetX,evt.offsetY);
			} else {
				if(!activelayer.contains(moveBitmap))activelayer.addChild(moveBitmap);
				moveBitmap.x+=evt.offsetX;
				moveBitmap.y+=evt.offsetY;
			}
		}
		private function onMaskTouchUp(evt:TableViewEvent):void{
			if(isBigItem==false){
				if(activelayer.contains(moveBitmap))activelayer.removeChild(moveBitmap);
				moveBitmap.bitmapData.dispose();
				moveBitmap.bitmapData = null;
				moveBitmap = null;
				
				var nx:int = stage.stageWidth/2-BigImageItem.instance.contentWidth/2;
				var ny:int = stage.stageHeight/2-BigImageItem.instance.contentHeight/2;
				var nw:int = BigImageItem.instance.contentWidth;
				var nh:int = BigImageItem.instance.contentHeight;
				if(evt.offsetX>=nx&&evt.offsetX<=nx+nw&&evt.offsetY>=ny&&evt.offsetY<=ny+nh){
					BigImageItem.instance.showImage(moveImageId,stage,activelayer);
				}
			}
		}
		
		private function viewDidAppear(evt:TableViewEvent):void{
			
		}
		
		private function cellForRender(evt:TableViewEvent):void{
			
		}
	}
}