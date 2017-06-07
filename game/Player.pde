/*************
 * Player
 * Vroom Vroom
 ************/

import java.util.LinkedList;

public class Player extends GameObjectPhysics {
  
    private boolean disabled = false; // whether we are in control of acceleration

    private float sideFriction = 0.2; // Friction on side
    private float frontFriction = 0.04; // Friction on front of car

    private float frontPower = 0.19f; // acceleration power (gas pedal)
    private float turnAngle = 40; // degrees
    private float rotatePower = 0.024f;//0.016f; // how fast we rotate
    private float breakPower = 0.06f;

    private float maxSpeed = 10f;
    private boolean inControl = true; // Whether car is in "control" (otherwise it's in "initial D drift" mode)

    private LinkedList<Person> ppl; // Holds the people
    // There's yo stack ^^^^^^^^^
    private float funEffect = 0.0f; // fun *Slide in* effect for grabbing people
    private float funEffectHeight = 0.0f;// height of people (falling)
    private float funEffectHeightVel = 0.0f;
    private float funEffectBump = 0.0f;

    private ParticleSystem tireParticles;

    public Player(float x, float y) {
        super(x, y, resources.SPR_CAR);
        collideWithOthers = true;
        collisionBox = new Rectangle(-8, -8, 16, 16);
        image_xscale = -1;
        image_xoffset = 16;
        image_yoffset = 8;

        ppl = new LinkedList<Person>();

        tireParticles = new ParticleSystem();
        tireParticles.emissionRate = 1.0f;
        tireParticles.decayRate = 1000f;
        tireParticles.particleTexture = resources.SPR_TIRES;
        tireParticles.particleXoffset = image_xoffset;
        tireParticles.particleYoffset = image_yoffset;
        tireParticles.particleDrawOrder = drawOrder - 1;
    }

