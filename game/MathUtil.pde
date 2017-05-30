/**********
 * MathUtil
 * useful math functions
 *********/

public static class MathUtil {

    public static double getAngleDifference(double angle1, double angle2) {
        double phi = angle2%(Math.PI*2) - angle1%(Math.PI*2);
        phi = (Math.abs(phi) > Math.PI ? -(Math.signum(phi) * Math.PI*2 - phi) : phi);
        return phi;
    }

}