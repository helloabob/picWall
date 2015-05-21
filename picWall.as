package
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.fscommand;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	[SWF(width=7680,height=1080,backgroundColor=0xffffff,frameRate=20)]
//	[SWF(width=1280,height=720,backgroundColor=0xffffff,frameRate=20)]
//	[SWF(width=960,height=540,backgroundColor=0xffffff,frameRate=20)]
	public class picWall extends Sprite
	{
		private var imageList:Array = [];
		private var vc:TableViewController;
//		private var activelayer:Sprite;
//		private var bigitemlayer:Sprite;
		private var moveBitmap:Bitmap;
		private var moveloader:Loader;
		private var moveImageId:String;
		private var isBigItem:Boolean;
		private var canDrag:Boolean;
		
		/*left and right button for switch big image*/
		private var btnLeftArrow:Sprite;
		private var btnRightArrow:Sprite;
		
		private function switchModeTrigger():void{
			vc.switchModel();
			vc.view.alpha = 0;
			TweenLite.to(vc.view,Constants.appearAnimationDuration,{alpha:1});
		}
		public function picWall()
		{
//			flash.system.fscommand("fullscreen","true");
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;
			
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			
			/*load image list txt module*/
			var txt_loader:URLLoader = new URLLoader(new URLRequest("imageList.txt"));
			txt_loader.addEventListener(Event.COMPLETE, on_txt_complete);
			function on_txt_complete(evt:Event):void{
				var content:String = String(evt.target.data);
				Constants.imageLists = content.split(",");
				evt.target.removeEventListener(Event.COMPLETE, on_txt_complete);
				initControl();
			}
		}
		private function initControl():void{
//			trace("a:"+Constants.imageLists.length+"D:"+Constants.imageLists.join("###"));
//			for(var i:int=1;i<=Constants.imageLists.length;i++){
//				imageList.push(i.toString());
//			}
			
			
			
			/*----------for line environment-------attention:reset swf size at Class Definition Area---*/
			//			Constants.totalRowsForNormal = 18;
			//			Constants.totalRowsForLarge = 12;
			//			Constants.smallImageHeight = stage.stageHeight/Constants.totalRowsForNormal;
			//			Constants.bigImageHeight = stage.stageHeight/Constants.totalRowsForLarge;
			/*----------end------------*/
			
			vc = new TableViewController();
//			vc.addEventListener(TableViewEvent.ITEMWILLSHOW, onItemWillShow);
			//			vc.rows = 6;
			//			vc.cols = 10;
//			vc.rows = Constants.totalRowsForNormal;
			vc.rows = Constants.totalRowsArray[0];
			vc.cols = 15;
			vc.stage = stage;
			vc.lists = Constants.imageLists;
			addChild(vc.view);
			
			/*移除活动active图层*/
//			activelayer = new Sprite();
//			addChild(activelayer);
			
			/*switch vc model interval*/
			flash.utils.setInterval(switchModeTrigger,30000);
			
			//			bigitemlayer = new Sprite();
			//			addChild(bigitemlayer);
			
			/*移除mask图层*/
//			var mask:TUIOLayer = new TUIOLayer(stage);
//			mask.addEventListener(TableViewEvent.MASKDIDTAPPED, onMaskTapped);
//			mask.addEventListener(TableViewEvent.MASKTOUCHDOWN, onMaskTouchDown);
//			mask.addEventListener(TableViewEvent.MASKTOUCHMOVE, onMaskTouchMove);
//			mask.addEventListener(TableViewEvent.MASKTOUCHUP, onMaskTouchUp);
//			mask.addEventListener(TableViewEvent.ITEMDIDZOOM, onMaskZoom);
//			addChild(mask);
			
//			BigImageItem.instance.addEventListener(TableViewEvent.ITEMDIDSHOW, onItemDidShow);
//			BigImageItem.instance.addEventListener(TableViewEvent.ITEMDIDHIDE, onItemDidHide);
			
			vc.start();
			
			canDrag=false;
			
			btnLeftArrow = new BtnLeft();
			btnRightArrow = new BtnRight();
			
			
//			var line:Sprite = new Sprite();
//			line.graphics.beginFill(0xff0000,1);
//			line.graphics.drawRect(0,539,Constants.appWidth,3);
//			line.graphics.endFill();
//			this.addChild(line);
//			
//			for(var i:int=1;i<8;i++){
//				line = new Sprite();
//				line.graphics.beginFill(0xff0000,1);
//				line.graphics.drawRect(i*960-1,0,3,Constants.appHeight);
//				line.graphics.endFill();
//				this.addChild(line);
//			}
			
			/*test zoom function*/
			//			var sp:Sprite = new Sprite();
			//			sp.graphics.beginFill(0xff0000,1);
			//			sp.graphics.drawRect(20,20,50,50);
			//			sp.graphics.endFill();
			//			sp.addEventListener(MouseEvent.CLICK, onZoom1);
			//			addChild(sp);
			//			
			//			sp = new Sprite();
			//			sp.graphics.beginFill(0x00ffff,1);
			//			sp.graphics.drawRect(100,20,50,50);
			//			sp.graphics.endFill();
			//			sp.addEventListener(MouseEvent.CLICK, onZoom2);
			//			addChild(sp);
			//			
			//			stage.addEventListener(TouchEvent.TAP, onTap);
			//			stage.addEventListener(TouchEvent.TOUCH_DOWN,onTouchDown);
		}
//		private function onZoom1(evt:MouseEvent):void{
//			var event:TableViewEvent = new TableViewEvent(TableViewEvent.ITEMDIDZOOM);
//			event.deltaScale = 1.1;
//			onMaskZoom(event);
//		}
//		private function onZoom2(evt:MouseEvent):void{
//			var event:TableViewEvent = new TableViewEvent(TableViewEvent.ITEMDIDZOOM);
//			event.deltaScale = 0.9;
//			onMaskZoom(event);
//		}
		
//		private function onMaskZoom(evt:TableViewEvent):void{
//			if(activelayer.contains(BigImageItem.instance)){
//				BigImageItem.instance.zoomImage(evt);
//			}
//		}
		
		/*it is called when big item prepare to show from TableViewController.as*/
//		private function onItemWillShow(evt:TableViewEvent):void{
//			BigImageItem.instance.showImage(evt.item["imageId"],stage,activelayer);
//		}
		
		/*it is called when big image start to show with animation from BigImageItem.as*/
		private function onItemDidShow(evt:TableViewEvent):void{
			var btn_padding:int = 40;
			/*left arrow button*/
			var b_x:int = stage.stageWidth/2 - evt.offsetX/2 - btn_padding - btnLeftArrow.width;
			var b_y:int = stage.stageHeight/2 - btnLeftArrow.height/2;
			btnLeftArrow.x = b_x;
			btnLeftArrow.y = b_y;

			/*right arrow button*/
			b_x = stage.stageWidth/2 + evt.offsetX/2 + btn_padding;
			btnRightArrow.x = b_x;
			btnRightArrow.y = b_y;
			
			/*start animation for buttons*/
			btnLeftArrow.alpha = 0;
			btnRightArrow.alpha = 0;
//			activelayer.addChild(btnLeftArrow);
//			activelayer.addChild(btnRightArrow);
			this.addChild(btnLeftArrow);
			this.addChild(btnRightArrow);
			TweenLite.to(btnLeftArrow,Constants.appearAnimationDuration,{alpha:1});
			TweenLite.to(btnRightArrow,Constants.appearAnimationDuration,{alpha:1});
		}
		
		/*it is called when big image start to hiden from BigImageItem.as*/
		private function onItemDidHide(evt:TableViewEvent):void{
//			if(activelayer.contains(btnLeftArrow))activelayer.removeChild(btnLeftArrow);
//			if(activelayer.contains(btnRightArrow))activelayer.removeChild(btnRightArrow);
			if(this.contains(btnLeftArrow))this.removeChild(btnLeftArrow);
			if(this.contains(btnRightArrow))this.removeChild(btnRightArrow);
		}
		
		private function tracelog(str:String):void{
			trace(str);
//			txt.text+=(str+"\n");
		}
		
//		private function isInBigItemArea(evt:TableViewEvent):Boolean{
//			if(activelayer.numChildren > 0){
//				var nx:int = BigImageItem.instance.x;
//				var ny:int = BigImageItem.instance.y;
//				var nw:int = BigImageItem.instance.contentWidth;
//				var nh:int = BigImageItem.instance.contentHeight;
//				if(evt.offsetX>=nx&&evt.offsetX<=nx+nw&&evt.offsetY>=ny&&evt.offsetY<=ny+nh){
//					return true;
//				}
//			}
//			return false;
//		}
		
		private function rectGetMaxX(src:Sprite):int{
			return src.x + src.width;
		}
		private function rectGetMaxY(src:Sprite):int{
			return src.y + src.height;
		}
		
//		private function onMaskTapped(evt:TableViewEvent):void{
//			canDrag=false;
//			if(isInBigItemArea(evt)==false){
//				if(activelayer.contains(btnLeftArrow)){
//					var nx:int = evt.offsetX;
//					var ny:int = evt.offsetY;
//					if(nx>=btnLeftArrow.x-10
//						&&nx<=rectGetMaxX(btnLeftArrow)+10
//						&&ny>=btnLeftArrow.y-10
//						&&ny<=rectGetMaxY(btnLeftArrow)+10){
//						vc.stepImageIndex(-1);
//						return;
//					}else if(nx>=btnRightArrow.x-10
//						&&nx<=rectGetMaxX(btnRightArrow)+10
//						&&ny>=btnRightArrow.y-10
//						&&ny<=rectGetMaxY(btnRightArrow)+10){
//						vc.stepImageIndex(1);
//						return;
//					}
//				}
//				vc.showImageWithAnimation(evt.offsetX,evt.offsetY);
//			}
//			else{
//				BigImageItem.instance.tapImage(evt);
//			}
//		}
//		private function onMaskTouchDown(evt:TableViewEvent):void{
//			if(canDrag==true)return;
//			isBigItem = isInBigItemArea(evt);
//			
//			if(isBigItem==false){
//				/*drag small image*/
//				var item:MyBitmap = vc.getSpriteAtPoint(evt.offsetX,evt.offsetY);if(item==null)return;
//				moveImageId = item.id;
//				var bmd:BitmapData = new BitmapData(item.width,item.height);
//				bmd.draw(item);
//				/*remove child when there is another move sprite dragging*/
//				if(moveBitmap&&activelayer.contains(moveBitmap)){
//					activelayer.removeChild(moveBitmap);
//				}
//				moveBitmap = new Bitmap(bmd);
//				moveBitmap.x = evt.offsetX-bmd.width/2;
//				moveBitmap.y = evt.offsetY-bmd.height/2;
//				canDrag = true;
//			}else{
//				/*drag big image*/
//				canDrag = true;
//			}
//		}
//		private function onMaskTouchMove(evt:TableViewEvent):void{
//			if(canDrag){
//				if(isBigItem){
//					BigImageItem.instance.moveImage(evt.offsetX,evt.offsetY);
//				} else {
//					if(!activelayer.contains(moveBitmap))activelayer.addChild(moveBitmap);
//					moveBitmap.x+=evt.offsetX;
//					moveBitmap.y+=evt.offsetY;
//				}
//			}
//		}
//		private function onMaskTouchUp(evt:TableViewEvent):void{
//			if(canDrag==true){
//				if(isBigItem==false){
//					if(activelayer.contains(moveBitmap))activelayer.removeChild(moveBitmap);
//					moveBitmap.bitmapData.dispose();
//					moveBitmap.bitmapData = null;
//					moveBitmap = null;
//					
//					var nx:int = stage.stageWidth/2-BigImageItem.instance.contentWidth/2;
//					var ny:int = stage.stageHeight/2-BigImageItem.instance.contentHeight/2;
//					var nw:int = BigImageItem.instance.contentWidth;
//					var nh:int = BigImageItem.instance.contentHeight;
//					if(evt.offsetX>=nx&&evt.offsetX<=nx+nw&&evt.offsetY>=ny&&evt.offsetY<=ny+nh){
//						BigImageItem.instance.showImage(moveImageId,stage,activelayer);
//					}
//				}
//				canDrag=false;
//			}
//		}
		
		private function viewDidAppear(evt:TableViewEvent):void{
			
		}
		
		private function cellForRender(evt:TableViewEvent):void{
			
		}
	}
}