    // Drops off all people on top of list with same color
    public void dropOff ( PERSON_COLOR col ) {
        int found = 0;

        ListIterator<Person> iter = ppl.listIterator();
        while( iter.hasNext() ) {
            Person person = iter.next();
            // If not same color, stop.
            if (person.col != col) break;

            person.dropOff();
            iter.remove();
            found++;
        }

        // reset timer if we have at least one person
        if (found != 0) {
            handler.gamestate.setTime(15);
            if (found == 1) {
              handler.gamestate.addScore(200, found);
            }
            if (found == 2) {
              handler.gamestate.addScore(500, found);
            }
            if (found == 3) {
              handler.gamestate.addScore(1000, found);
            }
            if (found == 4) {
              handler.gamestate.addScore(3000, found);
            }
        }
    }
     public boolean isfull () {
       return ppl.size() > 3;
     }
    @Override
    public void update() {
        super.update();
        tireParticles.active = !inControl;
        tireParticles.x = x;
        tireParticles.y = y;
        tireParticles.particleAngle = image_angle;
        tireParticles.update();
        

        double velMagnitude = Math.sqrt( velX * velX + velY * velY );
        // clamp to max speed
        velMagnitude = (velMagnitude > maxSpeed) ? maxSpeed : velMagnitude;

        // Follow player
        camera.xPos += 0.3 * ( (x - camera.viewWidth / 2) - camera.xPos ) ;
        camera.yPos += 0.3 * ( (y - camera.viewHeight / 2) - camera.yPos);

        // breaking
        if (Input.keyPress( (int)' ' )) {
            velMagnitude -= breakPower;
            if (velMagnitude < 0) velMagnitude = 0;
        }


        // SIDE AND FRONT FRICTION
        double velAngle = Math.atan2(velY, velX);
        double dAngle = MathUtil.getAngleDifference(image_angle, velAngle);//(velAngle - image_angle);
        //System.out.println( (image_angle* (180.0/Math.PI)) + " - " + (velAngle* (180.0/Math.PI)) + " == " + (dAngle * (180.0/Math.PI)));
        double sideComponent = velMagnitude * Math.sin(dAngle);
        double frontComponent = velMagnitude * Math.cos(dAngle);
        if (Math.abs(sideComponent) < sideFriction) {
            sideComponent = 0;
        } else {
            if (inControl)
              sideComponent -= Math.signum(sideComponent) * sideFriction;
            else
              sideComponent -= Math.signum(sideComponent) * frontFriction;
        }
        if (Math.abs(frontComponent) < frontFriction) {
            frontComponent = 0;
        } else {
            //if (inControl)
                frontComponent -= Math.signum(frontComponent) * frontFriction;
        }

        // Are we in control?
        double threshold = 35.0;
        if (Input.keyPress( (int) ' ')) 
            threshold = 5.0;

        inControl = (velMagnitude < 0.01 || Math.abs(dAngle) < (threshold * Math.PI / 180.0));
        //System.out.println(inControl + ", " + (dAngle * (180.0 / Math.PI) ));

        // Put the changed components back into velX and veLY
        velX = (float) ( frontComponent * Math.cos(image_angle) + sideComponent * Math.cos(image_angle + Math.PI/2) );
        velY = (float) ( frontComponent * Math.sin(image_angle) + sideComponent * Math.sin(image_angle + Math.PI/2) );

        // Input
        //TODO: we break if we go back and go slower
        int axisSide = (Input.keyPress( RIGHT ) ? 1 : 0) + (Input.keyPress( LEFT ) ? -1 : 0);
        int axisFront = (Input.keyPress( UP ) ? 1 : 0) + (Input.keyPress( DOWN ) ? -1 : 0);
        
        if (disabled) axisFront = 0; // if disabled, we cannot accelerate

        if (!inControl) axisSide *= 1.6;

        // rotate image
        image_angle += rotatePower * Math.pow(velMagnitude, 0.4) * axisSide;

        // destination turning thing
        double destAngle = image_angle + (Math.PI/180.0)*axisSide * turnAngle;

        // Move
        velX += axisFront * frontPower * Math.cos(destAngle);
        velY += axisFront * frontPower * Math.sin(destAngle);

        /// Get collisions with people
        // Collide methods:
        // Add to stack if person is NEXT to or BEHIND the car
        // kill if person is IN FRONT of car
        LinkedList<GameObjectPhysics> collisions = handler.getCollisions( new Rectangle((int)x - 16,(int)y - 16, 32, 32));
        Iterator<GameObjectPhysics> iter = collisions.iterator();
        while( iter.hasNext() ) {
            GameObjectPhysics current = iter.next();
            // Only do stuff if we have a person object
            if (current instanceof Person) {
                Person person = (Person) current;
                double personAngle = Math.atan2(person.y - y, person.x - x) + dAngle; // angle to player"'.;/":?"h
                double delta = Math.abs(MathUtil.getAngleDifference(personAngle, image_angle + dAngle));
                System.out.println( (180/Math.PI) * delta );

                // IF WE'RE WITHIN RANGE to kill the player
                double killThreshold = (Math.PI / 10.0) * 2.0 * (velMagnitude / maxSpeed);
                System.out.println("Speed: " + velMagnitude + ", Threshold: " + (killThreshold * (180 / Math.PI)) );

                if ( (velMagnitude > 1) && (delta < killThreshold || delta > Math.PI * (5.0/6.0)) ) {
                    person.die();
                    handler.gamestate.loseTime(1);
                } else {
                  if (isfull()) {
                    person.die();
                    handler.gamestate.loseTime(1);
                    return;
                  }
                    ppl.add(person.pickUp());
                    funEffectBump = 1.0f;
                    funEffect = 0f;
                }
                // SPAWN ANOTHER GUY after picking one up to compensate
                main.spawnRandomPerson();
            }
        }

        funEffectBump *= 0.8f;
        funEffectHeight -= funEffectHeightVel;
        funEffectHeightVel -= 0.1f;
        image_xscale = -1 * (1f + funEffectBump);
        image_yscale = 1f + funEffectBump;
    }

    @Override
    public void renderGUI() {
        //rect(0, 0, 25, 25);
        //fill( color( 0, 0, 0) );
        //text( Integer.toString(ppl.size()), 15, 15);
        Iterator<Person> iter = ppl.iterator();
        float dy = 100;
        float dx = 10f;
        while(iter.hasNext()) {
            Person person = iter.next();
            //image( person.animator.currentFrame(), 10, dy );
            if ( iter.hasNext() ) {
                dx = 10f;
            } else {
                dx = funEffect;
                funEffect += 0.1f *(10f - funEffect);
            }
            image( person.animator.currentFrame() , dx, dy );
            //fill( person.getCol() );
            //rect( dx, dy, 8, 8);
            dy+= 64;
        }
    }
}