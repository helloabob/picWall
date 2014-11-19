package
{
	import com.lylib.touch.OSMultiTouch;
	import com.lylib.touch.events.DirectionEvent;
	import com.lylib.touch.events.ZoomEvent;
	import com.lylib.touch.gestures.DirectionGesture;
	import com.lylib.touch.gestures.ZoomGesture;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.GestureEvent;
	import flash.events.MouseEvent;
	
	public class TUIOLayer extends Sprite
	{
		private var isTapped:Boolean = false;
		private var lastX:int;
		private var lastY:int;
		private var multiTouch:OSMultiTouch = OSMultiTouch.getInstance();
		public function TUIOLayer(_stage:Stage)
		{
			graphics.beginFill(0x000000,0.1);
			graphics.drawRect(0,0,_stage.stageWidth,_stage.stageHeight);
			graphics.endFill();
			
//			this.addEventListener(MouseEvent.CLICK, onClick);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			multiTouch.enableGesture(this,new ZoomGesture(),onZoomGesture);
//			multiTouch.enableGesture(this,new DirectionGesture(),onDirectionGesture);
		}
		private function onDirectionGesture(evt:DirectionEvent):void{
			evt.direction
		}
		private function onZoomGesture(evt:ZoomEvent):void{
			var event:TableViewEvent = new TableViewEvent(TableViewEvent.ITEMDIDZOOM);
			event.deltaScale = evt.deltaScale;
			dispatchEvent(event);
		}
		private function onDown(evt:MouseEvent):void{
			isTapped = true;
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			this.addEventListener(MouseEvent.MOUSE_UP, onUp);
			lastX = evt.localX;
			lastY = evt.localY;
			distributeEvent(TableViewEvent.MASKTOUCHDOWN,lastX,lastY);
		}
		private function onMove(evt:MouseEvent):void{
			isTapped = false;
			distributeEvent(TableViewEvent.MASKTOUCHMOVE,evt.localX - lastX,evt.localY - lastY);
			lastX = evt.localX;
			lastY = evt.localY;
		}
		private function onUp(evt:MouseEvent):void{
			this.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			this.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			if(isTapped){
				isTapped = false;
				distributeEvent(TableViewEvent.MASKDIDTAPPED,evt.localX,evt.localY);
			}else{
				distributeEvent(TableViewEvent.MASKTOUCHUP,evt.localX,evt.localY);
			}
		}
		private function onClick(evt:MouseEvent):void{
			distributeEvent(TableViewEvent.MASKDIDTAPPED,evt.localX,evt.localY);
		}
		private function distributeEvent(type:String,x1:int,y1:int):void{
			var event:TableViewEvent = new TableViewEvent(type);
			event.offsetX = x1;
			event.offsetY = y1;
			dispatchEvent(event);
		}
	}
}