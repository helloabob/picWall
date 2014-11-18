package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	
	public class ImageLoader extends EventDispatcher
	{
		private var currentIndex:int = 1;
		private var loader:Loader = new Loader();
		
		/*small model image item height*/
		private var imageHeight:int = 120;
		
		/*big model image item height*/
		private var bigImageHeight:int = 240;
		
		public function ImageLoader(target:IEventDispatcher=null)
		{
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, oncomp);
		}
		public function startJob():void{
			currentIndex = 1;
			loadItem();
		}
		private function loadItem():void{
			loader.load(new URLRequest(Constants.getSmallImageName(currentIndex.toString())));
		}
		private function oncomp(evt:Event):void{
			/*resize the image*/
			var portion:Number = loader.content.width/loader.content.height;
			
			imageHeight = 240;
			
			/*---big image item area---*/
			loader.content.height = imageHeight - 10;
			loader.content.width = (imageHeight-10) * portion;
			loader.x = 5;
			loader.y = 5;
			
			/*add loader and draw black border*/
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0x000000,1);
			sp.graphics.drawRect(0,0,loader.content.width+10,imageHeight);
			sp.graphics.endFill();
			sp.addChild(loader);
			
			/*copy image data into bitmap array*/
			var bmd:BitmapData = new BitmapData(sp.width,sp.height);
			bmd.draw(sp);
			Constants.memoryBigData[currentIndex.toString()] = bmd;
			/*---end---*/
			
			imageHeight = 120;
			
			/*---small image item area---*/
			loader.content.height = imageHeight - 10;
			loader.content.width = (imageHeight-10) * portion;
			loader.x = 5;
			loader.y = 5;
			
			/*add loader and draw black border*/
			sp = new Sprite();
			sp.graphics.beginFill(0x000000,1);
			sp.graphics.drawRect(0,0,loader.content.width+10,imageHeight);
			sp.graphics.endFill();
			sp.addChild(loader);
			
			/*copy image data into bitmap array*/
			bmd = new BitmapData(sp.width,sp.height);
			bmd.draw(sp);
			Constants.memoryData[currentIndex.toString()] = bmd;
			/*---end---*/
			
			/*load next item*/
			currentIndex++;
			if(currentIndex<=Constants.imageLists.length){
				loadItem();
			}else{
				var event:TableViewEvent = new TableViewEvent(TableViewEvent.IMAGEDATALOADED);
				dispatchEvent(event);
			}
		}
		
	}
}