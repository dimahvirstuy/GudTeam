/***********
 * QuadTree data type, stores and places objects into quadrant trees based on their collision bounds
 * To be used for collisions
 ***********/

import java.util.List;
import java.util.LinkedList;
import java.util.Iterator;
import java.util.ListIterator;

//import java.awt.Rectangle;

public class QuadTree {
    private static final int MAX_OBJECTS = 10;
    private static final int MAX_LEVELS = 10;

    private int level;
    private LinkedList<GameObjectPhysics> objects;
    public Rectangle bounds;
    private QuadTree[] nodes;

    public QuadTree(int level, Rectangle bounds) {
        this.level = level;
        this.bounds = bounds;
        nodes = new QuadTree[4];
        objects = new LinkedList<GameObjectPhysics>();
    }

    // Overloaded for ease of use outside of this class (where we don't care about levels)
    public QuadTree(Rectangle bounds) {
        this(0, bounds);
    }

    // Recursively clear the list and children AND offset our children
    private void clearOffset(int xOffset, int yOffset) {
        //OLD clear: objects.clear();
        // NEW clear:

        // Remove objects that are not static in the tree
        ListIterator<GameObjectPhysics> iter = objects.listIterator();
        while( iter.hasNext() ) {
            GameObjectPhysics obj = iter.next();
            // Remove if we need to destroy or if it's not static
            if (obj.shouldDestroy() || !obj.isStatic ) {
                iter.remove();
            }
        }

        // Move
        bounds.x += xOffset;
        bounds.y += yOffset;
        // Repeat for children
        if (isSplit()) {
            for(QuadTree tree : nodes) {
                tree.clearOffset(xOffset, yOffset);
            }
        }
    }

    // Standard clear. No offset
    public void clear() {
        clearOffset(0,0);
    }

    // Public clear. It also sets the center of this QuadTree
    public void clearAndSetCenter(int x, int y) {
        // Gets delta to our desired position, and moves to that position
        int dx = x - (int)bounds.getCenterX();
        int dy = y - (int)bounds.getCenterY();
        clearOffset(dx, dy);
    }

    // returns whether our quadTree has split
    public boolean isSplit() {
        return (nodes[0] != null);
    }

    // Splits tree into four child quadtrees
    public void split() {
        int subWidth = bounds.width / 2;
        int subHeight = bounds.height / 2;

        int x = bounds.x;
        int y = bounds.y;

        nodes[0] = new QuadTree(level+1, new Rectangle(x,y,subWidth,subHeight));
        nodes[1] = new QuadTree(level+1, new Rectangle(x+subWidth,y,subWidth,subHeight));
        nodes[2] = new QuadTree(level+1, new Rectangle(x,y+subHeight,subWidth,subHeight));
        nodes[3] = new QuadTree(level+1, new Rectangle(x+subWidth,y+subHeight,subWidth,subHeight));
    }

    // -1: left. 0: In the middle. 1: right
    private int getHorizontalQuadrantIndex(Rectangle check) {
        int midX = bounds.x + bounds.width / 2;

        // If the check Rectangle fits within left quadrants        
        boolean leftQuadrant = (check.x < midX && check.x + check.width < midX);
        // If the check Rectangle fits within bottom quadrants
        boolean rightQuadrant = (check.x >= midX);

        return ( (rightQuadrant ? 1 : 0) + (leftQuadrant ? -1 : 0) );
    }

    // -1: top. 0: In the middle. 1: bottom
    private int getVerticalQuadrantIndex(Rectangle check) {
        int midY = bounds.y + bounds.height / 2;

        // If the check Rectangle fits within top quadrants
        boolean topQuadrant = (check.y < midY && check.y + check.height < midY);
        // If the check Rectangle fits within bottom quadrants
        boolean bottomQuadrant = (check.y >= midY);

        return ( (bottomQuadrant ? 1 : 0) + (topQuadrant ? -1 : 0) );
    }


