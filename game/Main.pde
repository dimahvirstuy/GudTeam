/*******************************
 * Main Class
 *
 *******************************/

public class Main {

    public GameObjectHandler handler;

    private StartScreen startScreen;

    public float dTime; // delta time. Used for movement
    private long lastTime;
    private float lastTimeFactor = (1f / (1000 * 1000)) * (1f / 60f);

    public Main() {
        handler = new GameObjectHandler();
    }

    public void initialize() {
        startScreen = new StartScreen();
        /*Player player = new Player(0,0);
        handler.addObject( player );
        handler.player = player; // for ease of access

        Gamestate gamestate = new Gamestate();
        handler.addObject( gamestate );
        handler.gamestate = gamestate;

        //camera.viewWidth *= 2;
        //-camera.viewHeight *= 2;

        /*handler.addObject( new CollisionTest( 30, 30 ) );
        handler.addObject( new CollisionTest( 90, 30 ) );
        handler.addObject( new CollisionTest( 30, 90 ) );
        
        for(float xx = 0; xx < PORT_WIDTH; xx+=64f) {
            handler.addObject( new CollisionTest(xx, 200) );
            /*for(float yy = 0; yy < PORT_HEIGHT; yy+=15f) {
                handler.addObject( new CollisionTest(xx, yy) );
            }
        }

        for(int i = 0; i < 30; i++) {
            int rand = (int) (Math.random() * 3);
            PERSON_COLOR col;
            switch (rand) {
                case 0:
                    col = PERSON_COLOR.BLUE;
                    break;
                case 1:
                    col = PERSON_COLOR.RED;
                    break;
                case 2:
                default:
                    col = PERSON_COLOR.YELLOW;
                    break;
            }
            handler.addObject( new Person( (float)Math.random() * 1900, 250 + (float)Math.random() * 1900, col) );
            
        }

        handler.addObject( new CollisionTest(16, 200 - 16) );
        handler.addObject( new CollisionTest(64 - 16, 200 - 16) );

        handler.addObject( new DropOffZone( -100, -100, 50, 50, PERSON_COLOR.RED ) );
        handler.addObject( new DropOffZone( -100, 100, 50, 50, PERSON_COLOR.BLUE ) );
        handler.addObject( new DropOffZone( -100, 300, 50, 50, PERSON_COLOR.YELLOW ) );
        */
        lastTime = System.nanoTime();
    }

    // Spawns a random person at a random position
    public void spawnRandomPerson() {
        int rand = (int) (Math.random() * 3);
        PERSON_COLOR col;
        switch (rand) {
            case 0:
                col = PERSON_COLOR.BLUE;
                break;
            case 1:
                col = PERSON_COLOR.RED;
                break;
            case 2:
            default:
                col = PERSON_COLOR.YELLOW;
                break;
        }
        handler.addObject( new Person( (float)Math.random() * 1900, 250 + (float)Math.random() * 1900, col) );
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

        if (!startScreen.startGame) {
            startScreen.update();
            startScreen.renderGUI();
        }

    }
}