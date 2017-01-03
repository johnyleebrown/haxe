package ;

import openfl.display.Sprite;

/**
 * ...
 * @author Greg
 */

class Ball extends Sprite
{

	public function new() 
	{
		super();
		this.graphics.beginFill(0x47E44C);// E8E234
		this.graphics.drawCircle(0, 0, 10);
		this.graphics.endFill();
	}
	
}