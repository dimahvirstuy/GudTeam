
public class CollisionTest extends GameObjectPhysics {

    // Color stuff
    private float offset;

    public CollisionTest(float x, float y) {
        super(x,y, null);
        collisionBox = new Rectangle(16, 16);

        offset = random(2*PI);
        
        isStatic = true;
        
        // Move at random direction
        //float direction = random(2f * PI);
        //float speed = 1.0f;
        //velX = speed * cos(direction);
        //velY = speed * sin(direction);
    }

    @Override
    public void update() {
        super.update();
        // Collide with walls
        if (x > PORT_WIDTH - collisionBox.width) {
            x = PORT_WIDTH - collisionBox.width;
            velX *= -1;
        } else if (x < 0) {
            x = 0;
            velX *= -1;
        }

        if (y > PORT_HEIGHT - collisionBox.height) {
            y = PORT_HEIGHT - collisionBox.height;
            velY *= -1;
        } else if (y < 0) {
            y = 0;
            velY *= -1;
        }

        // Collisions!!
        /*LinkedList<GameObjectPhysics> xCollisions = handler.getCollisions(this,velX,0);
        LinkedList<GameObjectPhysics> yCollisions = handler.getCollisions(this,0,velY);

        if ( !xCollisions.isEmpty() ) velX *= -1;
        if ( !yCollisions.isEmpty() ) velY *= -1;
        */
        
        //LinkedList<GameObjectPhysics> collisions = main.handler.collisionTree.getCollisions(this, 0, 0);
        //isColliding = !collisions.isEmpty();
    }

    @Override
    public void render() {
        /*if (isColliding) {
            fill(255, 0, 0);
        } else {
            fill(200, 200, 200);
        }*/
        colorMode(HSB);
        
        color col = color( 255 * (1 + sin( offset + millis() / 1000f ))/2 , 255, 255);
        
        stroke(col);
        fill( col );
        rect(x, y, collisionBox.width, collisionBox.height);
    }
}