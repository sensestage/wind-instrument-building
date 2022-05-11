import grafica.*;

public class CIPlotter3Axes
{
  // The parent Processing applet
  protected final PApplet parent;
  
  GPlot plotLine;
  GPlot plot2D;
  int nPoints;
  GPointsArray[] pointsXYZ = new GPointsArray[3];
  GPointsArray[] points2D = new GPointsArray[3];

  int curIndex;
 
  public CIPlotter3Axes( PApplet parent, int nPoints )
  {
    this.nPoints = nPoints;
    this.parent = parent;
    this.curIndex = 0;

    this.initPoints();
  }
  
  public void setNPoints( int nPoints )
  {
    this.nPoints = nPoints;  
  }

  protected void initPoints(){
    for(int i = 0; i < pointsXYZ.length; i++){
      pointsXYZ[i] = new GPointsArray(nPoints);
    }
    for (int i = 0; i < nPoints; i++) {
      pointsXYZ[0].add(i,0);
      pointsXYZ[1].add(i,0);
      pointsXYZ[2].add(i,0);
    }
    for(int i = 0; i < points2D.length; i++){
      points2D[i] = new GPointsArray(nPoints);
    } 
  }
  
  public void initLinePlot( String title, int posx, int posy, int dimx, int dimy, String labelx, String labely ){
    // Create a new plot and set its position on the screen
    plotLine = new GPlot(this.parent);
    // Setup for the first plot
    plotLine.setPos(posx, posy);
    plotLine.setDim(dimx, dimy);
    plotLine.getTitle().setText( title );
    plotLine.getXAxis().getAxisLabel().setText(labelx);
    plotLine.getYAxis().getAxisLabel().setText(labely);

    plotLine.setPoints(pointsXYZ[0]);
    plotLine.setLineColor(color(200, 200, 255));
    plotLine.addLayer("layer 1", pointsXYZ[0]);
    plotLine.getLayer("layer 1").setLineColor(color(100, 200, 255));
    plotLine.addLayer("layer 2", pointsXYZ[1]);
    plotLine.getLayer("layer 2").setLineColor(color(100, 100, 255));
    plotLine.addLayer("layer 3", pointsXYZ[2]);
    plotLine.getLayer("layer 3").setLineColor(color(200, 100, 255));
    
    plotLine.activatePanning();
    plotLine.activateZooming(1.2, CENTER, CENTER);
    plotLine.activatePointLabels();
    
    plotLine.activateReset(RIGHT);

    plotLine.setBoxBgColor( color(50,50,50) );
    plotLine.setBgColor( color(50,50,50) );
    plotLine.setGridLineColor( color(100,100,100) );
    plotLine.setBoxLineColor( color(150,150,150) );
    plotLine.setFontColor( color(150,150,150) );
    plotLine.getXAxis().setFontColor( color(150,150,150) );
    plotLine.getXAxis().setLineColor( color(150,150,150) );
    plotLine.getYAxis().setFontColor( color(150,150,150) );
    plotLine.getYAxis().setLineColor( color(150,150,150) );
    plotLine.getXAxis().getAxisLabel().setFontColor( color(150,150,150) );
    plotLine.getYAxis().getAxisLabel().setFontColor( color(150,150,150) );


  }
  