    // Helper method: Figures out which index from nodes[] a check Rectangle belongs into
    private int getIndex(Rectangle check) {

        int vQuad = getVerticalQuadrantIndex( check );
        int hQuad = getHorizontalQuadrantIndex( check );

        if (hQuad == 1) { // right
            if (vQuad == -1) { // top
                return 1;
            } else if (vQuad == 1) { // bottom
                return 3;
            }
        } else if (hQuad == -1) { // left
            if (vQuad == -1) { // top
                return 0;
            } else if (vQuad == 1) { // bottom
                return 2;
            }
        }
        return -1;
        // Midpoints for quadrants. The point (midX, midY) is in the center of our parent quadrant.
        /*int midX = bounds.x + bounds.width / 2;
        int midY = bounds.y + bounds.height / 2;

        // If the check Rectangle fits within top quadrants
        boolean topQuadrant = (check.y < midY && check.y + check.height < midY);
        // If the check Rectangle fits within bottom quadrants
        boolean bottomQuadrant = (check.y >= midY);
        // If the check Rectangle fits within left quadrants
        boolean leftQuadrant = (check.x < midX && check.x + check.width < midX);
        // If the check Rectangle fits within right quadrants
        boolean rightQuadrant = (check.x >= midX);
-
        if (leftQuadrant) {
            if (topQuadrant) {
                return 1; 
            } else if (bottomQuadrant) {
                return 2;
            }
        } else if (rightQuadrant) {
            if (topQuadrant) {
                return 0;
            } else if (bottomQuadrant) {
                return 3;
            }
        }
        return -1;*/
    }

    // Master insert method!
    public void insert(GameObjectPhysics obj) {
        // Check if we should go down to children and add there instead

        obj.setInTree();

        if (isSplit()) {
            int index = getIndex( obj.getActualCollisionBox() );
            if (index != -1) {
                nodes[index].insert(obj);
                return;
            }
        }

        objects.add(obj);
        // If we've reached our Max Objects limit and need to redistribute
        if (objects.size() > MAX_OBJECTS && level < MAX_LEVELS) {
            // Ensure we've split
            if ( ! isSplit()) {
                split();
            }

            // Go through all objects and put them into the quadrant nodes
            ListIterator<GameObjectPhysics> iter = objects.listIterator();
            while( iter.hasNext() ) {
                GameObjectPhysics currentObj = iter.next();
                /*Rectangle actualRect = new Rectangle(
                    (int)currentObj.x + currentObj.collisionBox.x,
                    (int)currentObj.x + currentObj.collisionBox.x,
                    currentObj.collisionBox.width,
                    currentObj.collisionBox.height);
                */
                int index = getIndex( currentObj.getActualCollisionBox() );//currentObj.collisionBox);
                if (index != -1) {
                    nodes[index].insert(currentObj);
                    iter.remove();
                }
            }
            /*
            Old method, assuming we're dealing with ArrayList
            int i = 0;
            while(i < objects.size()) {
                int index = getIndex(obj.collisionBox);
                if (index != -1) {
                    nodes[index].insert(objects.remove(i));
                } else {
                    i++;
                }
            }
            */
        }
    }

    // Returns all objects that can potentially collide with the given object
    // NOT USED yet
    /*public void getPotentialCollisions(LinkedList<GameObjectPhysics> result, GameObjectPhysics obj) {
        int index = getIndex( obj.getActualCollisionBox() );
        if ( index != -1 && isSplit() ) {
            nodes[index].getPotentialCollisions(result, obj);
        }
        result.addAll(objects);
    }*/
    
    // Iterates through entire tree and for each node, doing collision checks for all objects within that node
    // AVOID USING THIS FOR NOW. You really don't need to go through ALL collision objects each frame
    /*public void scanThroughEverythingAndDoCollisions() {
        // Loop through all objects and get sub collisions for each object (looping again).
        // Yes this is n^2 but it's blocked so it's really log( n^2 ) and therefore 2log(n). Math bitches
        for(GameObjectPhysics obj : objects) {
            LinkedList<GameObjectPhysics> currentCollisions = new LinkedList<GameObjectPhysics>();
            updateObjectCollisions( currentCollisions, obj );
            obj.setCollisions(currentCollisions);
        }
        // Recursively do the same for children
        if ( isSplit() ) {
            for(QuadTree node : nodes) {
                node.scanThroughEverythingAndDoCollisions();
            }
        }
    }*/

    // Wrapper: Only give an object and get collisions with it
    public LinkedList<GameObjectPhysics> getCollisions(GameObjectPhysics obj, float offsetX, float offsetY) {
        return getCollisions( obj.getActualCollisionBox(offsetX, offsetY), obj);
    }

    // Wrapper: Only give a rectanlge and get all objects colliding with it
    public LinkedList<GameObjectPhysics> getCollisions(Rectangle checkRect) {
        return getCollisions( checkRect, null);
    }

