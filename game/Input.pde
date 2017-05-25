/**************
 * Handles input
 * Cause I don't like the way processing handles input
 *************/

static class Input {

    private static boolean[] keyPress = new boolean[500];
    private static boolean[] lastKeyPress = new boolean[500];

    //private static ArrayList<Boolean> keyPress = new ArrayList<Boolean>();
    //private static ArrayList<Boolean> lastKeyPress = new ArrayList<Boolean>();

    // Must call at the end of every frame
    public static void updatePostTick() {
        // empty out keyPress to only be false
        for(int i = 0; i < keyPress.length; i++) {
            lastKeyPress[i] = keyPress[i];  
            //keyPress[i] = false;
        }
    }

    // Update key press array for a particular keycode.
    // Must call inside one of Processing's special methods
    public static void updateKeyPress(int keyCode, boolean state) {
        if (keyCode > keyPress.length) {
            System.out.println("Ruh roh, the key " + keyCode + " is out of bounds for the keyPress Array of length " + keyPress.length);
            return;
        }
        keyPress[keyCode] = state;
    }

    // Returns whether the key is being held
    public static boolean keyPress(int keyCode) {
        if (keyCode > keyPress.length) {
            System.out.println("Ruh roh, the key " + keyCode + " is out of bounds for the keyPress Array of length " + keyPress.length);
            return false;
        }
        return keyPress[keyCode];
    }

    // Returns whether the key was just pressed
    public static boolean keyPressed(int keyCode) {
        if (keyCode > keyPress.length) {
            System.out.println("Ruh roh, the key " + keyCode + " is out of bounds for the keyPress Array of length " + keyPress.length);
            return false;
        }
        return keyPress[keyCode] && !lastKeyPress[keyCode];
    }

    // Returns whether the key was just realeased
    public static boolean keyReleased(int keyCode) {
        if (keyCode > keyPress.length) {
            System.out.println("Ruh roh, the key " + keyCode + " is out of bounds for the keyPress Array of length " + keyPress.length);
            return false;
        }
        return !keyPress[keyCode] && lastKeyPress[keyCode];
    }

}