  public void init2DPlot( String title, int posx, int posy, int dimx, int dimy, String labelx, String labely1 ){ // , String labely2
   // Setup for the second plot 
    plot2D = new GPlot(this.parent);
    plot2D.setPos(posx, posy);
    plot2D.setDim(dimx, dimy);
    plot2D.getTitle().setText(title);
    plot2D.getXAxis().getAxisLabel().setText(labelx);
    plot2D.getYAxis().getAxisLabel().setText(labely1);
    //plot2D.getRightAxis().setAxisLabelText(labely2);

    plot2D.addLayer("layer 1", points2D[0]);
    plot2D.addLayer("layer 2", points2D[1]);
    plot2D.addLayer("layer 3", points2D[2]);
    plot2D.getLayer("layer 1").setLineColor(color(100, 200, 255));
    plot2D.getLayer("layer 2").setLineColor(color(100, 100, 255));
    plot2D.getLayer("layer 3").setLineColor(color(200, 100, 255));
    
    plot2D.setBoxBgColor( color(50,50,50) );
    plot2D.setBgColor( color(50,50,50) );
    plot2D.setGridLineColor( color(100,100,100) );
    plot2D.setBoxLineColor( color(150,150,150) );
    plot2D.setFontColor( color(150,150,150) );
    plot2D.getXAxis().setFontColor( color(150,150,150) );
    plot2D.getYAxis().setFontColor( color(150,150,150) );
    plot2D.getXAxis().setLineColor( color(150,150,150) );
    plot2D.getYAxis().setLineColor( color(150,150,150) );
    plot2D.getXAxis().getAxisLabel().setFontColor( color(150,150,150) );
    plot2D.getYAxis().getAxisLabel().setFontColor( color(150,150,150) );
    
    plot2D.activateZooming(1.5);
    plot2D.activateReset(RIGHT);
  }
  
  public void updateLinePlot(){
      if ( pointsXYZ[0].getNPoints() > this.nPoints ){
        pointsXYZ[0].removeRange( 0, pointsXYZ[0].getNPoints()-this.nPoints );  
      }
    if ( pointsXYZ[1].getNPoints() > nPoints ){
      pointsXYZ[1].removeRange( 0, pointsXYZ[1].getNPoints()-this.nPoints );  
    }
    if ( pointsXYZ[2].getNPoints() > nPoints ){
      pointsXYZ[2].removeRange( 0, pointsXYZ[2].getNPoints()-this.nPoints );  
    }
    
    if ( curIndex > nPoints ){
      // shift points
      for ( int i=0; i<nPoints; i++ ){
        pointsXYZ[0].setX( i, i ); 
        pointsXYZ[1].setX( i, i );
        pointsXYZ[2].setX( i, i );
      }
    }

    plotLine.beginDraw();
    plotLine.drawBackground();
    plotLine.drawBox();
    plotLine.drawXAxis();
    plotLine.drawYAxis();
    //plotLine.drawTopAxis();
    //plotLine.drawRightAxis();
    plotLine.drawTitle();
    plotLine.setPoints( pointsXYZ[0], "layer 1" );
    plotLine.setPoints( pointsXYZ[1], "layer 2" );
    plotLine.setPoints( pointsXYZ[2], "layer 3" );
    plotLine.drawLines();
    plotLine.drawLabels();
    plotLine.endDraw();
  }
  
  public void update2DPlot(){
    float x = pointsXYZ[0].getLastPoint().getY();
    float y = pointsXYZ[1].getLastPoint().getY();
    float z = pointsXYZ[2].getLastPoint().getY();

    plot2D.addPoint( new GPoint(x,y), "layer 1");
    plot2D.addPoint( new GPoint(x,z), "layer 2");
    plot2D.addPoint( new GPoint(y,z), "layer 3");

    // Reset the points if the user pressed the space bar
    if (keyPressed && key == ' ') {
      plot2D.setPoints(new GPointsArray(), "layer 1");
      plot2D.setPoints(new GPointsArray(), "layer 2");
      plot2D.setPoints(new GPointsArray(), "layer 3");
    }
  
    // Draw the second plot  
    plot2D.beginDraw();
    plot2D.drawBackground();
    plot2D.drawBox();
    plot2D.drawXAxis();
    plot2D.drawYAxis();
    //plot2D.drawRightAxis();
    plot2D.drawTitle();
    plot2D.drawGridLines(GPlot.BOTH);
    plot2D.drawLines();
    plot2D.endDraw();    
  }
  
  public void setLimits( float minx, float maxx, float miny, float maxy ){
    plotLine.setXLim(minx, maxx);
    plotLine.setYLim(miny, maxy);
  }

  public void setYLimits( float miny, float maxy ){
    plotLine.setYLim(miny, maxy);
  }

  public void addPoint( float x, float y, float z )
  {
      pointsXYZ[0].add( curIndex%nPoints, x );
      pointsXYZ[1].add( curIndex%nPoints, y );
      pointsXYZ[2].add( curIndex%nPoints, z );
      this.curIndex++;
  }
  
}
