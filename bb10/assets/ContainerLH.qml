import bb.cascades 1.0

Container {
    id: root
    property int defaultWidth: constants.screenWidth
    property int defaultHeight: constants.screenHeight
    property int containerWidth: handler.layoutFrame.width <=0 ? defaultWidth: handler.layoutFrame.width
    property int containerHeight:  handler.layoutFrame.height <=0 ? defaultHeight: handler.layoutFrame.height
    property bool loaded: handler.layoutFrame.width > 0 && handler.layoutFrame.height > 0
    signal sizeChanged()
    attachedObjects: [
        LayoutUpdateHandler {
            id: handler
            onLayoutFrameChanged: {
                containerWidth = handler.layoutFrame.width <=0 ? defaultWidth: handler.layoutFrame.width
                containerHeight = handler.layoutFrame.height <=0 ? defaultHeight: handler.layoutFrame.height
                root.sizeChanged();
            }
        },
        Constants {
            id: constants
        }
    ]
}
