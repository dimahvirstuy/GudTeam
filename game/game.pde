/*******************************
 * MASTA CLASS
 *
 * ALL PROCESSING SPECIFIC FUNCTIONS GO HERE
 * avoid using processing functions (setup, draw, ect) anywhere else
 *******************************/

// Universal Objects
Main main;
Camera camera;
GameObjectHandler handler;
Resources resources;


final int PORT_WIDTH = 1024;
final int PORT_HEIGHT = PORT_WIDTH * 3/4;

void setup() {
    // We use surface.setSize(w,h) and not "size(w,h)" because this can accept variables
    // and proccessing's "special" method for some reason is MAGIC
    // and refuses to use variables.
    // Screw that I say!
    surface.setSize(PORT_WIDTH, PORT_HEIGHT);
    main = new Main();
    handler = main.handler;

    camera = new Camera();
    resources = new Resources();
    main.initialize();

    smooth(0); // No anti-aliasing

}

void draw() {
    // Transform to camera specifications

    scale( PORT_WIDTH / camera.viewWidth, PORT_HEIGHT / camera.viewHeight );
    translate(camera.viewWidth/2, camera.viewHeight/2);
    rotate( camera.viewAngle);
    translate(-camera.viewWidth/2, -camera.viewHeight/2);
    translate(-camera.xPos, -camera.yPos);

    main.update(); 
}

void keyPressed() {
    Input.updateKeyPress(keyCode, true);
}
void keyReleased() {
    Input.updateKeyPress(keyCode, false);
}