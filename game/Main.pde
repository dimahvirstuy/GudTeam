/*******************************
 * Main Class
 *
 *******************************/

public class Main {

    public GameObjectHandler handler;
    
    public float dTime; // delta time. Used for movement
    private long lastTime;
    private float lastTimeFactor = (1f / (1000 * 1000)) * (1f / 60f);

    public void initialize() {
        handler = new GameObjectHandler();
        handler.addObject( new PlayerTest() );
        
        /*handler.addObject( new CollisionTest( 30, 30 ) );
        handler.addObject( new CollisionTest( 90, 30 ) );
        handler.addObject( new CollisionTest( 30, 90 ) );
        */
        for(float xx = 0; xx < PORT_WIDTH; xx+=64f) {
            handler.addObject( new CollisionTest(xx, 200) );
            /*for(float yy = 0; yy < PORT_HEIGHT; yy+=15f) {
                handler.addObject( new CollisionTest(xx, yy) );
            }*/
        }

        lastTime = System.nanoTime();
    }

    public void update() {
        
        long currentTime = System.nanoTime();
        dTime = lastTimeFactor * (currentTime - lastTime);
        lastTime = currentTime;

        background(0);

        handler.loopAll(true, true);
        Input.updatePostTick();
    }
}