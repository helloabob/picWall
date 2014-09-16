package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	[SWF(width=600,height=400,backgroundColor=0xffffff)]
	public class picWall extends Sprite
	{
		public function picWall()
		{
//			this.graphics.beginFill(0x0000ff,1);
//			this.graphics.drawRect(10,10,200,100);
//			this.graphics.endFill();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;
			
			var vc:TableViewController = new TableViewController();
//			vc.addEventListener(TableViewEvent.VIEWDIDAPPEAR,viewDidAppear);
//			vc.addEventListener(TableViewEvent.CELLFORRENDER,cellForRender);
			vc.rows = 3;
			vc.stage = stage;
			vc.lists = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"];
			addChild(vc.view);
			vc.start();
		}
		
		private function viewDidAppear(evt:TableViewEvent):void{
			
		}
		
		private function cellForRender(evt:TableViewEvent):void{
			
		}
	}
}