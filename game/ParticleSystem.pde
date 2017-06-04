/***********
 * ParticleSystem
 * Spits out particles at interval, spread, ect.
 **********/

public class ParticleSystem {

    public boolean active = true;   // Are we spitting particles?

    public float x, y;
    public float emissionRate;       // How fast we spit particles
    public int   emissionCount = 1;  // How many particles we spit at a time
    public float decayRate;          // How fast we decay
    public float particleSpeed;      // Speed of particles
    public float particleSpeedRandomness;
    public float emissionAngle;      // Angle for which the particles travel
    public float emissionAngleRandomness;

    public Texture particleTexture = null;         // Texture of particles
    public float particleAngle;                    // Angle of particle
    public float particleXoffset, particleYoffset; // Draw offset of particles
    public float particleDrawOrder;
    public float particleFriction;

    //float alpha1 = 1, alpha2 = 1; // particles move from alpha1 to alpha2 during emission

    private float counter;

    // Must be called MAUNUALLY
    public void update() {
        if (active) {
            counter++;
            while (counter > emissionRate) {
                counter -= emissionRate;
                spit();
            }
        }
    }

    // Spit one group of particles
    public void spit() {
        for(int i = 0; i < emissionCount; i++) {
            launchParticle();
        }
    }

    // launch a particle
    private void launchParticle() {
        Particle particle = new Particle( x, y, decayRate, particleTexture );

        particle.image_angle = particleAngle;
        particle.image_xoffset = particleXoffset;
        particle.image_yoffset = particleYoffset;
        particle.drawOrder = particleDrawOrder;

        handler.addObject( particle );
    }

    class Particle extends GameObject {
        private float timeLeft;
        private float velX, velY;
        private float friction;

        public Particle(float x, float y, float decayRate, Texture texture) {
            super(x, y, texture);
            timeLeft = decayRate;
        }

        @Override
        public void update() {
            x += velX;
            y += velY;

            // Vector math. Take magnitude, decrease, reset velX an velY by normalizing and re-multiplying
            double mag = Math.sqrt( velX*velX + velY*velY );
            double newMag = mag - friction;
            if (newMag <= 0) {
                newMag = 0;
                velX = 0;
                velY = 0;
            } else {
                velX = (float) (newMag * (velX / mag));
                velY = (float) (newMag * (velY / mag));            
            }

            timeLeft -= 1;
            if (timeLeft < 0) {
                destroy();
            }
        }
    }
}