/*Written by Maxwell Perlman*/
import Cocoa

enum Jobs: String, Printable
{
    case Adventurer = "Adventurer";
    case Warrior = "Warrior";
    case Mage = "Mage";
    case Ranger = "Ranger";
    var description : String{
        get
        {
            return self.toRaw();
        }
    }
}

class Player
{
    /*Traits of characters*/
    var ID:String;
    var level:Int;
    var job:Jobs;
    var health:Int;
    var strength:Int;
    var magic:Int;
    var speed:Int;
    var evasion:Int;
    var statPoints:Int;
    
    init()
    {
        self.ID = "your name here";
        self.level = 0;
        self.job = Jobs.Adventurer;
        self.health = 0;
        self.strength = 0;
        self.magic = 0;
        self.speed = 0;
        self.evasion = 0;
        self.statPoints = 0;
        self.setBaseValues();
    }
    
    func levelUp() -> Void
    {
        self.level = self.level + 1;
        self.statPoints += 5;
        println("Character leveled up: prompt for stat assignment...");
        println("5 stat points assigned to \(self.getID())\n");
    }
    
    func setJob() -> Void
    {
        self.job = Jobs.Adventurer;
        self.setBaseValues();
    }
    
    func setJob(newJob:Jobs) -> Void
    {
        self.job = newJob;
        self.setBaseValues();
    }
    
    func setBaseValues() -> Void
    {
        switch self.job
        {
            case Jobs.Adventurer:
                setTraitsAdventurer();
            case Jobs.Warrior:
                setTraitsWarrior();
            case Jobs.Mage:
                setTraitsMage();
            case Jobs.Ranger:
                setTraitsRanger();
            default:
                setTraitsAdventurer();
        }
    }
    
    func setTraitsAdventurer() -> Void
    {
        self.health = 5;
        self.strength = 5;
        self.magic = 5;
        self.speed = 5;
        self.evasion = 5;
    }
    func setTraitsWarrior() -> Void
    {
        self.health = 10;
        self.strength = 10;
        self.magic = 0;
        self.speed = 2;
        self.evasion = 3;
    }
    func setTraitsMage() -> Void
    {
        self.health = 5;
        self.strength = 0;
        self.magic = 10;
        self.speed = 5;
        self.evasion = 5;
    }
    func setTraitsRanger() -> Void
    {
        self.health = 5;
        self.strength = 5;
        self.magic = 0;
        self.speed = 10;
        self.evasion = 5;
    }
    
    func getBaseValues() -> String
    {
        return "Level: \(self.level) \nHealth: \(self.health) \nStrength: \(self.strength) \nMagic: \(self.magic) \nSpeed: \(self.speed)";
    }
    
    func getID() -> String
    {
        return self.ID;
    }
    
    func getLevel() -> Int
    {
        return self.level;
    }
    
    func getJob() -> Jobs
    {
        return self.job;
    }
    
    func getHealth() -> Int
    {
        return self.health;
    }
    
    func getStrength() -> Int
    {
        return self.strength;
    }
    
    func getMagic() -> Int
    {
        return self.magic;
    }
    
    func getSpeed() -> Int
    {
        return self.speed;
    }
    
    func getEvasion() -> Int
    {
        return self.evasion;
    }
    
    func getStatPoints() -> Int
    {
        return self.statPoints;
    }
    
    func printAll() -> Void
    {
        println("ID:        \(self.ID)");
        switch self.getJob()
        {
            case Jobs.Adventurer:
                println("Job:       Adventurer");
            case Jobs.Warrior:
                println("Job        Warrior");
            case Jobs.Mage:
                println("Job:       Mage");
            case Jobs.Ranger:
                println("Job:       Ranger");
            default:
                println("Job:       Unasigned");
        }
        println("Level:     \(self.getLevel())");
        println("Health:    \(self.getHealth())");
        println("Strength:  \(self.getStrength())");
        println("Magic:     \(self.getMagic())");
        println("Speed:     \(self.getSpeed())");
        println("Evasion:   \(self.getEvasion())");
        println("StatPoints:\(self.getStatPoints())");
        println("\n");
    }
}

println("Create new character...");
var max = Player();
max.printAll();
var newJob = Jobs.Warrior;
println("Assign job \(newJob)...");
max.setJob(newJob);
max.printAll();
max.getBaseValues();
println("Level up character...");
max.levelUp();
max.getBaseValues();
max.printAll();




