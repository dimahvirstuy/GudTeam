/***********
 * GameObjectHandler.
 * Stores GameObjects, iterates through them each frame
 * to update and render
 ***********/

import java.util.LinkedList;
import java.util.ArrayList;
import java.util.ListIterator;
import java.util.Comparator;

public class GameObjectHandler {
    // Linked list because
    // we want to add fast and we iterate each frame
    // (ArrayList gives no advantage for iterating
    // but is worse for adding)
    private LinkedList<GameObject> objects;

    private ListIterator<GameObject> masterIterator;

    // Maps object class to linkedlists of gameObjects
    private HashMap<Class, LinkedList<GameObject>> objectsByClass;

    // ArrayList of objects by tag
    // Possible because the types of tags are static
    private ArrayList<LinkedList<GameObject>> objectsByTag;

    // For physics objects with collisions
    private QuadTree collisionTree;

    // For ease of access
    public Player player;

    public GameObjectHandler() {
        objects = new LinkedList<GameObject>();
        objectsByClass = new HashMap<Class, LinkedList<GameObject>>();
        objectsByTag = new ArrayList< LinkedList<GameObject> >();
        for(int i = 0; i < OBJECT_TAG.values().length; i++) {
            objectsByTag.add( new LinkedList<GameObject>() );
        }

        collisionTree = new QuadTree(new Rectangle(PORT_WIDTH, PORT_HEIGHT));
    }

    public void addObject(GameObject obj) {
        if (masterIterator == null)
            objects.add(obj);
        else
            masterIterator.add(obj);
    }

    // Master tick, goes through all obects
    // You control whether to update, render or do both for ALL objects
    public void loopAll(boolean update, boolean render) {

        HashMap<Class, LinkedList<GameObject>> newObjectsByClass = null;
        ArrayList<LinkedList<GameObject>> newObjectsByTag = null;

        // Create empty containers
        newObjectsByClass = new HashMap<Class, LinkedList<GameObject>>();
        newObjectsByTag = new ArrayList<LinkedList<GameObject>>();
        for(int i = 0; i < OBJECT_TAG.values().length; i++) {
            newObjectsByTag.add( new LinkedList<GameObject>() );
        }
        
        

        // Create LinkedList storing collision objects ONLY to prevent redundant scrolling
        //LinkedList<GameObjectPhysics> allCollisionObjects = new LinkedList<GameObjectPhysics>();
        // Reset collision quadtree
        collisionTree.clear();

        objects.sort( new DrawOrderComparator() );

        // Loop through once to add objects to collision tree
        for( GameObject obj : objects ) {
            if (obj instanceof GameObjectPhysics) {
                GameObjectPhysics realObj = (GameObjectPhysics) obj;
                // If not static then insert straight away.
                // If static then check for if we're already inserted
                if (!realObj.isStatic || ( !realObj.isInTree() ) ) {
                    collisionTree.insert( (GameObjectPhysics) obj );
                }
            }
        }

        masterIterator = objects.listIterator();
        while(masterIterator.hasNext()) {
           GameObject obj = masterIterator.next();
           // If should destroy, destroy
           // and skip this one
           if (obj.shouldDestroy()) {
               masterIterator.remove();
               continue;
           }
           if (update) {
               // Add to lists mapping by class and tag
               Class objClass = obj.getClass();
               int tag = obj.tag.ordinal();

               if (!newObjectsByClass.containsKey(objClass)) {
                   newObjectsByClass.put( objClass, new LinkedList<GameObject>() );
               }
               newObjectsByClass.get(objClass).add(obj); 

               if (newObjectsByTag.get(tag) == null) {
                   newObjectsByTag.set( tag, new LinkedList<GameObject>() );
               }
               newObjectsByTag.get(tag).add(obj);

              if (render) {
                   /// Translate for gui
                   pushMatrix();
                   translate(camera.xPos, camera.yPos);
                   scale( camera.viewWidth / PORT_WIDTH, camera.viewHeight / PORT_HEIGHT );
                   obj.renderGUI();
                   popMatrix();
              }
               // ALso update
               obj.update();
           }
           if (render) {
               if (obj.visible) {
                   obj.render();
               }
           }
        }

        /*if (update) {
            // update objectsByClass Map
            objectsByClass = newObjectsByClass;
            objectsByTag = newObjectsByTag;
        }*/
    }

    // Get list of objects by class
    public LinkedList<GameObject> getObjectsByClass(Class findClass) {
        if (objectsByClass.containsKey(findClass)) {
            return objectsByClass.get(findClass); 
        } else {
            return null; 
        }
    }

    // Get list of objects by tag
    public LinkedList<GameObject> getObjectsByTag(OBJECT_TAG tag) {
        int index = tag.ordinal();
        if (objectsByTag.size() <= index) {
            return null;
        }
        return objectsByTag.get(index);
    }

    // Collision function wrapper. Give rect and ignore object and offset, get all collisions with that rectangle excluding the ignoreObject
    public LinkedList<GameObjectPhysics> getCollisions(Rectangle checkRect, GameObjectPhysics ignoreObj) {
        return collisionTree.getCollisions( checkRect, ignoreObj);
    }

    public LinkedList<GameObjectPhysics> getCollisions(GameObjectPhysics obj, float offsetX, float offsetY) {
        return collisionTree.getCollisions( obj, offsetX, offsetY );
    }

    // Collision function wrapper. Give a rectanlge and get all objects colliding with it
    public LinkedList<GameObjectPhysics> getCollisions(Rectangle checkRect) {
        return collisionTree.getCollisions( checkRect );
    }

    // isColliding function wrapper
    public boolean isColliding(GameObjectPhysics obj, float offsetX, float offsetY, Class type) {
        return collisionTree.isColliding( obj, offsetX, offsetY, type );
    }

    // Collision function wrapper. Do the two objects collide with each other?
    public boolean doObjectsCollide(GameObjectPhysics obj1, GameObjectPhysics obj2, float offsetX, float offsetY) {
        return collisionTree.doObjectsCollide( obj1, obj2, offsetX, offsetY );
    }


    // Get total number of objects
    public int getObjectCount() {
        return objects.size();
    }

    // Comparator class used to compare objects based on their draw order / depth.
    private class DrawOrderComparator implements Comparator<GameObject> {
        public int compare( GameObject obj1, GameObject obj2) {
            return (int)Math.signum( obj1.drawOrder - obj2.drawOrder ); 
        }
    }
}