package {
	import flash.display.*;
	import flash.geom.Point;
	import flash.events.*;
	import flash.text.TextField;
	import flash.utils.*;
	import flash.ui.Mouse;
	import flash.system.System;

	public class NPoint extends MovieClip {

		var fg = new Point(x, y);
		public function NPoint(posx: int, posy: int): void {
			x = posx;
			y = posy;
			addEventListener(Event.ENTER_FRAME,initAI);
		}

		public var state: int = getRand(5, 0);
		public var period: int = 1;
		public var lastTime: int = getTimer() * 0.001 - period;
		public var speed: Number = 0.25;

		public function initAI(e: Event){

			var n: int = getRand(5, 0);
			var thisTime = getTimer() * 0.001;
			if ((thisTime - lastTime) >= period) {
				lastTime = thisTime;
				state = n;
			}
			switch (state) {
				case 1: //forward
					y -= -(speed * Math.sin(-1.5708));
					x += -(speed * Math.cos(-1.5708));
					break;
				case 2: //backward
					y += -(speed * Math.sin(-1.5708));
					x -= -(speed * Math.cos(-1.5708));
					break;
				case 3: //left
					y -= -(speed * Math.sin(3.14159));
					x += -(speed * Math.cos(3.14159));
					break;
				case 4: //right
					y += -(speed * Math.sin(3.14159));
					x -= -(speed * Math.cos(3.14159));
					break;
				case 5: //still

					break;
			}
			collis();

		}
		
		public function getRand(max: int, min: int) {
			return (Math.floor(Math.random() * (max - (min) + 1)) + (min));
		}

		public var pp = new Point(0, 0);

		function collis() {
			
			var globalPoint: Point = this.localToGlobal(new Point());
			var LP: Point = stage.globalToLocal(globalPoint);

			var cp = new Point(x,y);
			var ix: int = LP.x;
			var iy: int = LP.y;
			if (getColorSample(LP.x, LP.y+1) ==357) {
				x = pp.x;
				y = pp.y;
			} else {
				pp = cp;
			}
		}

		private var _stageBitmap: BitmapData;

		function getColorSample(posx: Number, posy: Number) {
			if (_stageBitmap == null) {
				_stageBitmap = new BitmapData(550, 400);
			}
			_stageBitmap.draw(stage);
			var rgb: uint = _stageBitmap.getPixel(posx, posy);
			var red: int = (rgb >> 16 & 0xff);
			var green: int = (rgb >> 8 & 0xff);
			var blue: int = (rgb & 0xff);
			//trace(red + "," + green + "," + blue);
			return red + green + blue;
		}
	}

}