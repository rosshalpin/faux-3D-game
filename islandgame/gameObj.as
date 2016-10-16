package  {
	
	import flash.display.MovieClip;
	
	public class gameObj extends MovieClip {
		
		public function gameObj(posx: int, posy: int, hval: int, wval: int): void {
			x = posx;
			y = posy;
			height = hval;
			width = wval;
		}
	}
}
