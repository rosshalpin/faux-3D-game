package  {
	
	import flash.display.MovieClip;
	
	public class Enemy extends MovieClip {
		
		public function Enemy(posx: int, posy: int): void {
			x = posx;
			y = posy;
			this.cacheAsBitmap = true;
		}
	}
}
