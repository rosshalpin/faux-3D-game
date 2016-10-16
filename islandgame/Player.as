package  {
	
	import flash.display.MovieClip;
	
	public class Player extends MovieClip {
		
		public function Player(posx: int, posy: int): void {
			x = posx;
			y = posy;
			this.cacheAsBitmap = true;
		}
	}
}
