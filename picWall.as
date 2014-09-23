package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.utils.Dictionary;
	
//	[SWF(width=1920,height=1080,backgroundColor=0xffffff)]
	[SWF(width=800,height=450,backgroundColor=0xffffff)]
	public class picWall extends Sprite
	{
		private var imageList:Array = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"];
		private var vc:TableViewController;
		private var bitmapList:Dictionary = new Dictionary();
		public function picWall()
		{
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.EXACT_FIT;
			
			vc = new TableViewController();
			vc.rows = 6;
			vc.cols = 10;
			vc.stage = stage;
			vc.lists = imageList;
			addChild(vc.view);
			
			var mask:TUIOLayer = new TUIOLayer(stage);
			mask.addEventListener(TableViewEvent.MASKDIDTAPPED, onMaskTapped);
			mask.addEventListener(TableViewEvent.MASKTOUCHDOWN, onMaskTouchDown);
			mask.addEventListener(TableViewEvent.MASKTOUCHMOVE, onMaskTouchMove);
			mask.addEventListener(TableViewEvent.MASKTOUCHUP, onMaskTouchUp);
			addChild(mask);
			
			vc.start();
//			
//			stage.addEventListener(TouchEvent.TAP, onTap);
//			stage.addEventListener(TouchEvent.TOUCH_DOWN,onTouchDown);
		}
		private function tracelog(str:String):void{
			trace(str);
//			txt.text+=(str+"\n");
		}
		
		private function onMaskTapped(evt:TableViewEvent):void{
			vc.showImageWithAnimation(evt.offsetX,evt.offsetY);
		}
		private function onMaskTouchDown(evt:TableViewEvent):void{
			vc.showImageWithAnimation(evt.offsetX,evt.offsetY);
		}
		private function onMaskTouchMove(evt:TableViewEvent):void{
			vc.showImageWithAnimation(evt.offsetX,evt.offsetY);
		}
		private function onMaskTouchUp(evt:TableViewEvent):void{
			vc.showImageWithAnimation(evt.offsetX,evt.offsetY);
		}
		
		private function viewDidAppear(evt:TableViewEvent):void{
			
		}
		
		private function cellForRender(evt:TableViewEvent):void{
			
		}
	}
}