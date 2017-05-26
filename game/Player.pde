/*************
 * Player
 * Vroom Vroom
 ************/

public class Player extends GameObjectPhysics {

    private float sideFriction = 0.2; // Friction on side
    private float frontFriction = 0.04; // Friction on front of car

    private float frontPower = 0.21f; // acceleration power (gas pedal)
    private float turnAngle = 40; // degrees
    private float rotatePower = 0.016f; // how fast we rotate
    private float breakPower = 0.06f;

    private float maxSpeed = 10f;
    private boolean inControl = true; // Whether car is in "control" (otherwise it's in "initial D drift" mode)

    public Player(float x, float y) {
        super(x, y, resources.SPR_CAR);
        collideWithOthers = true;
        collisionBox = new Rectangle(-8, -8, 16, 16);
        image_xscale = -1;
        image_xoffset = 16;
        image_yoffset = 8;
    }

    // TODO: Move this to a "MathStuff" or "Util" class
    private double getAngleDifference(double angle1, double angle2) {
        double phi = angle2%(Math.PI*2) - angle1%(Math.PI*2);
        phi = (Math.abs(phi) > Math.PI ? -(Math.signum(phi) * Math.PI*2 - phi) : phi);
        return phi;
    }

    @Override
    public void update() {
        super.update();

        // Follow player
        camera.xPos = x - camera.viewWidth / 2;
        camera.yPos = y - camera.viewHeight / 2;
        double velMagnitude = Math.sqrt( velX * velX + velY * velY );
        // clamp to max speed
        velMagnitude = (velMagnitude > maxSpeed) ? maxSpeed : velMagnitude;

        // breaking
        if (Input.keyPress( (int)' ' )) {
            velMagnitude -= breakPower;
            if (velMagnitude < 0) velMagnitude = 0;
        }


        // SIDE AND FRONT FRICTION
        double velAngle = Math.atan2(velY, velX);
        double dAngle = getAngleDifference(image_angle, velAngle);//(velAngle - image_angle);
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
        System.out.println(inControl + ", " + (dAngle * (180.0 / Math.PI) ));

        // Put the changed components back into velX and veLY
        velX = (float) ( frontComponent * Math.cos(image_angle) + sideComponent * Math.cos(image_angle + Math.PI/2) );
        velY = (float) ( frontComponent * Math.sin(image_angle) + sideComponent * Math.sin(image_angle + Math.PI/2) );

        // Input
        //TODO: we break if we go back and go slower
        int axisSide = (Input.keyPress( RIGHT ) ? 1 : 0) + (Input.keyPress( LEFT ) ? -1 : 0);
        int axisFront = (Input.keyPress( UP ) ? 1 : 0) + (Input.keyPress( DOWN ) ? -1 : 0);

        if (!inControl) axisSide *= 1.6;

        // rotate image
        image_angle += rotatePower * Math.pow(velMagnitude, 0.4) * axisSide;

        // destination turning thing
        double destAngle = image_angle + (Math.PI/180.0)*axisSide * turnAngle;

        // Move
        velX += axisFront * frontPower * Math.cos(destAngle);
        velY += axisFront * frontPower * Math.sin(destAngle);            

    }
}