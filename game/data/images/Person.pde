/************
 * Person
 * Dude that can be picked up
 ************/

public static enum PERSON_COLOR {
    RED, GREEN, BLUE
}

public class Person extends GameObjectPhysics {

    PERSON_COLOR col;

    public Person(float x, float y, PERSON_COLOR col) {
        super(x, y, resources.SPR_PERSON);
        animator.animationSpeed = 0;
        animator.currentIndex = col.ordinal(); // We assume the spritesheet is arranged correctly

        this.col = col;

        collideWithOthers = true;

        int buffer = 5;
        collisionBox = new Rectangle(-4 - buffer,-8 - buffer, 8 + 2*buffer, 16 + 2*buffer);
        image_xoffset = -4;
        image_yoffset = -16;
        
        switch (col) {
            case RED:
                setTexture(resources.SPR_RED);
            case GREEN:
                setTexture(resources.SPR_YELLOW);
            case BLUE:
                setTexture(resources.SPR_BLU);
        }
    }
    public void update() {
    }

    @Override
    public void render() {
        super.render();
        rect(x - 4, y - 16, 8, 16);
        double theta = Math.atan2( (y - handler.player.y),  (x - handler.player.x) );
        double delta = MathUtil.getAngleDifference(handler.player.image_angle, theta);
        theta *= (180 / Math.PI); // rad to deg
        delta *= (180 / Math.PI); // rad to deg
        text( Double.toString(theta), x - 10, y + 10 );
        text( Double.toString(delta), x - 10, y + 22 );
        
    }

    // Get run over by a car
    public void die() {
        destroy();
        System.out.println("DEAD");
        // TODO: Create a "corpse" object
    }

    // Get picked up by a car
    public Person pickUp() {
        visible = false;
        collisionBox = new Rectangle(0,0,0,0); // Make object un-collidable
        System.out.println("Picked Up!");
        return this;
    }

    // Get dropped off by a car
    public void dropOff() {
        
    }

}