package {

	import flash.display.*;
	import flash.geom.Point;
	import flash.events.*;
	import flash.text.TextField;
	import flash.utils.*;
	import flash.ui.Mouse;
	import flash.system.System;

	import flash.net.FileReference;
    import com.adobe.PNGEncoder;
	import flash.utils.ByteArray;
	import flash.display.BitmapData;

	public class main extends MovieClip {

		public var island: gameObj;

		public var plyr: Player;
		public var plyrPoint: LPoint;

		public var cursor1: cursor;

		public var debug: TextField = new TextField();
		public var memory: TextField = new TextField();
		public var btns: TextField = new TextField();
		public var ptext: TextField = new TextField();

		public var tree: treeObj;
		public var treePoint: LPoint;
		public var treeObjs: Array = new Array();
		public var treeObjs2: Array = new Array();
		public var treePoints: Array = new Array();

		public var textFields: Array = new Array();

		public var npc: Enemy;
		public var npcPoint: NPoint;
		public var npcObjs: Array = new Array();
		public var npcPoints: Array = new Array();

		public var radius: int = 100;
		public var t: int = 350; //possible points for trees
		public var radius2: int = 50;
		public var n: int = 5;

		public var point1: Point;

		public var forward, backward, left, right: Boolean = false;

		public var speed1: Number = 0.4;
		public var speed2: Number = 0.5;

		public var ts: int = 0;
		public var circle: Sprite = new Sprite();
		var click: Boolean = false;

		var water, shallow, sand, land = false;

		public function main() {

			stage.color = 0x00CC99;
			stage.quality = "LOW";
			stage.addEventListener(KeyboardEvent.KEY_DOWN, on_key_down);
			stage.addEventListener(KeyboardEvent.KEY_UP, on_key_up);
			stage.addEventListener(Event.ENTER_FRAME, on_enter_frame);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mousedown);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseup);

			debug.width = 200;
			debug.x = 10;
			debug.y = 1;
			debug.textColor = 0xFFFFFF;
			debug.selectable = false;
			addChild(debug);

			btns.width = 200;
			btns.x = 10;
			btns.y = 26;
			btns.textColor = 0xFFFFFF;
			btns.selectable = false;
			addChild(btns);

			memory.width = 77;
			memory.x = 10;
			memory.y = 13;
			memory.textColor = 0xFFFFFF;
			memory.selectable = false;
			addChild(memory);


			island = new gameObj(275, 200, 200, 450);
			plyr = new Player(275, 200);
			plyrPoint = new LPoint(0, 0);

			cursor1 = new cursor(mouseX, mouseY);
			Mouse.show();
			Mouse.hide();

			addChild(island);
			island.isl.addChild(plyrPoint);

			setInterval(draw, 1)
			function draw() {
				var globalPt: Point = new Point(mouseX-15, mouseY-15);
				var localPt: Point = island.isl.land.globalToLocal(globalPt);
				if (click == true) {
					circle.graphics.beginFill(0x4FD3B3);

					if (water == true) {
						circle.graphics.beginFill(0x00CC99);
					} else if (shallow == true) {
						circle.graphics.beginFill(0x4FD3B3);
					} else if (sand == true) {
						circle.graphics.beginFill(0xFFFB89);
					} else if (land == true) {
						circle.graphics.beginFill(0x83CE4E);
					}
					circle.graphics.drawRect(localPt.x, localPt.y, 4, 4);
					circle.graphics.endFill();
				}
			}

			island.isl.land.addChild(circle);

			for (var i: int = 0; i < t; i++) {
				var rand1 = Math.random() * 2 * radius - radius;
				var ylim = Math.sqrt(radius * radius - rand1 * rand1);
				var rand2 = Math.random() * 2 * ylim - ylim;
				treePoint = new LPoint(rand1, rand2);
				treePoints.push(treePoint);
			}
			for (var fg: int = 0; fg < t; fg++) {
				island.isl.addChild(treePoints[fg]);
			}
			for (var ih: int = 0; ih < t; ih++) {
				tree = new treeObj(0, 0);
				treeObjs.push(tree);
			}
			for (var ik: int = 0; ik < t; ik++) {
				treeObjs2[ik] = treeObjs[ik];
			}

			//npc
			for (var ab: int = 0; ab < n; ab++) {
				var r1 = Math.random() * 2 * radius2 - radius2;
				var ym = Math.sqrt(radius2 * radius2 - r1 * r1);
				var r2 = Math.random() * 2 * ym - ym;
				npcPoint = new NPoint(r1, r2);
				npcPoints.push(npcPoint);
			}
			for (var ac: int = 0; ac < n; ac++) {
				island.isl.addChild(npcPoints[ac]);
			}
			for (var ad: int = 0; ad < n; ad++) {
				npc = new Enemy(0, 0);
				npcObjs.push(npc);
			}

			for (var af: int = 0; af < n; af++) {
				treeObjs.push(npcObjs[af]);
			}
			//npc
			treeObjs.push(plyr);

			setInterval(zorder, 100);
			function zorder() {
				treeObjs.sortOn("y", Array.NUMERIC);
				for (var zz: int = 0; zz < t + n + 1; zz++) {
					if (contains(treeObjs[zz])) {
						removeChild(treeObjs[zz]);
					}
					if (treeObjs[zz].y != 300) {
						addChild(treeObjs[zz]);
					}
				}
				if (contains(ptext)) {
					removeChild(ptext);
				}
				if (contains(cursor1)) {
					removeChild(cursor1);
				}
				addChild(ptext);
				addChild(cursor1);
			}

			for (var il: int = 0; il < t; il++) {
				var globalPointA: Point = treePoints[il].localToGlobal(new Point());
				var LocalPointA: Point = stage.globalToLocal(globalPointA);
				var color = getColorSample(LocalPointA.x, LocalPointA.y + 1)
				if (color != 415) {
					treePoints[il].y = 300;
					if (contains(treePoints[il])) {
						island.isl.removeChild(treePoints[il]);
					}
					ts++;
				}
			}

		}

		public function Control() {

			for (var i: int = 0; i < t; i++) {
				var globalPoint: Point = treePoints[i].localToGlobal(new Point());
				var LocalPoint: Point = stage.globalToLocal(globalPoint);
				treeObjs2[i].x = LocalPoint.x;
				treeObjs2[i].y = LocalPoint.y;
			}

			var globalPoint2: Point = plyrPoint.localToGlobal(new Point());
			var LocalPoint2: Point = stage.globalToLocal(globalPoint2);
			plyr.x = LocalPoint2.x;
			plyr.y = LocalPoint2.y;

			for (var it: int = 0; it < n; it++) {
				var globalPoint3: Point = npcPoints[it].localToGlobal(new Point());
				var LocalPoint3: Point = stage.globalToLocal(globalPoint3);
				npcObjs[it].x = LocalPoint3.x;
				npcObjs[it].y = LocalPoint3.y;
			}
		}

		public function on_enter_frame(e: Event): void {
			//circle.rotation = island.isl.rotation;

			var rot = island.isl.rotation * (Math.PI / 180);

			if (forward) { //w
				plyrPoint.y -= -(speed1 * Math.sin(rot - 1.5708));
				plyrPoint.x += -(speed1 * Math.cos(rot - 1.5708));
			}
			if (backward) { //s
				plyrPoint.y += -(speed1 * Math.sin(rot - 1.5708));
				plyrPoint.x -= -(speed1 * Math.cos(rot - 1.5708));
			}
			if (left) { //a
				plyrPoint.y -= -(speed2 * Math.sin(rot));
				plyrPoint.x += -(speed2 * Math.cos(rot));
			}
			if (right) { //d
				plyrPoint.y += -(speed2 * Math.sin(rot));
				plyrPoint.x -= -(speed2 * Math.cos(rot));
			}

			cursor1.x = mouseX;
			cursor1.y = mouseY;
			
			Control();
			collis(plyrPoint, plyr);
			var mem: int = System.totalMemory;
			memory.text = String("memory: " + mem * 0.000001);

			for (var gh: int = 0; gh < n; gh++) {
				if (getColorSample(npcObjs[gh].x, npcObjs[gh].y + 2) == 469) {
					npcObjs[gh].gotoAndStop(2);
				} else {
					npcObjs[gh].gotoAndStop(1);
				}

			}

		}
		public var pp = new Point(0, 0);
		var col: String = "";

		function collis(plyP: LPoint, plr: Player) {
			var cp = new Point(plyP.x, plyP.y);
			var ix: int = plyP.x;
			var iy: int = plyP.y;
			if (getColorSample(plr.x, plr.y + 2) == 357) {
				plyP.x = pp.x;
				plyP.y = pp.y;
				col = " COLLISION";
			} else {
				col = "";
				pp = cp;
			}
			if (getColorSample(plr.x, plr.y + 2) == 469 || getColorSample(plr.x, plr.y + 2) == 357) {
				plyr.gotoAndPlay(2);
			} else {
				plyr.gotoAndPlay(1);
			}
			var trees: Number = t - ts;
			debug.text = String("x: " + Math.ceil(plyrPoint.x) + " yz: " + Math.ceil(plyrPoint.y) + " " + trees + " " + col);

		}

		var prevX: int = 0;
		var curX: int = 0;

		function mouseRotation(e: MouseEvent) {
			prevX = curX;
			curX = stage.mouseX;
			if (prevX > curX) {
				island.isl.rotation += 2;
			} else if (prevX < curX) {
				island.isl.rotation -= 2;
			}
		}

		function mousedown(e: MouseEvent) {
			cursor1.gotoAndPlay(1);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseRotation);
			stage.addEventListener(MouseEvent.MOUSE_UP, endRotation);
		}

		function mouseup(e: MouseEvent) {
			cursor1.gotoAndPlay(0);
		}

		function endRotation(e: MouseEvent) {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseRotation);
		}

		public function on_key_down(e: KeyboardEvent): void {
			if (e.keyCode == 82) {
				for (var il: int = 0; il < t; il++) {
					var globalPointA: Point = treePoints[il].localToGlobal(new Point());
					var LocalPointA: Point = stage.globalToLocal(globalPointA);
					var color = getColorSample(LocalPointA.x, LocalPointA.y + 1)
					if (color == 469  || color == 357) {
						treePoints[il].y = 300;
						if (contains(treePoints[il])) {
							island.isl.removeChild(treePoints[il]);
						}
					}
				}
			}
			//controls
			if (e.keyCode == 87) { //w
				forward = true;
			}
			if (e.keyCode == 83) { //s
				backward = true;
			}
			if (e.keyCode == 65) { //a
				left = true;
			}
			if (e.keyCode == 68) { //d
				right = true;
			}

			if (e.keyCode == 32) { //click
				click = true;
				//island.isl.land.addChild(circle);
			}

			//colors
			if (e.keyCode == 49) {
				water = true;
				shallow = false;
				sand = false;
				land = false;
			}
			if (e.keyCode == 50) {
				shallow = true;
				water = false;
				sand = false;
				land = false;
			}
			if (e.keyCode == 51) {
				sand = true;
				water = false;
				shallow = false;
				land = false;
			}
			if (e.keyCode == 52) {
				land = true;
				water = false;
				shallow = false;
				sand = false;
			}


		}

		public function on_key_up(e: KeyboardEvent): void {
			//controls
			if (e.keyCode == 87) { //w
				forward = false;
			}
			if (e.keyCode == 83) { //s
				backward = false;
			}
			if (e.keyCode == 65) { //a
				left = false;
			}
			if (e.keyCode == 68) { //d
				right = false;
			}
			if (e.keyCode == 32) { //click
				click = false;
				savebmp();
				circle.graphics.clear();
				
			}
		}

		public function getRand(max: int, min: int) {
			return (Math.floor(Math.random() * (max - (min) + 1)) + (min));
		}

		private var _islandBitmap: BitmapData;

		function savebmp(){
			if (_islandBitmap == null) {
				_islandBitmap = new BitmapData(200,150);
			}
			_islandBitmap.draw(island.isl.land);

			//var byteArray: ByteArray = PNGEncoder.encode(_islandBitmap);
			var bitmap: Bitmap = new Bitmap(_islandBitmap);
			

			//var fileReference: FileReference = new FileReference();
			//fileReference.save(byteArray, "img.png");
			
			//island.isl.land.addChild(bitmap);
			if(contains(bitmap)){
				island.isl.land.removeChild(bitmap);
			}
			island.isl.land.addChildAt(bitmap, island.isl.land.numChildren-1);
		}

		private var _stageBitmap: BitmapData;

		function getColorSample(posx: Number, posy: Number) {
			if (_stageBitmap == null) {
				_stageBitmap = new BitmapData(550, 400);
			}
			_stageBitmap.draw(stage);
			var rgb: int = _stageBitmap.getPixel(posx, posy);
			var red: int = (rgb >> 16 & 0xff);
			var green: int = (rgb >> 8 & 0xff);
			var blue: int = (rgb & 0xff);
			//trace(red + "," + green + "," + blue);
			return red + green + blue;
		}

	}

}
			