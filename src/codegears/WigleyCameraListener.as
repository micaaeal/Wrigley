package codegears 
{
	
	/**
	 * ...
	 * @author Chet Chetchaiyan
	 */
	public interface WigleyCameraListener {
		function onStart():void;
		function onBoxDetect():void;
		function onMouthMove():void;
		function onMouthStop():void;
	}
	
}