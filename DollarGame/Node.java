import java.util.*;

public class Node {
    public ArrayList<Node> connections = new ArrayList<>();
    public int money;
    public boolean displayed = false;
    public int x;
    public int y;
    public static int total = 0;
    //public ArrayList<Float> angles = new ArrayList<>();

    public Node(int money) {
        this.money = money;
        total += money;
    }
}
