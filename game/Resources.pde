/***************
 * Resources
 * Holds data for sprites and other resources 
 **************/

import java.awt.image.BufferedImage;

public class Resources {
    public String SPRITE_DIR = "images/";

    private PImage IMAGE_CAR = loadImage(SPRITE_DIR + "yellow_car.png");

    public Texture SPR_CAR = new Texture(IMAGE_CAR);

    // PLAYER CHARACTER SPRITES
    /*public Texture SPR_PLAYER_IDLE = new Texture(IMAGE_CHARSPRITE, 8, 8, 0, 0, 2, 2);
    public Texture SPR_PLAYER_WALK = new Texture(IMAGE_CHARSPRITE, 8, 8, 2, 0, 2, 2);

    public Texture SPR_SPRING = new Texture(IMAGE_SPRING);
    */
}