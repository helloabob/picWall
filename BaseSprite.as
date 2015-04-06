package
{
	import flash.display.Sprite;
	
	public class BaseSprite extends Sprite
	{
		public function BaseSprite()
		{
			super();
		}
		public function removeFromSuperView():void{
			this.parent.removeChild(this);
		}
	}
}