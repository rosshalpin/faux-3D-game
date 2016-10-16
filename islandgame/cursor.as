package  {
	
	import flash.display.MovieClip;
	
	public class cursor extends MovieClip {
		
		public function cursor(posx: int, posy: int): void {
			x = posx;
			y = posy;
			this.cacheAsBitmap = true;
		}
	}
}
