﻿package{	import com.greensock.TweenLite;		import flash.display.Bitmap;	import flash.display.Loader;	import flash.display.Sprite;	import flash.display.Stage;	import flash.display.StageDisplayState;	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.events.TimerEvent;	import flash.geom.Point;	import flash.geom.Rectangle;	import flash.system.fscommand;	import flash.utils.Timer;
		public class TableViewController extends EventDispatcher	{			//public properties		private var _view:Sprite;		private var _rows:int;		private var _cols:int;		private var _stage:Stage;		private var _lists:Array;				//private properties		private var rowHeight:Number;		private var colCount:int;		private var currentIndex:int=1;		private var offsetXs:Array=[];		private var contentViews:Array;		private var contentView:Sprite;		private var visibleViewIndex:int;				private var is_first_play:Boolean;		private var offset_x:int;		//		private var _motionViewArray:Array;//		private var _currentMotionViewIndex:int;		private var _viewMotion:Sprite;		private var _timer:Timer;		private var _imageHeight:int;		private var _imageWidth:int;		private var _imageCountPerMotionView:int;		private var _imageCountInMotionView:int;		private var _lastMotionViewOffsetX:int;				private var fixedSize:int = 1280;		private var motionViewWidth:int = 2560;		private var backHeight:int = 720;				/*count for load screen image*/		private var loadCount:int = 0;				private var isRunning:Boolean = false;				/*0:小图 1:大图 2:中图*///		private var playMode:int = 0;				private var currentImageId:int = 0;				public function TableViewController()		{			_rows = 3;			_view = new Sprite();			//			_motionViewArray=[new Sprite(),new Sprite()];//			_view.addChild(_motionViewArray[0]);//			_view.addChild(_motionViewArray[1]);			_viewMotion = new Sprite();			_view.addChild(_viewMotion);		}				public function get cols():int
		{
			return _cols;
		}		public function set cols(value:int):void
		{
			_cols = value;
		}		private function getMousePoint(sp:Sprite,offsetPoint:Point):Point{			var point:Point = sp.localToGlobal(new Point(sp.x,sp.y));			return new Point(offsetPoint.x-point.x,offsetPoint.y-point.y);		}				public function moveImage(offsetX:int, offsetY:int):void{					}				public function getSpriteAtPoint(offsetX:int,offsetY:int):MyBitmap{			var imageItem:MyBitmap = findCorrectImageItem(offsetX,offsetY);			if(imageItem!=null){				return imageItem;			}			return null;		}				public function showImageWithAnimation(offsetX:int, offsetY:int):void{			var imageItem:MyBitmap = findCorrectImageItem(offsetX,offsetY);			if(imageItem!=null){				var event:TableViewEvent = new TableViewEvent(TableViewEvent.ITEMWILLSHOW);				currentImageId = int(imageItem.id);				event.item = {"imageId":imageItem.id};				dispatchEvent(event);			}		}				public function stepImageIndex(direction:int):void{			if(direction>0){				/*show next image*/				if(currentImageId<=_lists.length-1)currentImageId++;				else currentImageId=1;			}else{				/*show previous image*/				if(currentImageId==1)currentImageId=_lists.length;				else currentImageId--;			}			var event:TableViewEvent = new TableViewEvent(TableViewEvent.ITEMWILLSHOW);			event.item = {"imageId":currentImageId.toString()};			dispatchEvent(event);		}				private function findCorrectImageItem(offsetX:int, offsetY:int):MyBitmap {			var flag:Boolean = false;			var point:Point=new Point();			for(var i:int=0;i<_viewMotion.numChildren;i++){				var sp:MyBitmap = _viewMotion.getChildAt(i) as MyBitmap;				point.x = offsetX-_viewMotion.x-sp.x;				point.y = offsetY-_viewMotion.y-sp.y;				if(point.x <= sp.width && point.y <= sp.height && point.x >= 0 && point.y >= 0){					flag = true;					return sp as MyBitmap;				}			}			return null;		}				private function findCorrectImageIte(offsetX:int, offsetY:int):ImageItem {			var flag:Boolean = false;			var point:Point=new Point();			for(var i:int=0;i<_viewMotion.numChildren;i++){				var sp:Sprite = _viewMotion.getChildAt(i) as Sprite;				point.x = offsetX-_viewMotion.x-sp.x;				point.y = offsetY-_viewMotion.y-sp.y;				if(point.x <= sp.width && point.y <= sp.height && point.x >= 0 && point.y >= 0){					flag = true;					return sp as ImageItem;				}			}			return null;		}		//		private function drawBackColor(contain:Sprite,color:uint):void{//			contain.graphics.beginFill(color,1);//			contain.graphics.drawRect(0,0,motionViewWidth,_stage.stageHeight);//			contain.graphics.endFill();//		}				public function start():void{			is_first_play = true;			motionViewWidth = _stage.stageWidth;			for(var i:int=0;i<_rows;i++){				offsetXs[i] = 0;			}						/*load image into memory*/			var il:ImageLoader = new ImageLoader();			il.startJob();			il.addEventListener(TableViewEvent.IMAGEDATALOADED, onImageDataLoaded);								}				private function findShortestRowIndex():int{			var tmp:int = 0;			var res:int = offsetXs[tmp];			for(var i:int=0;i<_rows;i++){				if(offsetXs[i]<res){					res = offsetXs[i];					tmp = i;				}			}			return tmp;		}				private function getMemoryImageData(index:String):*{			return Constants.memoryDataArray[Constants.runMode][index];//			if(playMode==0)return Constants.memoryData[index];//			else return Constants.memoryBigData[index];		}		private function getImageItemHeight():int{			return Constants.imageHeightArray[Constants.runMode];//			if(playMode==0)return Constants.smallImageHeight;//			else return Constants.bigImageHeight;		}				private function loadBitmapItem():void{			while(shouldContinueLoad()){								var bm:MyBitmap = new MyBitmap(getMemoryImageData(currentIndex.toString()));				var rowIndex:int = findShortestRowIndex();				bm.y = (rowIndex)%_rows*getImageItemHeight();				bm.x = offsetXs[(rowIndex)%_rows];				bm.id = currentIndex.toString();				offsetXs[(rowIndex)%_rows] += bm.width;				_viewMotion.addChild(bm);								/*image index plus and reset 0 when beyond size*/				if(currentIndex<=_lists.length-1)currentIndex++;				else currentIndex=1;			}//			trace(offsetXs[0]+":"+offsetXs[2]);		}						private function shouldContinueLoad():Boolean{			var length:int;			if(loadCount==1)length = motionViewWidth*2;			else length = motionViewWidth*(loadCount+1);			var flag:Boolean = false;			for(var i:int=0;i<_rows;i++){				if(offsetXs[i]<=length){					flag = true;					break;				}			}			return flag;		}				private function onImageDataLoaded(evt:Event):void{			/*All image data has been loaded into memory*/			loadCount = 1;			loadBitmapItem();			onItemComplete();		}				private function calculateImageCountPerMotionView(offsetX:int=0):void{//			var diff:int = motionViewWidth - offsetX;//			var result:int = diff / _imageSize;//			if(result*_imageSize!=diff)result++;//			_imageCountPerMotionView = result * _rows;//			_imageCountInMotionView = 0;//			_lastMotionViewOffsetX = result * _imageSize - diff;			_imageCountPerMotionView = _rows * _cols * 2;			_imageCountInMotionView = 0;			_lastMotionViewOffsetX = 0;		}				private function onMove(evt:TimerEvent):void{//			_timer.stop();			if(_viewMotion.x==-motionViewWidth*loadCount){				cleanViewAndLoadNewView();			}			_viewMotion.x-=Constants.pixelPerTime;		}				private function getMaxX(index:int):int{			var bm:MyBitmap = _viewMotion.getChildAt(index) as MyBitmap;			return bm.x + bm.width + _viewMotion.x;		}				private function cleanViewAndLoadNewView():void{			/*clean useless image item*/			var i:int=0;			while(getMaxX(i)<0){				_viewMotion.removeChildAt(i);				i++;			}						/*load new image item*/			loadCount++;			loadBitmapItem();		}				public function switchModel():void{			/*turn off*/			isRunning = false;			Constants.runMode++;			if(Constants.runMode==Constants.totalRowsArray.length)Constants.runMode = 0;//			playMode=(playMode==0?1:0);						/*remove all image items*/			while(_viewMotion.numChildren > 0){				_viewMotion.removeChildAt(0);			}						/*reset rows*/			for(var i:int=0;i<_rows;i++){				offsetXs[i] = 0;			}			_rows = Constants.totalRowsArray[Constants.runMode];//			if(playMode==0)_rows=Constants.totalRowsForNormal;//			else _rows = Constants.totalRowsForLarge;						/*restart*/			_viewMotion.x = 0;			loadCount = 1;			loadBitmapItem();			onItemComplete();		}				private function moveMotionViewToNail():void{//			_view.swapChildren(_motionViewArray[0],_motionViewArray[1]);//			_motionViewArray[_currentMotionViewIndex==0?1:0].removeChildren();//			_motionViewArray[_currentMotionViewIndex==0?1:0].x = getMaxSpriteX(_motionViewArray[_currentMotionViewIndex]);//			_currentMotionViewIndex = _currentMotionViewIndex==0?1:0;			calculateImageCountPerMotionView(_lastMotionViewOffsetX);			loadItem();		}				private function loadImageView(containIndex:int,count:int):void{					}				private function getMaxSpriteX(contain:Sprite):int{			return contain.x + motionViewWidth;		}				private function getBounds(contain:Sprite):Rectangle{			return new Rectangle(0,0,contain.width,contain.height);		}				private function itemDidAppear(evt:TableViewEvent):void{			var temp:ImageItem = evt.target as ImageItem;//			trace("item"+temp.id+" did appear");			temp.removeEventListener(TableViewEvent.ITEMDIDAPPEAR,itemDidAppear);			_imageCountInMotionView++;			if(currentIndex<_lists.length-1)currentIndex++;			else currentIndex=0;			if(_imageCountInMotionView==_imageCountPerMotionView){				onItemComplete();				return;			}			loadItem();		}				private function onEnterFrame(evt:Event):void{			if(isRunning)this.onMove(null);		}		private function onItemComplete():void{			if(!_stage.hasEventListener(Event.ENTER_FRAME)){				_stage.addEventListener(Event.ENTER_FRAME,onEnterFrame);			}			isRunning = true;//			if(_timer==null){//				is_first_play=false;//				_timer = new Timer(50);//				_timer.addEventListener(TimerEvent.TIMER, onMove);//				_timer.start();//			}		}//				private function loadItem():void{			var item:ImageItem = new ImageItem();			item.contentHeight = _imageHeight;			item.contentWidth = _imageWidth;			item.y = (_imageCountInMotionView%_rows)*_imageHeight;			item.x = int(_imageCountInMotionView/_rows)*_imageWidth + (is_first_play?0:_lastMotionViewOffsetX);			item.addEventListener(TableViewEvent.ITEMDIDAPPEAR,itemDidAppear);			item.id = (currentIndex+1).toString();			item.imageName = (currentIndex+1).toString();//			_motionViewArray[_currentMotionViewIndex].addChild(item);		}				public function get lists():Array		{			return _lists;		}		public function set lists(value:Array):void		{			_lists = value;		}		public function get stage():Stage		{			return _stage;		}		public function set stage(value:Stage):void		{			_stage = value;		}		public function get view():Sprite		{			return _view;		}		public function set view(value:Sprite):void		{			_view = value;		}		public function get rows():int		{			return _rows;		}		public function set rows(value:int):void		{			_rows = value;		}	}}