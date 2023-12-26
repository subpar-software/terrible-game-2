# Plan for 1.0.0

## Compatibility

- Can it work in Safari?
  - No, add something about it to the readme
- How about builds for Windows, MacOS, Linux, and Android?

## User Interface

- Improve Health and Surge Icons
  - Pop-in animation
  - Stack after accumulating some number
  - Animate icons moving to correct bar on surge start
- Pop up help tips
  - Surge reminders

### Add Pause

- Issue: when paused, the rings keeps going
- Processes are paused, but the ring enemy doesn't have a physics's process, just an impulse on
    ready
- Implement pause after enemies are re-worked

### Add Options Menu

- Doesn't matter if web only
- Deal with touch area interference
- Disable music and/or sounds
- Key bindings
  - How to save them? [Maybe this](https://docs.godotengine.org/en/stable/classes/class_configfile.html)

## Phases

- Wax and wain of game play, to create moments of high stress and breaks
  - Beginning of phase is low stress
  - End of phase is high stress
- Some way to indicate when a phase is coming to an end
- Reward for making it to the next phase (pac-man like story progress?)
- Define phases with json or some other plain text object
- Debug mode jump to phase for testing

## Story?

- If there is a story it should be bad but cute
- Story support for dialog and scripted events
  - define in some kind of plain text

## Enemies

- Rings change to triangles
  - add collisions sound
- Enemy managers (started)
- Squares
  - impulse to point adjacent to clock
  - after random amount of time, impulse to clock center
- Some other enemy
  - Fly around, shooting towards clock
  - Bullets can be deflected but not shot, except while surging
  - Set number of enemies, they keep coming until they're hit 3 times
  - Visual indicator for how many times hit
- Main bad guy, wisp

## Allies

- Change rings to allies

## Achievements

- Per game or session?
- Collect things done during play
  - total time
  - time surging
  - enemies spawned
  - enemies killed
  - shots fired
  - shots that hit an enemy
  - minute and hour hand clockwise rotations
  - counter clockwise rotations
  - when were keys hit and how long held down
- Use the data collected to come up with silly achievements
  - This can be its own document
- Use data collected to come up with some kind of metric to determine how well the player did
  overall
