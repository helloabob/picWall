package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	[SWF(width=600,height=400,backgroundColor=0xffffff)]
	public class picWall extends Sprite
	{
		private var imageList:Array = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"];
		private var vc:TableViewController;
		public function picWall()
		{
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;
			
			vc = new TableViewController();
			vc.rows = 3;
			vc.stage = stage;
			vc.lists = imageList;
			addChild(vc.view);
			
			var mask:TUIOLayer = new TUIOLayer(stage);
			mask.addEventListener(TableViewEvent.MASKDIDTAPPED, onMaskTapped);
			addChild(mask);
			
			vc.start();
		}
		
		private function onMaskTapped(evt:TableViewEvent):void{
			vc.showImageWithAnimation(evt.tappedOffsetX,evt.tappedOffsetY);
		}
		
		private function viewDidAppear(evt:TableViewEvent):void{
			
		}
		
		private function cellForRender(evt:TableViewEvent):void{
			
		}
	}
}