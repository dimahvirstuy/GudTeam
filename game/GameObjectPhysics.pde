
import java.awt.Rectangle;

public abstract class GameObjectPhysics extends GameObject {

    // Velocity
    public float velX, velY;
    protected boolean collideWithOthers = false;
    // Collision
    // Collision box / bounding rectangle for object. No rotations for now
    public Rectangle collisionBox;

    // Whether this object is static (not moving, not removed from quadtree)
    public boolean isStatic = false;
    // Whether this object is in the quadtree. To be used with the "isStatic" boolean
    private boolean inTree = false;

    public GameObjectPhysics(float x, float y, Texture sprite) {
        super(x,y, sprite);
        velX = 0;
        velY = 0;
        collisionBox = new Rectangle(0,0);
    }

    @Override
    public void update() {
        super.update();
        if (!isStatic) {

            //System.out.println( "(" + x + ", " + y + ")" + ", next: (" + (x + velX) + ", " + (y + velY) + ")" );
            if (collideWithOthers) {
                // Side collisions
                if ( handler.isColliding(this, velX, 0, CollisionTest.class) ) {
                    //System.out.println("wat");
                    // Keep moving until we contact the wall
        
                    x = floor(x);
        
                    int dx = 0;
                    while( !handler.isColliding(this, dx, 0, CollisionTest.class) ) dx += Math.signum(velX);
                    x += dx - Math.signum(velX);
                    velX = 0;
                }
                x += velX;
        
                // Top-Bottom collisions
                if ( handler.isColliding(this, 0, velY, CollisionTest.class) ) {
                    //System.out.println("wat2");
                    // Keep moving until we contact the wall
        
                    y = floor(y);
        
                    int dy = 0;
        
                    while( !handler.isColliding(this, 0, dy, CollisionTest.class) ) dy += Math.signum(velY);
                    y += dy - Math.signum(velY);
                    //System.out.println("new y : " + y);
                    velY = 0;
                }
                y += velY;
            } else {
                x += velX;
                y += velY;
            }
        }

        /*
        velY += gravity;
        x += velX * main.dTime;
        y += velY * main.dTime;
        */
    }
    
    // Returns collision box with actual position (where it is in WORLD not object-relative coordinates)
    public Rectangle getActualCollisionBox() {
        return getActualCollisionBox(0,0);
    }
    
    // Returns collision box with actual position (where it is in WORLD not object-relative coordinates)
    public Rectangle getActualCollisionBox(float offsetX, float offsetY) {
        return new Rectangle(
            round(x + offsetX) + collisionBox.x,
            round(y + offsetY) + collisionBox.y,
            collisionBox.width,
            collisionBox.height);
    }

    public boolean isInTree() {
        return inTree;
    }

    public void setInTree() {
        inTree = true;
    }

    /*public void setCollisions(LinkedList<GameObjectPhysics> collisionObjects) {
        this.collisionObjects = collisionObjects;
    }*/
    
}