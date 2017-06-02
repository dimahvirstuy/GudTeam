/***********
 * ParticleSystem
 * Spits out particles at interval, spread, ect.
 **********/

public class ParticleSystem {

    public boolean active = true;   // Are we spitting particles?

    public float x, y;
    public float emissionRate;      // How fast we spit particles
    public int emissionCount = 1;   // How many particles we spit at a time
    public float decayRate;         // How fast we decay
    public Texture particleTexture = null;         // Texture of particles
    public float particleAngle;                    // Angle of particle
    public float particleXoffset, particleYoffset; // Draw offset of particles
    public float particleDrawOrder;

    //float alpha1 = 1, alpha2 = 1; // particles move from alpha1 to alpha2 during emission

    private float counter;

    // Must be called MAUNUALLY
    public void update() {
        if (active) {
            counter++;
            while (counter > emissionRate) {
                counter -= emissionRate;
                for(int i = 0; i < emissionCount; i++) {
                    spit();
                }
            }
        }
    }

    // Spit a particle
    private void spit() {
        Particle particle = new Particle( x, y, decayRate, particleTexture );

        particle.image_angle = particleAngle;
        particle.image_xoffset = particleXoffset;
        particle.image_yoffset = particleYoffset;
        particle.drawOrder = particleDrawOrder;

        handler.addObject( particle );
    }

    class Particle extends GameObject {
        private float timeLeft;

        public Particle(float x, float y, float decayRate, Texture texture) {
            super(x, y, texture);
            timeLeft = decayRate;
        }

        @Override
        public void update() {
            timeLeft -= 1;
            if (timeLeft < 0) {
                destroy();
            }
        }
    }
}