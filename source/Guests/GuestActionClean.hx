package;
import flixel.FlxG;
import flixel.system.FlxSound;

/**
 * ...
 * @author 
 */
class GuestActionClean extends GuestAction
{
	
	private var cleaningTime : Float = 0;

	private var gotStuff : Bool = false;
	public var target : String = "";
	
	private var _cleanSound : FlxSound;
	
	public function new(g:Guest) 
	{
		super(g);
		this.name = "clean";
		
		_cleanSound = new FlxSound();
		_cleanSound = FlxG.sound.load(AssetPaths.hor_clean__ogg);
	}
	
	
	public override function IsFinished () : Bool
	{
		if (!activated) return false;
		return (_age >= cleaningTime);
	}
	
	public override function DoFinish() : Void 
	{
		//trace("Finish Clean Action");
		var r : Room = _guest._state.getRoomByName(_guest._roomName);
		if (r != null)
		{
			r.DirtLevel *= 0.35;
			_guest._state.JobList.finishJob(r.name);
		}
		_guest.alpha = 1;
		_cleanSound.play();
	}
	
	public override function Activate()
	{
		super.Activate();
		//trace("Activate Clean Action");
		
		if (!gotStuff)
		{
			gotStuff = true;
			var serviceRoomName : String = "service_" + Std.string(_guest.Level);
			var sr : Room = _guest._state.getRoomByName(serviceRoomName);
			if (sr == null)
			{
				// backup plan: If there is no service room on the level of the janitor, get any cleaning room
				sr = _guest._state.getAnyServiceRoom();
			}
			
			if (sr != null)
			{
				var w2 : GuestActionWalk = new GuestActionWalk(_guest);
				w2.targetRoom = _guest._roomName;
				_guest.AddActionToBegin(w2);
				
				var w1 : GuestActionWalk = new GuestActionWalk(_guest);
				w1.targetRoom = sr.name;
				_guest.AddActionToBegin(w1);
				w1.Activate();
			}
			else
			{
				activated = false;
				gotStuff = false;
			}			
		}
		cleaningTime = GP.WorkerCleaningTime;
		
	}
	
	public override function update(elapsed:Float) 
	{
		super.update(elapsed);
		_guest.alpha = 0.5;
	}
	
}