    // Public method to get all objects colliding with a given rect and its offset, ignoring a given object
    public LinkedList<GameObjectPhysics> getCollisions(Rectangle checkRect, GameObjectPhysics ignoreObj) {
        //Rectangle checkRect = obj.getActualCollisionBox(offsetX, offsetY);

        LinkedList<GameObjectPhysics> result = new LinkedList<GameObjectPhysics>();
        updateObjectCollisions(result, ignoreObj, checkRect);
        return result;
    }

    // Returns true whether an object of a class type is colliding.
    // This INCLUDES children of that type.
    public boolean isColliding(GameObjectPhysics obj, float offsetX, float offsetY, Class type) {
        LinkedList<GameObjectPhysics> objects = getCollisions( obj, offsetX, offsetY );
        Iterator<GameObjectPhysics> iter = objects.iterator();
        while( iter.hasNext() ) {
            // If the obj is of class "type" OR if it's a child of class "type"
            GameObjectPhysics check = iter.next();
            if ( check.getClass().isAssignableFrom( type ) ) {
                return true;
            }
        }
        return false;
    }

    // Update object collisions given an object and list
    private void updateObjectCollisions(LinkedList<GameObjectPhysics> updateList, GameObjectPhysics avoidObj, Rectangle checkRect) {
        int index = getIndex(checkRect);

        if ( isSplit() ) {
            if (index != -1) {
                nodes[index].updateObjectCollisions( updateList, avoidObj, checkRect );
            } else {
                // We know that ONE of these equals 0.
                // But one may not be 0, and we can cut our check time in half with this
                int vIndex = getVerticalQuadrantIndex( checkRect );
                int hIndex = getHorizontalQuadrantIndex( checkRect );
                if (vIndex == -1) { // top
                    nodes[0].updateObjectCollisions( updateList, avoidObj, checkRect );
                    nodes[1].updateObjectCollisions( updateList, avoidObj, checkRect );
                } else if (vIndex == 1) { // bottom
                    nodes[2].updateObjectCollisions( updateList, avoidObj, checkRect );
                    nodes[3].updateObjectCollisions( updateList, avoidObj, checkRect );
                } else if (hIndex == -1) { // left
                    nodes[0].updateObjectCollisions( updateList, avoidObj, checkRect );
                    nodes[2].updateObjectCollisions( updateList, avoidObj, checkRect );
                } else if (hIndex == 1) { // right
                    nodes[1].updateObjectCollisions( updateList, avoidObj, checkRect );
                    nodes[3].updateObjectCollisions( updateList, avoidObj, checkRect );
                } else { // Center
                    for(QuadTree node : nodes) {
                        node.updateObjectCollisions( updateList, avoidObj, checkRect );
                    }
                }
                // Otherwise we must chech everything in this quadrant... makes sense right, since we don't skip
                /*for(QuadTree node : nodes) {
                    node.updateObjectCollisions( updateList, avoidObj, checkRect );
                }*/
            }
        }
        // Go through all children 
        for(GameObjectPhysics child : objects) {
            // Don't collide with self
            if (child == avoidObj) continue;

            if ( isRectColliding( checkRect, child ) ) {
                updateList.add(child);
            }
        }
        /* Old algorithm: Literally bad. Brute forced it's way out of it, defeating the whole purpose.
        // Loop through all of our objects. 
        for(GameObjectPhysics child : objects) {
            // Don't collide with self
            if (child == avoidObj) continue;

            if ( isColliding( checkRect, child ) ) {
                updateList.add(child);
            }
        }
        // Recursively do the same for all parent nodes
        if ( isSplit() ) {
            for(QuadTree node : nodes) {
                node.updateObjectCollisions(updateList, avoidObj, checkRect);
            }
        }
        */
    }

    // Checks strictly collisions between 2 objects
    public boolean doObjectsCollide(GameObjectPhysics obj1, GameObjectPhysics obj2, float offsetX, float offsetY) {
        Rectangle checkRect = obj1.getActualCollisionBox(offsetX, offsetY);
        return isRectColliding(checkRect, obj2);
    }

    // Returns whether a rect collides with another objet
    public boolean isRectColliding(Rectangle check, GameObjectPhysics obj) {
        //Rectangle objRect = new Rectangle(obj.collisionBox.width, obj.collisionBox.height);
        //objRect.x += obj.x;
        //objRect.y += obj.y;
        return (check.intersects( obj.getActualCollisionBox() ));
    }

}