package
{
	import flash.display.Sprite;
	import flash.utils.setTimeout;

	public class FractalTree extends Sprite
	{
		private var colLeaf:uint = 0x009933;
		private const MAXSTEPS:Number = 5;
		private const angleLeft:Number = Math.PI/180*20;
		private const angleRight:Number = Math.PI/180*50;
		private const lengthMult:Number = 0.7;

		public function FractalTree(angle:Number, x:Number, y:Number, length:Number, count:Number = 0)
		{
			drawPiece(angle, x, y, length, count);
		}

		// from http://wonderfl.net/c/mP27
		private function drawPiece(angle:Number, x:Number, y:Number, length:Number, count:Number):void
		{
			if (count < MAXSTEPS)
			{
				var newLength:Number = length * lengthMult;
				var newX:Number = x - Math.cos(angle) * length;
				var newY:Number = y - Math.sin(angle) * length;
				
				graphics.lineStyle(0, colLeaf);
				graphics.moveTo(x, y);
				graphics.lineTo(newX, newY);
				
				setTimeout(function():void {
					drawPiece(angle + angleRight, newX, newY, newLength, count + 1);
					drawPiece(angle - angleLeft, newX, newY, newLength, count + 1);
				}, 200);
			}
		}
	}
}