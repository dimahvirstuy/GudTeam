/***************
 * PlayerTest
 * Test for player using GameObject inheritance.
 **************/

/*import java.util.Stack;

public class PlayerTest extends GameObjectPhysics {

    private Texture SPRITE_IDLE = resources.SPR_PLAYER_IDLE;
    private Texture SPRITE_WALK = resources.SPR_PLAYER_WALK;

    private int jimer; // jump hold timer
    private int fimer; // fall timer
    private int fimer_time = 10; // How many frames of "leeway" falling
    private float airResistance = 0.05;

    private Stack<GameObjectPhysics> pocket; // Held Physics Objects

    public PlayerTest() {
        super(10,190.1, resources.SPR_PLAYER_IDLE);

        collisionBox = new Rectangle(-4,0, 8, 8);
        collideWithOthers = true;

        gravity = 0.2f;
        groundFriction = 0.1f;

        animator.animationSpeed = 0.1f;
        image_xoffset = 4;
    }

    @Override
    public void update() {
        super.update();

        // Movement
        float spd = 0.2f;

        int axisX = (Input.keyPress( RIGHT ) ? 1 : 0) + (Input.keyPress( LEFT ) ? -1 : 0);
        //int axisY = (Input.keyPress( DOWN ) ? 1 : 0) + (Input.keyPress( UP ) ? -1 : 0);
        velX += axisX * spd;

        if (grounded) {
            jimer = 0;
            fimer = 0;
            if (axisX == 0) {
                animator.setTexture( SPRITE_IDLE );
            } else {
                animator.setTexture( SPRITE_WALK );
                image_xscale = axisX;
            }
        } else {
            fimer++;
            if (velY < 0) {
                if (Input.keyPress(UP) && jimer < 15) {
                    jimer++;
                    velY -= 0.3f;
                }
            }
        }

        if (fimer < fimer_time) {
            if (Input.keyPressed( UP ) ) {
                velY = -4f;
                fimer = fimer_time;
            }
        }

        velY *= (1f - airResistance);

        // Make Camera follow Player
        camera.xPos = x - camera.viewWidth / 2;
        camera.yPos = y - camera.viewHeight / 2;
    }

    @Override
    public void render() {
        super.render();
        //fill(255);
        //image(animator.currentFrame(), x, y);
        //rect(x, y, collisionBox.width, collisionBox.height);
    }
}
*/