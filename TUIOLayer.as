package
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	public class TUIOLayer extends Sprite
	{
		private var isTapped:Boolean = false;
		public function TUIOLayer(_stage:Stage)
		{
			graphics.beginFill(0x000000,0.1);
			graphics.drawRect(0,0,_stage.stageWidth,_stage.stageHeight);
			graphics.endFill();
			
//			this.addEventListener(MouseEvent.CLICK, onClick);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			
		}
		private function onDown(evt:MouseEvent):void{
			trace("down");
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			this.addEventListener(MouseEvent.MOUSE_UP, onUp);
		}
		private function onMove(evt:MouseEvent):void{
			
		}
		private function onUp(evt:MouseEvent):void{
			
		}
		private function onClick(evt:MouseEvent):void{
			trace("click");
			var event:TableViewEvent = new TableViewEvent(TableViewEvent.MASKDIDTAPPED);
			event.offsetX = evt.localX;
			event.offsetY = evt.localY;
			dispatchEvent(event);
		}
	}
}