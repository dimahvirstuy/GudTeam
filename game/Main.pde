/*******************************
 * Main Class
 *
 *******************************/

public class Main {

    public GameObjectHandler handler;
    
    public float dTime; // delta time. Used for movement
    private long lastTime;
    private float lastTimeFactor = (1f / (1000 * 1000)) * (1f / 60f);

    public Main() {
        handler = new GameObjectHandler();
    }

    public void initialize() {
        Player player = new Player(0,0);
        handler.addObject( player );
        handler.player = player; // for ease of access

        //camera.viewWidth *= 2;
        //-camera.viewHeight *= 2;

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
        
        for(int i = 0; i < 30; i++) {
            handler.addObject( new Person( (float)Math.random() * 1900, 250 + (float)Math.random() * 1900, PERSON_COLOR.BLUE) );
        }

        handler.addObject( new CollisionTest(16, 200 - 16) );
        handler.addObject( new CollisionTest(64 - 16, 200 - 16) );
        
        handler.addObject( new DropOffZone( -100, -100, 50, 50, PERSON_COLOR.RED ) );

        lastTime = System.nanoTime();
    }

    public void update() {

        long currentTime = System.nanoTime();
        dTime = lastTimeFactor * (currentTime - lastTime);
        lastTime = currentTime;

        background(0);

        colorMode(RGB);
        stroke(color(255,255,255));
        fill(color(150,150,150));
        // draw tiles
        int d = 128;
        for(int xx = d * ((int) (camera.xPos / d) - 1); xx < camera.xPos + camera.viewWidth + d; xx+=d) {
            for(int yy = d * ((int) (camera.yPos / d) - 1); yy < camera.yPos + camera.viewHeight + d; yy+=d) {
                rect(xx, yy, d, d);
            } 
        }
        

        handler.loopAll(true, true);
        Input.updatePostTick();
    }
}