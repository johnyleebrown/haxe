package ;

//import js.html.Location;
import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import openfl.events.KeyboardEvent;
import openfl.events.TextEvent;
import openfl.geom.Point;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * ...
 * @author Greg
 */

enum GameState {
	Paused;
	Playing;
}

enum Player {
	Player1;
	Player2;
}

class Main extends Sprite
{
	var inited:Bool;
	private var fence:Fence;
	private var a:Int = 0;
	//lattice_stride + lattice_hole_ratio < 500
	private var lattice_stride:Int = 70;
	private var	lattice_hole_ratio:Int = 70;
	private var div:Int;
	private var flag:Bool;
	private var flag0:Bool;
	private var fblock:Bool;
	private var fdone:Bool = false;
	private var sum:Int;
	private var lan:Int;
	private var lat_array:Array<Sprite> = new Array<Sprite>();
	private var lattice_velocity:Int;
	private var imp:Int;
	private var platform1:Platform;
	private var platform2:Platform;
	private var ball:Ball;
	private var score1:Int;
	private var score2:Int;
	private var scoreField:TextField;
	private var messageField:TextField;
	private var currentGameState:GameState;
	private var arrowKeyUp:Bool;
	private var arrowKeyDown:Bool;
	private var arrowKeyW:Bool;
	private var arrowKeyS:Bool;
	private var platformSpeed:Int;
	private var ballMovement:Point;
	private var ballSpeed:Int;

	function resize(e)
	{
		if (!inited) init();
	}

	function init()
	{
		if (inited) return;
		inited = true;

		sum = lattice_stride+lattice_hole_ratio; checkSum();
		div = (Math.floor(500 / (sum)));
		lan = 500 - (div * sum);

		if (div * sum == 500){
			div += 1;
			flag0 = true;
		}
		else{
			div += 2;
		}

		while (lattice_hole_ratio>39 && div>0){
			fence = new Fence(lattice_stride);
			fence.x = 240;
			if (flag0){
				fence.y = a-sum;
			}
			else{
				fence.y = a-2*sum;
			}

			this.addChild(fence);
			lat_array.push(fence);
			a += sum;
			div -= 1;
		}

		ball = new Ball();
		ball.x = 29;
		ball.y = 250;
		this.addChild(ball);

		platform1 = new Platform();
		platform1.x = 5;
		platform1.y = 200;
		this.addChild(platform1);

		platform2 = new Platform();
		platform2.x = 480;
		platform2.y = 200;
		this.addChild(platform2);

		var scoreFormat:TextFormat = new TextFormat("Verdana", 40, 0xbbbbbb, true);
		scoreFormat.align = TextFormatAlign.CENTER;

		scoreField = new TextField();
		addChild(scoreField);
		scoreField.width = 500;
		scoreField.y = 30;
		scoreField.defaultTextFormat = scoreFormat;
		scoreField.selectable = false;

		var messageFormat:TextFormat = new TextFormat("Verdana", 16, 0xbbbbbb, true);
		messageFormat.align = TextFormatAlign.CENTER;

		messageField = new TextField();
		addChild(messageField);
		messageField.width = 500;
		messageField.y = 450;
		messageField.defaultTextFormat = messageFormat;
		messageField.selectable = false;
		messageField.text = "Press ESC to start / SPACE to restart\nUse W/S and ARROW KEYS to move the platform";

		score1 = 0;
		score2 = 0;
		arrowKeyUp = false;
		arrowKeyDown = false;
		arrowKeyW = false;
		arrowKeyS = false;
		lattice_velocity = 2;
		platformSpeed = 6;
		ballSpeed = 4;
		ballMovement = new Point(0, 0);
		setGameState(Paused);

		stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);

