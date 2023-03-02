/*
use public or private
 first click no mine
 */
import de.bezier.guido.*;
public final static int NUM_ROWS = 5;
public final static int NUM_COLS = 5;
public final static int NUM_MINES = (int)(Math.random()*2) + 6;
private MSButton[][] buttons = new MSButton[NUM_ROWS][NUM_COLS]; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  //assign an oject to the whole 2d array
  for (int i = 0; i < NUM_ROWS; i += 1) {
    for (int j = 0; j < NUM_COLS; j+= 1) {
      buttons[i][j] = new MSButton(i, j);
    }
  }
  setMines();
}
public void setMines()
{
  //your code
  //randomly generate mine and avoid repetition
  MSButton test;
  for (int i = 0; i < NUM_MINES; i += 1) {
    test = new MSButton((int)(Math.random()*(NUM_ROWS+1)), (int)(Math.random()*(NUM_COLS+1)));
    if (mines.contains(test) == false)
      mines.add(test);
    else
      i -= 1;
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
  //your code here
  return false;
}
float t = 0;
public void displayLosingMessage()
{
  //your code here
  //textSize(16);
  fill((float)(Math.abs(sin(t)*255)));
  text("You Lost", width/2 + width*cos(t)/8, height/2);
  t += PI/12;
}
public void displayWinningMessage()
{
  //your code here
}
public boolean isValid(int row, int col)
{
  //your code here
  if (row >= 0 && row <= NUM_ROWS - 1 && col >= 0 && col <= NUM_COLS - 1)
    return true;
  else
    return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  //your code here
  for (int i = -1; i <= 1; i += 1) {
    for (int j = -1; j <= 1; j += 1) {
      if (isValid(row + i, col + j) && mines.contains(buttons[row + i][col + j]))
        numMines += 1;
    }
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col;
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed ()
  {   
    if (mouseButton == LEFT && flagged == false){
      clicked = true;
      //safe but with other mines around
      if (countMines(myRow, myCol) > 0) {
        setLabel(countMines(myRow, myCol));
      }
      //mine detected
      else if (mines.contains(this)) {
        displayLosingMessage();
    }
    }
    //your code here
    //right button clicked and unclicked
    else if (mouseButton == RIGHT) {
      if (flagged == false & clicked == false) {
        flagged = true;
      } else if (flagged == true & clicked == false) {
        flagged = false;
      }
    }
    ////mine detected
    //else if (mines.contains(this)) {
    //  displayLosingMessage();
    //}
    ////safe but with other mines around
    //else if (countMines(myRow, myCol) > 0) {
    //  setLabel(countMines(myRow, myCol));
    //  //myLabel += countMines(myRow, myCol);
    //}
    //safe but without other mines around, so clear out nearby area
    for (int i = -1; i <= 1; i += 1) {
      for (int j = -1; j <= 1; j += 1) {
        buttons[myRow + i][myCol + j].mousePressed();
      }
    }
    buttons[myRow -1 ][myCol -1].mousePressed();
    buttons[myRow -1][myCol].mousePressed();
    buttons[myRow -1][myCol + 1].mousePressed();
  }
  public void draw ()
  {    
    if (flagged)
      fill(255, 255, 0);
    else if (/*clicked && */mines.contains(this) )
      fill(255, 0, 0);
    else if (clicked)
      fill(175, 175, 175);
    else
      fill(225, 225, 225);

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  //public boolean isFlagged()
  //{
  //    return flagged;
  //}
}
