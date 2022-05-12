import grafica.*;

public class CIPlotter4
{
  // The parent Processing applet
  protected final PApplet parent;
  
  GPlot plotLine;
  int nPoints;
  GPointsArray[] points = new GPointsArray[4];

  int curIndex;
 
  public CIPlotter4( PApplet parent, int nPoints )
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
    for(int i = 0; i < points.length; i++){
      points[i] = new GPointsArray(nPoints);
    }
    for (int i = 0; i < nPoints; i++) {
      points[0].add(i,0);
      points[1].add(i,0);
      points[2].add(i,0);
      points[3].add(i,0);
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

//    plotLine.setPoints(points);
    plotLine.setLineColor(color(200, 200, 255));
    
    
    plotLine.addLayer("layer 1", points[0]);
    plotLine.getLayer("layer 1").setLineColor(color(100, 100, 255));
    plotLine.addLayer("layer 2", points[1]);
    plotLine.getLayer("layer 2").setLineColor(color(200, 200, 255));
    plotLine.addLayer("layer 3", points[2]);
    plotLine.getLayer("layer 3").setLineColor(color(200, 200, 255));
    plotLine.addLayer("layer 4", points[3]);
    plotLine.getLayer("layer 4").setLineColor(color(200, 200, 255));

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
    
  public void updateLinePlot(){
    if ( points[0].getNPoints() > this.nPoints ){
      points[0].removeRange( 0, points[0].getNPoints()-this.nPoints );  
    }
    if ( points[1].getNPoints() > this.nPoints ){
      points[1].removeRange( 0, points[1].getNPoints()-this.nPoints );  
    }
    if ( points[2].getNPoints() > this.nPoints ){
      points[2].removeRange( 0, points[2].getNPoints()-this.nPoints );  
    }
    if ( points[3].getNPoints() > this.nPoints ){
      points[3].removeRange( 0, points[3].getNPoints()-this.nPoints );  
    }
    
    if ( curIndex > nPoints ){
      // shift points
      for ( int i=0; i<nPoints; i++ ){
        points[0].setX( i, i ); 
        points[1].setX( i, i );
        points[2].setX( i, i );
        points[3].setX( i, i );
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
    plotLine.setPoints( points[0], "layer 1" );
    plotLine.setPoints( points[1], "layer 2" );
    plotLine.setPoints( points[2], "layer 3" );
    plotLine.setPoints( points[3], "layer 4" );
    plotLine.drawLines();
    plotLine.drawLabels();
    plotLine.endDraw();
  }
  
  public void setLimits( float minx, float maxx, float miny, float maxy ){
    plotLine.setXLim(minx, maxx);
    plotLine.setYLim(miny, maxy);
  }

  public void setYLimits( float miny, float maxy ){
    plotLine.setYLim(miny, maxy);
  }
  
  public void addPoints( float value, float val2, float val3, float val4 )
  {
      points[0].add( curIndex%nPoints, value );
      points[1].add( curIndex%nPoints, val2 );
      points[2].add( curIndex%nPoints, val3 );
      points[3].add( curIndex%nPoints, val4 );
      this.curIndex++;
  }
  
  public void addPoint( float value, int layer )
  {
      points[layer].add( curIndex%nPoints, value );
      this.curIndex++;
  }
  
}
