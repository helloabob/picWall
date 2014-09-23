﻿package{	import flash.display.Sprite;	import flash.display.Stage;	import flash.events.EventDispatcher;	import flash.events.TimerEvent;	import flash.geom.Point;	import flash.geom.Rectangle;	import flash.utils.Timer;
		public class TableViewController extends EventDispatcher	{			//public properties		private var _view:Sprite;		private var _rows:int;		private var _cols:int;		private var _stage:Stage;		private var _lists:Array;				//private properties		private var rowHeight:Number;		private var colCount:int;		private var currentIndex:int=0;		private var offsetXs:Array=[];		private var contentViews:Array;		private var contentView:Sprite;		private var visibleViewIndex:int;				private var is_first_play:Boolean;		private var offset_x:int;				private var _motionViewArray:Array;		private var _currentMotionViewIndex:int;		private var _timer:Timer;		private var _pixelPerTime:int = 5;		private var _imageHeight:int;		private var _imageWidth:int;		private var _imageCountPerMotionView:int;		private var _imageCountInMotionView:int;		private var _lastMotionViewOffsetX:int;				private var fixedSize:int = 1280;		private var motionViewWidth:int = 2560;		private var backHeight:int = 720;				public function TableViewController()		{			_rows = 3;			_view = new Sprite();						_motionViewArray=[new Sprite(),new Sprite()];			_view.addChild(_motionViewArray[0]);			_view.addChild(_motionViewArray[1]);		}				public function get cols():int
		{
			return _cols;
		}		public function set cols(value:int):void
		{
			_cols = value;
		}		private function getMousePoint(sp:Sprite,offsetPoint:Point):Point{			var point:Point = sp.localToGlobal(new Point(sp.x,sp.y));			return new Point(offsetPoint.x-point.x,offsetPoint.y-point.y);		}				public function showImageWithAnimation(offsetX:int, offsetY:int):void{			var flag:Boolean = false;			var point:Point=new Point();			var spContainer:Sprite;			for(var i:int=0;i<(_motionViewArray[_currentMotionViewIndex] as Sprite).numChildren;i++){				var sp:Sprite = (_motionViewArray[_currentMotionViewIndex] as Sprite).getChildAt(i) as Sprite;				spContainer = _motionViewArray[_currentMotionViewIndex] as Sprite;				point.x = offsetX-spContainer.x-sp.x;				point.y = offsetY-spContainer.y-sp.y;				if(point.x <= sp.width && point.y <= sp.height && point.x >= 0 && point.y >= 0){					flag = true;					showBigImageItem((sp as ImageItem).fileName);					break;				}			}			if(flag==false){				var viewIndex:int = _currentMotionViewIndex==0?1:0;				for(i=0;i<(_motionViewArray[viewIndex] as Sprite).numChildren;i++){					sp = (_motionViewArray[viewIndex] as Sprite).getChildAt(i) as Sprite;					spContainer = _motionViewArray[viewIndex] as Sprite;					point.x = offsetX-spContainer.x-sp.x;					point.y = offsetY-spContainer.y-sp.y;					if(point.x <= sp.width && point.y <= sp.height && point.x >= 0 && point.y >= 0){						flag = true;						showBigImageItem((sp as ImageItem).fileName);						break;					}				}			}		}				private function showBigImageItem(fileName:String):void{			BigImageItem.instance.showImage(fileName,_stage);		}				private function drawBackColor(contain:Sprite,color:uint):void{			contain.graphics.beginFill(color,1);			contain.graphics.drawRect(0,0,motionViewWidth,_stage.stageHeight);			contain.graphics.endFill();		}				public function start():void{			motionViewWidth = _stage.stageWidth * 2;//			drawBackColor(_motionViewArray[0],0xff0000);//			drawBackColor(_motionViewArray[1],0x00ff00);			drawBackColor(_motionViewArray[0],0x000000);			drawBackColor(_motionViewArray[1],0x000000);			_imageHeight = _stage.stageHeight / _rows;			_imageWidth = _stage.stageWidth / _cols;			_motionViewArray[1].x = motionViewWidth;//			for(var i:int=0;i<_rows;i++)offsetXs[i]=0;			is_first_play = true;			calculateImageCountPerMotionView();			loadItem();		}				private function calculateImageCountPerMotionView(offsetX:int=0):void{//			var diff:int = motionViewWidth - offsetX;//			var result:int = diff / _imageSize;//			if(result*_imageSize!=diff)result++;//			_imageCountPerMotionView = result * _rows;//			_imageCountInMotionView = 0;//			_lastMotionViewOffsetX = result * _imageSize - diff;			_imageCountPerMotionView = _rows * _cols * 2;			_imageCountInMotionView = 0;			_lastMotionViewOffsetX = 0;		}				private function onMove(evt:TimerEvent):void{//			_timer.stop();			if(_motionViewArray[_currentMotionViewIndex].x==-motionViewWidth/4){				moveMotionViewToNail();			}			_motionViewArray[0].x-=_pixelPerTime;			_motionViewArray[1].x-=_pixelPerTime;		}				private function moveMotionViewToNail():void{			_view.swapChildren(_motionViewArray[0],_motionViewArray[1]);			_motionViewArray[_currentMotionViewIndex==0?1:0].removeChildren();			_motionViewArray[_currentMotionViewIndex==0?1:0].x = getMaxSpriteX(_motionViewArray[_currentMotionViewIndex]);			_currentMotionViewIndex = _currentMotionViewIndex==0?1:0;			calculateImageCountPerMotionView(_lastMotionViewOffsetX);			loadItem();		}				private function loadImageView(containIndex:int,count:int):void{					}				private function getMaxSpriteX(contain:Sprite):int{			return contain.x + motionViewWidth;		}				private function getBounds(contain:Sprite):Rectangle{			return new Rectangle(0,0,contain.width,contain.height);		}				private function itemDidAppear(evt:TableViewEvent):void{			var temp:ImageItem = evt.target as ImageItem;			temp.removeEventListener(TableViewEvent.ITEMDIDAPPEAR,itemDidAppear);			_imageCountInMotionView++;			if(currentIndex<_lists.length-1)currentIndex++;			else currentIndex=0;			if(_imageCountInMotionView==_imageCountPerMotionView){				onItemComplete();				return;			}			loadItem();		}		private function onItemComplete():void{			if(_timer==null){				is_first_play=false;				_timer = new Timer(50);				_timer.addEventListener(TimerEvent.TIMER, onMove);				_timer.start();			}		}//				private function loadItem():void{			var item:ImageItem = new ImageItem();			item.contentHeight = _imageHeight;			item.contentWidth = _imageWidth;			item.y = (_imageCountInMotionView%_rows)*_imageHeight;			item.x = int(_imageCountInMotionView/_rows)*_imageWidth + (is_first_play?0:_lastMotionViewOffsetX);			item.addEventListener(TableViewEvent.ITEMDIDAPPEAR,itemDidAppear);			item.id = (currentIndex+1).toString();			item.imageName = (currentIndex+1).toString();			_motionViewArray[_currentMotionViewIndex].addChild(item);		}				public function get lists():Array		{			return _lists;		}		public function set lists(value:Array):void		{			_lists = value;		}		public function get stage():Stage		{			return _stage;		}		public function set stage(value:Stage):void		{			_stage = value;		}		public function get view():Sprite		{			return _view;		}		public function set view(value:Sprite):void		{			_view = value;		}		public function get rows():int		{			return _rows;		}		public function set rows(value:int):void		{			_rows = value;		}	}}