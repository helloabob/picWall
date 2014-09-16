﻿package{	import flash.display.Sprite;	import flash.display.Stage;	import flash.events.EventDispatcher;	import flash.utils.setInterval;
		public class TableViewController extends EventDispatcher	{			//public properties		private var _view:Sprite;		private var _rows:int;		private var _stage:Stage;		private var _lists:Array;				//private properties		private var rowHeight:Number;		private var colCount:int;		private var currentIndex:int=0;		private var offsetXs:Array=[];		private var contentViews:Array;		private var contentView:Sprite;		private var visibleViewIndex:int;				private var is_first_play:Boolean;		private var offset_x:int;				public function TableViewController()		{			_rows = 3;			_view = new Sprite();						contentView = new Sprite();			_view.addChild(contentView);						contentViews=[new Sprite(), new Sprite()];			contentView.addChild(contentViews[0]);			contentView.addChild(contentViews[1]);			visibleViewIndex = 0;						contentViews[1].graphics.beginFill(0xff0000,1);			contentViews[1].graphics.drawRect(0,0,200,200);			contentViews[1].graphics.endFill();		}				private function itemDidAppear(evt:TableViewEvent):void{			offsetXs[currentIndex%rows]+=evt.itemWidth;			var temp:ImageItem = evt.target as ImageItem;			temp.removeEventListener(TableViewEvent.ITEMDIDAPPEAR,itemDidAppear);			if(currentIndex%(_rows*colCount)==0 && currentIndex>0){				if(is_first_play==false){					onItemComplete();					return;				}else{					visibleViewIndex = 1;					offset_x = _stage.stageWidth;					is_first_play=false;				}			}						currentIndex++;			loadItem();		}				private function onTimer():void{			contentView.x-=1;		}				private function onItemComplete():void{			flash.utils.setInterval(onTimer,50);		}				private function loadItem():void{			trace("x:"+offsetXs[currentIndex%rows]+"   y:"+ (currentIndex%rows)*rowHeight);			var item:ImageItem = new ImageItem();			item.height = rowHeight;			item.y = (currentIndex%rows)*rowHeight;			item.x = offsetXs[currentIndex%rows]-offset_x;			item.addEventListener(TableViewEvent.ITEMDIDAPPEAR,itemDidAppear);			item.imageName = (currentIndex+1).toString();			contentViews[visibleViewIndex].addChild(item.view);		}				public function start():void{			rowHeight = _stage.stageHeight / _rows;			colCount = _stage.stageWidth / rowHeight;			if(colCount*rowHeight<=_stage.stageWidth)colCount++;			is_first_play=true;			contentViews[1].x=_stage.stageWidth;			contentView.swapChildren(contentViews[0],contentViews[1]);			for(var i:int=0;i<_rows;i++)offsetXs[i]=0;			loadItem();		}		public function get lists():Array		{			return _lists;		}		public function set lists(value:Array):void		{			_lists = value;		}		public function get stage():Stage		{			return _stage;		}		public function set stage(value:Stage):void		{			_stage = value;		}		public function get view():Sprite		{			return _view;		}		public function set view(value:Sprite):void		{			_view = value;		}		public function get rows():int		{			return _rows;		}		public function set rows(value:int):void		{			_rows = value;		}	}}