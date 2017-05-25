/***************
 * Resources
 * Holds data for sprites and other resources 
 **************/

import java.awt.image.BufferedImage;

public class Resources {
    public String SPRITE_DIR = "images/";
    
    private PImage IMAGE_CHARSPRITE = loadImage(SPRITE_DIR + "charsheet.png");

    // PLAYER CHARACTER SPRITES
    //public Texture SPR_PLAYER_IDLE = new Texture(IMAGE_CHARSPRITE, 8, 8, 0, 0, 4, 2);
    public Texture SPR_PLAYER_IDLE = new Texture(IMAGE_CHARSPRITE, 8, 8, 0, 0, 2, 2);
    public Texture SPR_PLAYER_WALK = new Texture(IMAGE_CHARSPRITE, 8, 8, 2, 0, 2, 2);

}