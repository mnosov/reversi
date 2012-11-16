import bb.cascades 1.0

Container {
    id: root
    property int borderSize: 1 //default value. Can be changed in parent qml
    property variant borderColor: Color.Black //default value. Can be changed in parent qml

    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Fill
    touchPropagationMode: TouchPropagationMode.None
    
    layout: DockLayout{}
    // TOP BORDER
    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        preferredHeight: root.borderSize
        background: root.borderColor
        verticalAlignment: VerticalAlignment.Top    
    }

    // BOTTOM BORDER
    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        preferredHeight: root.borderSize
        verticalAlignment: VerticalAlignment.Bottom
        background: root.borderColor
    }

    // LEFT BORDER
    Container {
        preferredWidth: root.borderSize
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Left
        background: root.borderColor
    }

    // RIGHT BORDER
    Container {
        preferredWidth: root.borderSize
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Right
        background: root.borderColor
    }
}