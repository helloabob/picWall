package
{
	import flash.events.Event;
	
	public class TableViewEvent extends Event
	{
		public static var VIEWDIDAPPEAR:String = "VIEWDIDAPPEAR";
		public static var CELLFORRENDER:String = "CELLFORRENDER";
		public static var ITEMDIDAPPEAR:String = "ITEMDIDAPPEAR";
		public static var MASKDIDTAPPED:String = "MASKDIDTAPPED";
		
		public var rowIndex:int;
		public var colIndex:int;
		public var itemWidth:int;
		
		public var tappedOffsetX:int;
		public var tappedOffsetY:int;
		
		public function TableViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}