package
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	public class TUIOLayer extends Sprite
	{
		public function TUIOLayer(_stage:Stage)
		{
			graphics.beginFill(0x000000,0.1);
			graphics.drawRect(0,0,_stage.stageWidth,_stage.stageHeight);
			graphics.endFill();
			
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		private function onClick(evt:MouseEvent):void{
			trace("tap_x:"+evt.localX+"   y:"+evt.localY);
			var event:TableViewEvent = new TableViewEvent(TableViewEvent.MASKDIDTAPPED);
			event.tappedOffsetX = evt.localX;
			event.tappedOffsetY = evt.localY;
			dispatchEvent(event);
		}
	}
}