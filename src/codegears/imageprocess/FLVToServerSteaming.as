package codegears.imageprocess 
{
	/**
	 * ...
	 * @author Theprit
	 */
	
	import flash.media.Camera;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	
	import classes.Recorder;
	
	import flash.utils.Timer;
	import flash.display.BitmapData;
	import flash.events.StatusEvent;
	
	public class FLVToServerSteaming 
	{
		// Network
		protected var nc:NetConnection;
		protected var ns:NetStream;
		protected var nsOutGoing:NetStream;
		protected var recordingTimer:Timer = new Timer( 1000 , 0 );
		[Bindable] public var myRecorder:Recorder;
		
		protected var camera:Camera;
		
		public function FLVToServerSteaming(_camera:Camera) 
		{
			camera = _camera;
			
			// Init Network ----------------------------------------------------------------
			myRecorder = new Recorder();
			nc = new NetConnection();
			nc.client = this;
			nc.addEventListener(NetStatusEvent.NET_STATUS,netStatusHandler);
		}
		
		public function Connect():void {
			if (nc != null) 
			{
				nc.connect(myRecorder.server);
			}
		}
		
		public function Disconnect():void {
			if (nsOutGoing != null) 
			{
				nsOutGoing.close();
			}
		}
		
		//**********************************************************************************************************
		private function netStatusHandler(event:NetStatusEvent):void {
			switch (event.info.code) {
			case "NetConnection.Connect.Failed":
				//Alert.show("ERROR:Could not connect to: " + myRecorder.server);
				//_txtNetwork.text = "ERROR:Could not connect to: " + myRecorder.server;
				
			break;	
			case "NetConnection.Connect.Success":
				prepareStreams();
				//_txtNetwork.text = "Success:Connect to: " + myRecorder.server;
			break;
			default:
				nc.close();
				//_txtNetwork.text = "CLOSE:Default: "+ event.info.code + myRecorder.server;
				break;
			}
		}
		
		//**********************************************************************************************************
		private  function prepareStreams():void {
			nsOutGoing = new NetStream(nc); 
			trace("init Netstream");
			if (camera!=null) {
				
				nsOutGoing.attachCamera(camera);
				myRecorder.cameraDetected = true;
				camera.addEventListener(StatusEvent.STATUS, cameraStatus); 
				
				nsOutGoing.publish(myRecorder.fileName + new Date().time , "record");
				myRecorder.hasRecorded = true;
			}	
			
			//nsInGoing= new NetStream(nc);
			//nsInGoing.client=this;    
								
		}  
		
		//**********************************************************************************************************
		private function cameraStatus(evt:StatusEvent):void {
			switch (evt.code) {
			case "Camera.Muted":
				myRecorder.cameraDetected=false;
				break;
			case "Camera.Unmuted":
				myRecorder.cameraDetected=true;
			break;
			}
		}
		
		//**********************************************************************************************************
		
	}

}