package;

import openfl.display.Sprite;

/**
 * ...
 * @author Greg
 */

class Fence extends Sprite
{

	public function new(ls:Int) 
	{
		super();
		this.graphics.beginFill(0xffffff);
		this.graphics.drawRect(0, 0, 20, ls);
		this.graphics.endFill();
	}
	
}