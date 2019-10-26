import javax.swing.*;
import java.awt.*;

public class DisplayGUI
{
  public DisplayGUI(String text) //constructor of the DisplayGuiHelp object that has the list passed to it on creation
  {
    final JFrame theFrame = new JFrame();
    theFrame.setTitle("Instructions");
    theFrame.setSize(500, 500);
    theFrame.setLocation(750, 400);

    JPanel mainPanel = new JPanel();

    JTextArea theText = new JTextArea(5,5); //create the text area
    //theText.setAlignmentY(Component.CENTER_ALIGNMENT);
    theText.setTabSize(2);
    //static final TextComponent theText = TextComponent.getAccessibleContext();
    theText.append(text); //append the contents of the array list to the text area

    mainPanel.add(theText); //add the text area to the panel

    theFrame.getContentPane().add(mainPanel); //add the panel to the frame
    theFrame.pack();
    theFrame.setVisible(true);

  }
}
