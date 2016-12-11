package;

using MathExtender;
/**
 * ...
 * @author 
 */
class GP
{

	public static var RoomSizeInPixel   (default, null) : Int = 48;
	static public var WorldSizeXInPixel (default, null) : Float = 1600;
	static public var GuestSizeInPixel (default, null) : Int = 32;
	static public var GroundLevel (default, null) : Float = 528;
	
	static public var GuestMovementSpeed (default, null) : Float = 20;
	static public var GuestElevatorTimePerLevel (default, null) : Float = 3;
	static public var ReceptionWaitingTime (default, null) : Float  = 5;
	
	
	static public var MoneyRoomCost (default, null) : Int = 300;
	static public var MoneyTipAmount (default, null) : Int = 600;
	static public var MoneyElevatorBaseCost (default, null) : Int = 300;
	
	static public function CalcSatisfactionInRoom (g : Guest, r: Room) : Float
	{
		var baseLevel : Float = 0.25;
		var dirtLevel : Float = 0.5;
		var noiseLevel : Float = 0.25;
		var noiseInRoom : Float = r.Props.NoiseFactor;
		noiseInRoom.Clamp();
		var ret : Float = baseLevel + dirtLevel * (1.0 - r.DirtLevel) + noiseLevel * (1.0 - r.Props.NoiseFactor);
		return ret;
	}
	
}