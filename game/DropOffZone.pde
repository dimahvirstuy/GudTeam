/************
 * DropOffZone
 * Where people get dropped off
 * Static objects that are set at the beginning of the game
 ***********/


public class DropOffZone extends GameObjectPhysics {

    private float w, h;
    private PERSON_COLOR col;

    public DropOffZone( float x, float y, float w, float h, PERSON_COLOR col) {
        super(x,y, null);
        this.w = w;
        this.h = h;
        this.col = col;
        collisionBox = new Rectangle((int)w, (int)h);
    }

    @Override
    public void update() {
        // If we're colliding with the player
        if ( handler.doObjectsCollide(this, handler.player, 0, 0 ) ) {
            handler.player.dropOff( col );
        }
    }

    @Override
    public void render() {
        // draw gate?
        noFill();
        colorMode( RGB );
        switch( col ) {
            case RED:
                stroke( color(255, 0, 0) );
                break;
            case BLUE:
                stroke( color(0, 0, 255) );
                break;
            case YELLOW:
                stroke( color(255, 255, 0) );
                break;
            default:
                break;
        }
        rect(x, y, w, h);
    }

}