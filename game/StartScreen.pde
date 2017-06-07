/***********
 * Janky Start Screen
 * Holds menu stuff. Once it starts, the game begins.
 **********/

public class StartScreen {
    private float slideIn = 1.0f; // Title Slidein
    private boolean openMenu = false;
    private float xOffset = 600f;
    private float dXpos = 2000;
    public boolean startGame = false;

    public void update() {
        if (!startGame) {
            if (slideIn > 0) {
                slideIn -= 0.01f;
            }
            if (slideIn < 0) {
                slideIn = 0;
                openMenu = true;
            }
        } else {
            slideIn += 0.01f;
        }

        xOffset *= 0.99;
        dXpos += 10f;

        if (!startGame && openMenu) {
            if (Input.keyPress( (int)' ' ) ) {
                startGame = true;
                initializeEverything();
            }
        }
    }

    public void renderGUI() {
        
        if (!startGame) {
            camera.xPos = xOffset + dXpos;
            image(resources.IMAGE_CAR, dXpos + PORT_WIDTH / 2, PORT_HEIGHT / 2);
        }

        pushMatrix();

        translate(camera.xPos, 0);
        colorMode( RGB );

        textSize(20);
        if (!startGame) {
            fill( color( 0, 0, 0) );
            String gudTeam = "GudTeam presents...";
            text(gudTeam, PORT_WIDTH/2 - textWidth(gudTeam)/2, 24);
        }
        
        textSize(80);
        fill( color(255, 255, 0) );
        float h = 128;
        text("Yellow ", PORT_WIDTH/2 - textWidth("Yellow ") - 2*PORT_WIDTH*slideIn, h);
        text("Car", PORT_WIDTH/2 + 2*PORT_WIDTH*slideIn, h);
        if (!startGame && openMenu) {
            int intensity = (int) (100 + 100 * Math.sin(0.005 * millis()));
            fill( color( intensity, intensity, intensity ) );
            textSize(30);
            String text = "Press SPACE to continue...";
            text( text, PORT_WIDTH/2 - textWidth(text)/2, PORT_HEIGHT/2);
        }

        popMatrix();
    }

    // MAIN INITIALIZATION CALL
    // EVERYTHING is created here
    public void initializeEverything() {
        camera.xPos %= 128;

        Player player = new Player(dXpos%128,PORT_HEIGHT / 2);
        player.velX = 10f;

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
        */
        /*for(float xx = 0; xx < PORT_WIDTH; xx+=64f) {
            handler.addObject( new CollisionTest(xx, 200) );
            /*for(float yy = 0; yy < PORT_HEIGHT; yy+=15f) {
                handler.addObject( new CollisionTest(xx, yy) );
            }
        }*/

        for(int i = 0; i < 30; i++) {
            main.spawnRandomPerson();
        }
        /*handler.addObject( new CollisionTest(16, 200 - 16) );
        handler.addObject( new CollisionTest(64 - 16, 200 - 16) );*/

        handler.addObject( new DropOffZone( 1483, 1032, 16*10, 16*10, PERSON_COLOR.BLUE ) );
        handler.addObject( new DropOffZone( 769, 7, 16*10, 16*10, PERSON_COLOR.RED ) );
        handler.addObject( new DropOffZone( 84, 1098, 16*10, 16*10, PERSON_COLOR.YELLOW ) );
        
        /*handler.addObject( new DropOffZone( -200, -100, 100, 100, PERSON_COLOR.RED ) );
        handler.addObject( new DropOffZone( -200, 100, 100, 100, PERSON_COLOR.BLUE ) );
        handler.addObject( new DropOffZone( -200, 300, 100, 100, PERSON_COLOR.YELLOW ) );
        */
    } 
}