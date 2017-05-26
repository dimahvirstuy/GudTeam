/***********
 * Central GameObject class.
 * Has position, basic rendering and is abstract
 * For every single physial object in the game.
 ***********/

// DEFINE ALL TAGS HERE
public static enum OBJECT_TAG {
    Default
}

public abstract class GameObject {

    public float x, y;

    public OBJECT_TAG tag = OBJECT_TAG.Default;

    // Marker for whether object should be destroyed
    // Destroyed in loop
    private boolean destroy;

    // Don't call render() if "visible" is false
    public boolean visible = true; 

    // Personal texture / sprite
    private Texture sprite;
    protected SpriteAnimator animator;

    protected float image_xscale = 1.0f;
    protected float image_yscale = 1.0f;
    protected float image_xoffset = 0.0f;
    protected float image_yoffset = 0.0f;

    float image_angle = 0.0f;

    public GameObject(float x, float y, Texture sprite) {
       this.x = x;
       this.y = y;
       this.sprite = sprite;
       this.animator = new SpriteAnimator(sprite);
    }

    // All physics and math is done here
    public void update() {
        animator.update();
    }

    // All rendering is done here
    public void render() {
        pushMatrix();
        translate(x, y);
        rotate(image_angle);
        scale( image_xscale, image_yscale );
        translate(-image_xoffset, -image_yoffset);
        image( animator.currentFrame() , 0, 0 );
        popMatrix();
    }

    // Mark object to destroy before next tick
    public void destroy() {
        destroy = true;
    }

    // Returns whether object is marked for destroy
    public boolean shouldDestroy() {
       return destroy; 
    }

    public Texture getTexture() { 
        return sprite;
    }

    public void setTexture(Texture texture) {
        sprite = texture;
        animator.texture = texture;
    }
}