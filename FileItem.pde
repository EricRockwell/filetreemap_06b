// Code from Visualizing Data, First Edition, Copyright 2008 Ben Fry.


class FileItem extends SimpleMapItem {
  FolderItem parent;    
  File file;
  String name;
  int level;
  PImage photo;
  color c;
  float hue;
  float brightness;
  String path; 
  float textPadding = 8;
  String[] filenames;
  String [] text;
  PImage[] photos;
  float boxLeft, boxTop;
  float boxRight, boxBottom;


  FileItem(FolderItem parent, File file, int level, int order) {
    this.parent = parent;
    this.file = file;
    this.order = order;
    this.level = level;
      
    name = file.getName();
    size = file.length();

    modTimes.add(file.lastModified());
  }

  
  void updateColors() {
    if (parent != null) {
      hue = map(order, 0, parent.getItemCount(), 0, 360);
    }
    brightness = modTimes.percentile(file.lastModified()) * 100;

    colorMode(HSB, 360, 100, 100);
    if (parent == zoomItem) {
      c = color(hue, 80, 80);
    } else if (parent != null) {
      c = color(parent.hue, 80, brightness);
    }
    colorMode(RGB, 255);
  }
  
  
  void calcBox() {
    boxLeft = zoomBounds.spanX(x, 0, width);
    boxRight = zoomBounds.spanX(x+w, 0, width);
    boxTop = zoomBounds.spanY(y, 0, height);
    boxBottom = zoomBounds.spanY(y+h, 0, height);
  }


  void draw() {
    calcBox();
    path = file.getAbsolutePath();
    fill(c);
    rect(boxLeft, boxTop, boxRight, boxBottom);

    if (textFits()) {
      drawTitle();
    } else if (mouseInside()) {
      rolloverItem = this;
    }

     
     
      if(path.contains(".jpg") || path.contains(".gif") ||path.contains(".png")) {
             //photo.resize(boxRight-boxLeft,boxBottom-boxTop);
             photo = loadImage(path);
             tint(255, 127);
             image(photo,boxLeft,boxTop,(boxRight-boxLeft)/1,(boxBottom-boxTop)/1);
             photo = null;
          }
    if(path.contains(".txt") || path.contains(".CFG")) {
             //photo.resize(boxRight-boxLeft,boxBottom-boxTop);
             text = loadStrings(path);
             tint(255, 127);
               for(int i=0; i<text.length;i++) {
                 if(textFits(text[i])==true){ 
                 text(text[i],boxLeft,boxTop);
                 boxTop+=12;
                 }
               }
             
          }
      
        
     
    
    
   }
    
    
  void drawTitle() {
    fill(255, 200);
    
    float middleX = (boxLeft + boxRight) / 2;
    float middleY = (boxTop + boxBottom) / 2;
    if (middleX > 0 && middleX < width && middleY > 0 && middleY < height) {
      if (boxLeft + textWidth(name) + textPadding*2 > width) {
        textAlign(RIGHT);
        text(name, width - textPadding, boxBottom - textPadding);
      } else {
        textAlign(LEFT);
        text(name, boxLeft + textPadding, boxBottom - textPadding);
      }
    }
  }


  boolean textFits() {
    float wide = textWidth(name) + textPadding*2;
    float high = textAscent() + textDescent() + textPadding*2;
    return (boxRight - boxLeft > wide) && (boxBottom - boxTop > high); 
  }
     boolean textFits(String name) {
       
    float wide = textWidth(name) + textPadding*2;
    float high = textAscent() + textDescent() + textPadding*2;
    return (boxRight - boxLeft > wide) && (boxBottom - boxTop > high); 
  }
    
 
  boolean mouseInside() {
    return (mouseX > boxLeft && mouseX < boxRight && 
            mouseY > boxTop && mouseY < boxBottom);    
  }


  boolean mousePressed() {
    if (mouseInside()) {
      if (mouseButton == LEFT) {
        parent.zoomIn();
        open(path);
        return true;

      } else if (mouseButton == RIGHT) {
        if (parent == zoomItem) {
          parent.zoomOut();
        } else {
          parent.hideContents();
        }
        return true;
      }
    }
    return false;
  }
}