		this.addEventListener(Event.ENTER_FRAME, everyFrame);
	}

	private function setGameState(state:GameState):Void {
		currentGameState = state;
		updateScore();
		if (state == Paused) {
			messageField.alpha = 1;
		}else {
			messageField.alpha = 0;
			platform1.y = 200;
			platform2.y = 200;
			ball.x = 29;
			ball.y = 250;
			var direction:Int = (Math.random() > .5)?(1):( -1);
			var randomAngle:Float = (Math.random() * Math.PI / 2) - 45;
			ballMovement.x = direction * Math.cos(randomAngle) * ballSpeed;
			ballMovement.y = Math.sin(randomAngle) * ballSpeed;
		}
	}

	private function keyDown(event:KeyboardEvent):Void {
		if (currentGameState == Paused && event.keyCode == 27) { // Esc
			setGameState(Playing);
		}else if (event.keyCode == 38) { // Up
			arrowKeyUp = true;
		}else if (event.keyCode == 40) { // Down
			arrowKeyDown = true;
		}else if (event.keyCode == 87) { // W
			arrowKeyW = true;
		}else if (event.keyCode == 83) { // S
			arrowKeyS = true;
		}else if (event.keyCode == 32) { // Space
			resGame();
		}
	}

	private function keyUp(event:KeyboardEvent):Void {
		if (event.keyCode == 38) { // Up
			arrowKeyUp = false;
		}else if (event.keyCode == 40) { // Down
			arrowKeyDown = false;
		}else if (event.keyCode == 87) { // W
			arrowKeyW = false;
		}else if (event.keyCode == 83) { // S
			arrowKeyS = false;
		}
	}

	private function everyFrame(event:Event):Void {
		if (currentGameState == Playing){

			//
			for (i in 0...lat_array.length){
				lat_array[i].y += lattice_velocity;
				if (lat_array[i].y > 495) {
					(flag0)?(lat_array[i].y = -sum):(lat_array[i].y = -(2*sum - lan));//-(Std.int(fence.height));
				}
			}

			//right platform
			if (arrowKeyUp) {
				platform2.y -= platformSpeed;
			}
			if (arrowKeyDown) {
				platform2.y += platformSpeed;
			}
			if (platform2.y < 5) platform2.y = 5;
			if (platform2.y > 395) platform2.y = 395;

			//left platform
			if (arrowKeyW) {
				platform1.y -= platformSpeed;
			}
			if (arrowKeyS) {
				platform1.y += platformSpeed;
			}
			if (platform1.y < 5) platform1.y = 5;
			if (platform1.y > 395) platform1.y = 395;

			// ball movement
			ball.x += ballMovement.x;
			ball.y += ballMovement.y;


			//bounce off the lattice Y
			if(!flag){
				if (ballMovement.x < 0 && ball.x < 270){
					for (i in 0...lat_array.length){

						if (ball.y >= lat_array[i].y && ball.y <= lat_array[i].y + (Std.int(fence.height))) {
							/*
							if (fblock){
								ballMovement.y *= -1;
								ball.y = lat_array[i].y + (Std.int(fence.height)) +1;
								fblock = false;
								fdone = true;
								continue;
							}
							else if (fdone){
								continue;
							}
							else{*/
								bounceBall();
								flag = true;
								ball.x = 270;
								continue;
							//}

						}
						//else if (ball.y > lat_array[i].y + (Std.int(fence.height))){
						//		fblock = true;
						//}
					}
				}
			}

			//bounce off the lattice Y
			if(!flag){
				if (ballMovement.x > 0 && ball.x > 230){
					for (i in 0...lat_array.length){

						if (ball.y >= lat_array[i].y && ball.y <= lat_array[i].y + (Std.int(fence.height))) {
							/*
							if (fblock){
								ballMovement.y *= -1;
								ball.y = lat_array[i].y + (Std.int(fence.height)) +1;
								fblock = false;
								fdone = true;
								continue;
							}
							else if (fdone){
								continue;
							}
							else{
							*/
								bounceBall();
								flag = true;
								ball.x = 230;
								continue;
							//}
						}
						//else if (ball.y > lat_array[i].y + (Std.int(fence.height))){
						//		fblock = true;
						//}
					}
				}
			}

			// ball platform bounce
			if (ballMovement.x < 0 && ball.x < 30 && ball.y >= platform1.y && ball.y <= platform1.y + 100 ) {
				bounceBall();
				flag = false;
				ball.x = 30;
			}
			if (ballMovement.x > 0 && ball.x > 470 && ball.y >= platform2.y && ball.y <= platform2.y + 100 ) {
				bounceBall();
				flag = false;
				ball.x = 470;
			}

			// ball edge bounce
			if (ball.y < 5 || ball.y > 495) ballMovement.y *= -1;

			// ball goal
			if (ball.x < 5) winGame(Player2);
			if (ball.x > 495) winGame(Player1);
		}
	}

	private function bounceBall():Void {
		var direction:Int = (ballMovement.x > 0)?( -1):(1);
		var randomAngle:Float = (Math.random() * Math.PI / 2) - 45;
		ballMovement.x = direction * Math.cos(randomAngle) * ballSpeed;
		ballMovement.y = Math.sin(randomAngle) * ballSpeed;
	}

	private function winGame(player:Player):Void {
		if (player == Player1) {
			score1++;
		} else {
			score2++;
		}
		setGameState(Paused);
	}



	public function resGame():Void{
		//Location.reload(true);
		//Lib.current.stage.location.reload(false);
		platform1.x = 5;
		platform1.y = 200;
		platform2.x = 480;
		platform2.y = 200;
		ball.x = 29;
		ball.y = 250;
		score1 = 0;
		score2 = 0;
		arrowKeyUp = false;
		arrowKeyDown = false;
		arrowKeyW = false;
		arrowKeyS = false;
		ballMovement = new Point(0, 0);
		setGameState(Paused);
	}

	private function checkSum():Void{
		if (sum > 500){
			var z:Float = sum - 500;z /= 2;
			lattice_stride -= Std.int(z); lattice_hole_ratio -= Std.int(z);
			sum = lattice_stride+lattice_hole_ratio;
		}
	}

	private function updateScore():Void {
		scoreField.text = score1 + "  " + score2;
	}

	public function new()
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e)
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		haxe.Timer.delay(init, 100);
		init();
	}

	public static function main()
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
		//
	}
}
