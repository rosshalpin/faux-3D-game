package  {
	
	import flash.display.MovieClip;
	
	public class treeObj extends MovieClip {
		
		public function treeObj(posx: int, posy: int): void {
			x = posx;
			y = posy;
			this.cacheAsBitmap = true;
		}
	}
}
