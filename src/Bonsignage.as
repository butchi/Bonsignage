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
	
	public class Bonsignage extends Sprite
	{
		private var kinect:Kinect;
		private var bmp:Bitmap;
		private var skeletonContainer:Sprite;
		private var colWood:uint = 0x999933;
		
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
			}
		}
		
		private function depthImageHandler(evt:CameraImageEvent):void {
			bmp.bitmapData = evt.imageData;
		}
		
		private function enterFrameHandler(evt:Event):void {
			skeletonContainer.graphics.clear();
			for each(var user:User in kinect.usersWithSkeleton) {
				skeletonContainer.graphics.lineStyle(50, colWood);
				setLine(user, "leftFoot", "leftHip");
				setLine(user, "leftHip", "neck");
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
	}
}