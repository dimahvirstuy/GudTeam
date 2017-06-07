/*************
 * Background
 * Holds image data for background map
 ************/

public class Background {
    private PImage[][] grid;

    private int imWidth = 128;
    private int imHeight = 128;

    public Background(String dir) {
        PImage bigImage = loadImage(dir);
        grid = new PImage[bigImage.width / imWidth][bigImage.height / imHeight];
        for(int xx = 0; xx < grid.length; xx++) {
            for(int yy = 0; yy < grid[xx].length; yy++) {
                // Sub Cropped Image
                grid[xx][yy] = new PImage(GraphicUtil.getSubimage((BufferedImage)bigImage.getImage(),xx*imWidth,yy*imHeight,imWidth,imHeight));
            }
        }
    }

    // Handles check. Don't wanna do that all the time
    public PImage getImage(int xIndex, int yIndex) {
        if (xIndex < 0 || xIndex >= grid.length || yIndex < 0 || yIndex >= grid[xIndex].length) return null;
        return grid[xIndex][yIndex];
    }

    public void render() {
        // draw tiles
        for(int xx = imWidth * ((int) (camera.xPos / imWidth) - 1); xx <= camera.xPos + camera.viewWidth + imWidth; xx+=imWidth) {
            for(int yy = imHeight * ((int) (camera.yPos / imHeight) - 1); yy <= camera.yPos + camera.viewHeight + imHeight; yy+=imHeight) {
                PImage tile = getImage( (xx / imWidth), (yy / imHeight));
                if ( tile != null)
                    image( tile, xx, yy);
                //rect(xx, yy, d, d);
            } 
        }
        /*
        for(int xx = 0; xx < grid.length; xx++)
            for(int yy = 0; yy < grid[xx].length; yy++)
                image( grid[xx][yy], xx*imWidth, yy*imHeight);
        */      
    }
}