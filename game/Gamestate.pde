/***********
 * Gamestate
 * Controls state of game (timer along with WIN/LOSE condition)
 **********/


public class Gamestate extends GameObject {

    private float masterTimer = 15f; // if this thing hits zero, we dead
    private float timerDecayRate = 1f/60f; // how fast the thing ticks down

    private boolean dead, gameOver; // Are we dead? Are we having a GameOver Screen/

    // Hover text: +5, -10, "BONUS +5!" ect..
    private float hoverTextHeight;
    private color hoverTextColor;
    private String hoverText = "";
    private color COLOR_BONUS, COLOR_BAD;

    private int score = 0;
    private String hoverTextScore = "";
    private float hoverTextScoreHeight;
    private color hoverTextScoreColor;

    public Gamestate() {
        super(0,0,null);
        colorMode( RGB );
        COLOR_BONUS = color( 0, 255, 0 );
        COLOR_BAD = color( 255, 0, 0 );
    }

    @Override
    public void update() {
        masterTimer -= timerDecayRate;
        if (masterTimer < 0) {
            masterTimer = 0;
            if (!dead) {
                dead = true;
                handler.player.disabled = true;
            }
        }
        hoverTextHeight -= 0.02f;
        hoverTextScoreHeight -= 0.02f;
        if (hoverTextHeight < 0) hoverTextHeight = 0;
        if (hoverTextScoreHeight < 0) {
            hoverTextScoreHeight = 0;
            hoverTextScore = "";
        }
        
        if (dead) {
            // If the player pulled a recovery comeback
            if (masterTimer > 0) {
                dead = false;
                handler.player.disabled = false;
            }
            if (Math.abs(handler.player.velX) < 0.1 && Math.abs(handler.player.velY) < 0.1) {
                gameOver = true;
            }
        }
    }

    public void bonusTime( int ammount ) {
        masterTimer += ammount;
        hoverText = "+" + ammount;
        hoverTextHeight = 1f;
        hoverTextColor = COLOR_BONUS;
    }

    public void loseTime( int ammount ) {
        masterTimer -= ammount;
        hoverText = "-" + ammount;
        hoverTextHeight = 1f;
        hoverTextColor = COLOR_BAD;
    }

    public void setTime( int time ) {
        masterTimer = time;
        hoverText = "reset!";
        hoverTextHeight = 1f;
        hoverTextColor = COLOR_BONUS;        
    }

    public void addScore( int ammount, int multiplier ) {
        score += ammount;
        if (multiplier > 1) {
            hoverTextScore = "x" + multiplier + "! + " + ammount;
        } else {
            hoverTextScore = "+ " + ammount;
        }
        hoverTextScoreHeight = 1f;
        hoverTextScoreColor = COLOR_BONUS;
    }

    @Override
    public void renderGUI() {
        colorMode( RGB );
        textSize(40);
        fill( color( 255, 255, 0) );
        text( Integer.toString( (int) masterTimer ), PORT_WIDTH / 2 - 16, 40 );

        textSize(45 * hoverTextHeight + 1);
        fill( hoverTextColor );
        text( hoverText, PORT_WIDTH / 2 + 16, 40 + 80*hoverTextHeight);

        fill( color(255, 0, 255) );
        textSize( 20 );
        text( "Score: " + Integer.toString( score ), PORT_WIDTH - 128, 60);
        fill( hoverTextScoreColor );
        text( hoverTextScore, PORT_WIDTH - 128, 60 + 90*hoverTextScoreHeight);

        if (gameOver) {
            String gameOverText = "Game Over";
            textSize(80);
            fill( color( 150, 190, 0) );
            text( gameOverText, PORT_WIDTH / 2 - textWidth(gameOverText) / 2, PORT_HEIGHT/2 + (float) (24*Math.sin(millis() * 0.001) ));
            textSize(60);
            fill( color( 20, 20, 20) );
            text("FINAL SCORE: " + Integer.toString(score), PORT_WIDTH/2 - 12, PORT_HEIGHT/2 + 80);
            text("Press Space to try again", PORT_WIDTH/2 - 12, PORT_HEIGHT/2 + 200);
            if (Input.keyPress((int)' ')) {
                gameOver = false;
                setTime(15);
                score = 0;
                handler.player.velX = 5f;
            }
        }
        
    }
}