package
{
	import flash.events.Event;
	
	public class TableViewEvent extends Event
	{
		
		public static var IMAGEDATALOADED:String = "IMAGEDATALOADED";
		
		public static var VIEWDIDAPPEAR:String = "VIEWDIDAPPEAR";
		public static var CELLFORRENDER:String = "CELLFORRENDER";
		public static var ITEMDIDAPPEAR:String = "ITEMDIDAPPEAR";
		public static var MASKDIDTAPPED:String = "MASKDIDTAPPED";
		public static var MASKTOUCHDOWN:String = "MASKTOUCHDOWN";
		public static var MASKTOUCHMOVE:String = "MASKTOUCHMOVE";
		public static var MASKTOUCHUP:String   = "MASKTOUCHUP";
		public static var ITEMWILLSHOW:String  = "ITEMWILLSHOW";
		
		public static var ITEMDIDZOOM:String   = "ITEMDIDZOOM";
		
		public static var ITEMDIDSHOW:String   = "ITEMDIDSHOW";
		public static var ITEMDIDHIDE:String   = "ITEMDIDHIDE";
		
		public var rowIndex:int;
		public var colIndex:int;
		public var itemWidth:int;
		
		public var item:Object;
		
		public var offsetX:int;
		public var offsetY:int;
		
		public var deltaScale:Number;
		public var deltaX:Number;
		public var deltaY:Number;
		
		public function TableViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}