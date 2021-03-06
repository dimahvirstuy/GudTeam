/***************
 * Resources
 * Holds data for sprites and other resources 
 **************/

import java.awt.image.BufferedImage;

public class Resources {
    public String SPRITE_DIR = "images/";

    private PImage IMAGE_CAR = loadImage(SPRITE_DIR + "yellow_car.png");
    private PImage IMAGE_TIRES = loadImage(SPRITE_DIR + "tires.png");

    public Texture SPR_CAR = new Texture(IMAGE_CAR);
    public Texture SPR_TIRES = new Texture(IMAGE_TIRES);
    public Texture SPR_PERSON_RED = new Texture( SPRITE_DIR + "red.png" );
    public Texture SPR_PERSON_BLUE = new Texture( SPRITE_DIR + "blu.png" );
    public Texture SPR_PERSON_YELLOW = new Texture( SPRITE_DIR + "yellow.png" );

    //public Texture SPR_PERSON = null;//new Texture(IMAGE_PERSON, 8, 8, 0, 0, 3, 3); // 3 images in this 8x8tile spritesheet
    // PLAYER CHARACTER SPRITES
    /*public Texture SPR_PLAYER_IDLE = new Texture(IMAGE_CHARSPRITE, 8, 8, 0, 0, 2, 2);
    public Texture SPR_PLAYER_WALK = new Texture(IMAGE_CHARSPRITE, 8, 8, 2, 0, 2, 2);

    public Texture SPR_SPRING = new Texture(IMAGE_SPRING);
    */
}