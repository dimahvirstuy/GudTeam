/*************
 * SpriteAnimator
 * Holds a texture and animates it
 *************/

public class SpriteAnimator {

    public float animationSpeed = 1.0;

    private Texture texture;
    public float currentIndex = 0.0;

    public SpriteAnimator(Texture texture) {
        this.texture = texture;
    }

    // return current frame of animation
    public PImage currentFrame() {
        return texture.getSprite(currentIndex);
    }

    // to be called each frame. Updates animation
    public void update() {
        if (texture != null) {
            currentIndex += animationSpeed;
            currentIndex %= texture.size();
        }
    }

    public void setTexture(Texture texture) {
        if (texture != this.texture) {
            this.texture = texture;
            currentIndex = 0;
        }
    }
}