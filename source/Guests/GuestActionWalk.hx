package ;

/**
 * ...
 * @author 
 */
class GuestActionWalk extends GuestAction
{
	public var targetRoom : String = "";
	private var tr: Room = null;
	private var tx : Float = 0;
	private var walkRight : Bool = true;
	private var _walkingTime :Float = 0;
	
	public override function IsFinished() : Bool
	{
		return (_age >= _walkingTime);
	}
	
	public override function DoFinish() : Void 
	{
		trace("DoFinish Walk Action: " + targetRoom + " " + _walkingTime);
		_guest.velocity.x = 0;
	}
	
	public function new(g:Guest) 
	{
		super(g);
		name = "walk";
	}
	
	public override function Activate()
	{
		super.Activate();
		trace("activate Walk Action: " + targetRoom);
		tr = _guest._state.getRoomByName(targetRoom);
		if (tr != null)
		{
			if (tr.Level == _guest.Level )
			{
				trace("on same level");
				tx = tr.getXPos();
				walkRight =  (tx - _guest.x > 0);
				_walkingTime = Math.abs(tx - _guest.x) / getMovementSpeed();
			}
			else
			{
				trace("on different levels: " + tr.Level + " " + _guest.Level);
				
				var nw1 : GuestActionElevator = new GuestActionElevator(_guest);
				nw1.TargetLevel = tr.Level;
				_guest.AddActionToBegin(nw1);
				
				
				var nw2 : GuestActionWalk = new GuestActionWalk(_guest);
				nw2.targetRoom = "elevator_" + Std.string(_guest.Level);
				nw2._age = 0;
				nw2.Activate();
				trace("ele target: " + nw2.targetRoom);
				_guest.AddActionToBegin(nw2);
			}
		}
		else
		{
			trace("no room with name " + targetRoom + " found!");
		}
	}
	
	public override function update(elapsed:Float) 
	{
		super.update(elapsed);
		
		if (walkRight)
			_guest.velocity.x = getMovementSpeed();
		else
			_guest.velocity.x = -getMovementSpeed();
	}
	
	private function getMovementSpeed () : Float
	{
		return GP.GuestMovementSpeed * _guest.movefactor;
	}
	
}