class SpatialGrid {
    
  float cellSize;
  int numCellsX, numCellsY;
  
  ArrayList<ArrayList<Bird>> cells;
  
  public SpatialGrid(float _cellSize) {
    this.cellSize = _cellSize;
    this.numCellsX = ceil(width/cellSize);
    this.numCellsY = ceil(height/cellSize);
    
    int numCellsTotal = numCellsX * numCellsY;
    cells = new ArrayList<ArrayList<Bird>>(numCellsTotal);
    for (int i=0; i<numCellsTotal; ++i) {
      cells.add(new ArrayList<Bird>());
    }
  }
  
  
}
