package
{
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.KinectSettings;
	import com.as3nui.nativeExtensions.air.kinect.constants.CameraResolution;
	import com.as3nui.nativeExtensions.air.kinect.data.SkeletonJoint;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	import com.as3nui.nativeExtensions.air.kinect.events.CameraImageEvent;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	public class Bonsignage extends Sprite
	{
		private var kinect:Kinect;
		private var bmp:Bitmap;
		private var skeletonContainer:Sprite;
		private var colWood:uint = 0x999933;
		private var timer:Timer;
		private var nodeA:Point; // 左足
		private var nodeB:Point; // 首
		private var nodeC:Point; // 左肘
		private var nodeD:Point; // 右肘
		private var nodeE:Point; // 左手
		private var nodeF:Point; // 右手
		private var nodeScale:Number = 0.3; // 葉の大きさ		
		private var nodeList:Array = [];
		
		public function Bonsignage()
		{
			if(Kinect.isSupported()) {
				bmp = new Bitmap();
				addChild(bmp);
				
				skeletonContainer = new Sprite();
				addChild(skeletonContainer);
				
				kinect = Kinect.getDevice();
				
				kinect.addEventListener(CameraImageEvent.DEPTH_IMAGE_UPDATE, depthImageHandler);
				
				var settings:KinectSettings = new KinectSettings();
				settings.rgbEnabled = true;
				settings.rgbResolution = CameraResolution.RESOLUTION_640_480;
				settings.depthEnabled = true;
				settings.depthResolution = CameraResolution.RESOLUTION_640_480;
				settings.depthShowUserColors = true;
				settings.skeletonEnabled = true;
				
				kinect.start(settings);
				
				addEventListener(Event.ENTER_FRAME, enterFrameHandler);
				
				timer = new Timer(10000, 99);
				timer.start();
				timer.addEventListener(TimerEvent.TIMER, startGrow);
			}
		}
		
		private function depthImageHandler(evt:CameraImageEvent):void {
			bmp.bitmapData = evt.imageData;
		}
		
		private function enterFrameHandler(evt:Event):void {
			skeletonContainer.graphics.clear();
			for each(var user:User in kinect.usersWithSkeleton) {
				nodeA = user.leftFoot.position.depth;
				nodeB = user.neck.position.depth;
				nodeC = user.leftElbow.position.depth;
				nodeD = user.rightElbow.position.depth;
				nodeE = user.leftHand.position.depth;
				nodeF = user.rightHand.position.depth;
				
				skeletonContainer.graphics.lineStyle(50, colWood);
				setCurve(user, "leftFoot", "leftHip", "neck");
				skeletonContainer.graphics.lineStyle(30, colWood);
				setLine(user, "neck", "leftElbow");
				setLine(user, "leftElbow", "leftHand");
				setLine(user, "neck", "rightElbow");
				setLine(user, "rightElbow", "rightHand");
			}
		}
		
		private function setLine(user:User, joint1:String, joint2:String):void {
			skeletonContainer.graphics.moveTo(user[joint1].position.depth.x, user[joint1].position.depth.y);
			skeletonContainer.graphics.lineTo(user[joint2].position.depth.x, user[joint2].position.depth.y);
		}

		private function setCurve(user:User, joint1:String, joint2:String, joint3:String):void {
			skeletonContainer.graphics.moveTo(user[joint1].position.depth.x, user[joint1].position.depth.y);
			skeletonContainer.graphics.curveTo(user[joint2].position.depth.x, user[joint2].position.depth.y, user[joint3].position.depth.x, user[joint3].position.depth.y);
		}

		private function drawFractalTree():void {
			var i:int;
			var len:int = 10;
			var angleLeft:Number = pointAngle(nodeB, nodeC);
			var angleRight:Number = pointAngle(nodeB, nodeD);
			var node:FractalTree;
			for(var i = 0; i < len; i++) {
				var angle:Number = pointAngle(nodeB, nodeC) - Math.PI/2;
				var p:Point = Point.interpolate(nodeB, nodeC, i/len);
				var rndRot:Number = Math.random()*Math.PI*2*0.5;
				var x:Number = p.x + (Math.random()-0.5)*10;
				var y:Number = p.y + (Math.random()-0.5)*10;
				node = new FractalTree(angle+rndRot, angleLeft, angleRight, x, y, nodeScale*nodeC.subtract(nodeB).length, 0);
				nodeList.push(node);
				addChild(node);
			}
			for(var i = 0; i < len; i++) {
				var angle:Number = pointAngle(nodeB, nodeD) - Math.PI/2;
				var p:Point = Point.interpolate(nodeB, nodeD, i/len);
				var rndRot:Number = Math.random()*Math.PI*2*0.5;
				var x:Number = p.x + (Math.random()-0.5)*10;
				var y:Number = p.y + (Math.random()-0.5)*10;
				node = new FractalTree(angle+rndRot, angleLeft, angleRight, x, y, nodeScale*nodeD.subtract(nodeB).length, 0);
				nodeList.push(node);
				addChild(node);
			}
			for(var i = 0; i < len; i++) {
				var angle:Number = pointAngle(nodeB, nodeC) - Math.PI/2;
				var p:Point = Point.interpolate(nodeC, nodeE, i/len);
				var rndRot:Number = Math.random()*Math.PI*2*0.5;
				var x:Number = p.x + (Math.random()-0.5)*10;
				var y:Number = p.y + (Math.random()-0.5)*10;
				node = new FractalTree(angle+rndRot, angleLeft, angleRight, x, y, nodeScale*nodeE.subtract(nodeC).length, 0);
				nodeList.push(node);
				addChild(node);
			}
			for(var i = 0; i < len; i++) {
				var angle:Number = pointAngle(nodeB, nodeC) - Math.PI/2;
				var p:Point = Point.interpolate(nodeD, nodeF, i/len);
				var rndRot:Number = Math.random()*Math.PI*2*0.5;
				var x:Number = p.x + (Math.random()-0.5)*10;
				var y:Number = p.y + (Math.random()-0.5)*10;
				node = new FractalTree(angle+rndRot, angleLeft, angleRight, x, y, nodeScale*nodeF.subtract(nodeD).length, 0);
				nodeList.push(node);
				addChild(node);
			}

			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);

			setTimeout(function() {
				addEventListener(Event.ENTER_FRAME, enterFrameHandler);
				for(i = 0; i < nodeList.length; i++) {
					removeChild(nodeList[i]);
				}
				nodeList = [];
			}, 3000);
		}
		
		private function startGrow(evt:TimerEvent):void {
			if(nodeA && nodeB && nodeC && nodeD && nodeE && nodeF) {
				drawFractalTree();
			} else {
				trace("not detected");
			}
		}
		
		private function pointAngle(p1:Point, p2:Point):Number {
			var v:Point = p2.subtract(p1);
			return Math.atan2(v.y, v.x);
		}
	}
}