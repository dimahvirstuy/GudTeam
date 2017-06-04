/***********
 * Gamestate
 * Controls state of game (timer along with WIN/LOSE condition)
 **********/


public class Gamestate extends GameObject {

    private float masterTimer = 15f; // if this thing hits zero, we dead
    private float timerDecayRate = 1f/60f; // how fast the thing ticks down

    // Hover text: +5, -10, "BONUS +5!" ect..
    private float hoverTextHeight;
    private color hoverTextColor;
    private String hoverText = "";
    private color COLOR_BONUS, COLOR_BAD;

    public Gamestate() {
        super(0,0,null);
        colorMode( RGB );
        COLOR_BONUS = color( 0, 255, 0 );
        COLOR_BAD = color( 255, 0, 0 );
    }

    @Override
    public void update() {
        masterTimer -= timerDecayRate;
        hoverTextHeight -= 0.02f;
        if (hoverTextHeight < 0) hoverTextHeight = 0;
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

    @Override
    public void renderGUI() {
        colorMode( RGB );
        textSize(40);
        fill( color( 255, 255, 0) );
        text( Integer.toString( (int) masterTimer ), PORT_WIDTH / 2 - 16, 40 );

        textSize(45 * hoverTextHeight + 1);
        fill( hoverTextColor );
        text( hoverText, PORT_WIDTH / 2 + 16, 40 + 80*hoverTextHeight);
    }
}