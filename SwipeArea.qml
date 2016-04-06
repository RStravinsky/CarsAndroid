import QtQuick 2.5

MouseArea {

    property var menu
    property point origin
    property string direction
    property bool isDrag: false
    property bool isFlick: false
    property var gestureStartTime;
    signal move(int x, int y)
    signal swipe()
    propagateComposedEvents: true

    onPressed: {
        //console.log("onPressed...")
        drag.axis = Drag.XAndYAxis
        origin = Qt.point(mouse.x, mouse.y)
        gestureStartTime = new Date();
        isFlick = false
    }

    onPositionChanged: {
        //console.log("onPositionChanged...")

        var now = new Date();
        var timeDiff = now - gestureStartTime;
        if(timeDiff > 500) isFlick = false // disable flick if moving

        handleFlick(mouse.x - origin.x)

        switch (drag.axis) {
        case Drag.XAndYAxis:
            if (Math.abs(mouse.x - origin.x) > 20) {
                drag.axis = Drag.XAxis
            }
            else if (Math.abs(mouse.y - origin.y) > 20) {
                drag.axis = Drag.YAxis
            }
            break
        case Drag.XAxis:
            if((mouse.x - origin.x > 0 && menu.currentIndex === 0) || (origin.x > 100 && menu.currentIndex === 1)) return;
            else {
                isDrag = true
                move(mouse.x - origin.x, 0)
            }
            break
        }
    }

    onReleased: {
        //console.log("onReleased..., flick = ", isFlick)
        switch (drag.axis) {
        case Drag.XAxis:
            if(isDrag === true) {
                //if(mouse.x - origin.x < 0) direction = "left"
                //else direction = "right"
                if( (Math.abs(mouse.x - origin.x) > (menu.width/2)) || isFlick === true)
                    swipe()
                else canceled(mouse)

                isDrag = false
                isFlick = false
            }
            break

        }
    }

    function handleFlick(xPosDiff){
          var now = new Date();
          var timeDiff = now - gestureStartTime;

          //high velocity and large diff between start end point
          if(timeDiff < 60 && Math.abs(xPosDiff) > 10){
                  //console.log("handleFlick ...")
                  isFlick = true
                  return true;
          }
          return false;
      }

} // MouseArea
