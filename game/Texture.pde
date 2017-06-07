/*************
 * Texture class
 * Stores images in an animation array
 *************/

import java.awt.image.BufferedImage;
import java.awt.Graphics;

public static class GraphicUtil {
      public static BufferedImage getSubimage(BufferedImage img, int x, int y, int w, int h) {
        BufferedImage sub = img.getSubimage(x, y, w, h);
        BufferedImage result = new BufferedImage(w, h, img.getType());
        Graphics g = result.getGraphics();
        g.drawImage(sub, 0, 0, null);
        g.dispose();
        return result;
    }
}

public class Texture {

    private PImage[] frames;

    // Creates a texture out of an image array
    public Texture(PImage[] frames) {
        this.frames = frames;
    }

    // Creates a texture from one image
    public Texture(PImage sprite) {
        this( new PImage[]{sprite} );
    }

    // Creates a single image texture from its path
    public Texture(String spritePath) {
        this( loadImage(spritePath) );
    }

    // Create image from spritesheet
    // cellWidth + height: dimensions of unit sprite
    // x + yOffset: Cell offset for start of sprite
    // count: number of frames
    // rowWidth: How many rows to move on before wrapping to left
    public Texture(PImage sheet, int cellWidth, int cellHeight, int xOffset, int yOffset, int count, int rowWidth) {
        BufferedImage img = (BufferedImage) sheet.getImage();
        //image(sheet, 0, 0);
        frames = new PImage[count];
        for(int i = 0; i < count; i++) {
            int currentX = cellWidth * (xOffset + i%rowWidth);
            int currentY = cellHeight * (yOffset + (int)(i/rowWidth));
            System.out.println("(" + currentX + ", " + currentY + ")");
            frames[i] = new PImage(GraphicUtil.getSubimage(img,currentX, currentY, cellWidth, cellHeight));
        }

    }

    // Same spritesheet function but it uses a sprite Path instead of a direct image
    public Texture(String spritePath, int cellWidth, int cellHeight, int xOffset, int yOffset, int count, int rowWidth) {
        this( loadImage(spritePath), cellWidth, cellHeight, xOffset, yOffset, count, rowWidth);
    }

    public PImage getSprite( float index ) {
        return frames[(int)index];
    }

    public int size() {
        return frames.length;
    }

}