import QtQuick
import QtQuick.Layouts

Flickable {
    // default experimental values
    property var values: [25, 26, 28, 27, 25, 23]
    property string valueSuffix: "°"
    property int perValueWidth: 60
    property var topLabelWeatherCodes: []
    property var bottomLabels: ["NOW", "2pm", "3pm", "4pm", "5pm", "6pm"]
    property int outerCircleRadii: 7
    property bool outerCircleAnimation: true

    property int valueCount: Math.max(10, root.width / root.perValueWidth)

    // this animation causes like 0.5% cpu constantly, use outerCircleAnimation to enable/disable
    NumberAnimation on outerCircleRadii {
        from: 0
        to: 7
        duration: 1500
        loops: Animation.Infinite
        running: root.outerCircleAnimation
    }
    onOuterCircleRadiiChanged: canvas.requestPaint()

    id: root
    contentWidth: canvas.width // required for making Canvas Flickable
    clip: true

    Canvas {
        id: canvas
        antialiasing: true
        height: root.height
        width: root.valueCount * perValueWidth + 20

        onPaint: function() {
            if (!values?.length) return

            const ctx = getContext("2d")
            ctx.clearRect(0, 0, root.width, root.height)
            ctx.reset()

            let minPoint = values[0], maxPoint = values[0];
            values.forEach(function(v) {
                minPoint = Math.min(minPoint, v)
                maxPoint = Math.max(maxPoint, v)
            })

            const minHeight = 100
            let perPointHeight = (root.height - minHeight) / (maxPoint - minPoint)

            // dashed line
            ctx.setLineDash([10, 3, 3, 3])
            ctx.strokeStyle = AppState.color?.text3
            ctx.lineWidth = 2

            let getX = (i) => 30 + i * perValueWidth
            let getY = (i) => 45 + (root.height - minHeight) - (values[i] - minPoint) * perPointHeight

            ctx.beginPath()
            ctx.moveTo(getX(0), getY(0))
            for (let i = 1; i < root.valueCount; i++) {
                let x = getX(i), y = getY(i)
                let px = getX(i - 1), py = getY(i - 1)
                ctx.bezierCurveTo((px + x) / 2, py, (px + x) / 2, y, x, y)
            }
            ctx.stroke()

            // dots
            ctx.setLineDash([])
            ctx.font = "16px sans-serif"
            for (let j = 0; j < root.valueCount; j++) {
                let x = getX(j), y = getY(j)

                ctx.beginPath()
                ctx.arc(x, y, 2.8, 0, 2 * Math.PI)
                ctx.fillStyle = AppState.color?.text2
                ctx.fill()

                // outer circle
                if (j == 0) {
                    ctx.strokeStyle = AppState.color?.text1
                    ctx.beginPath()
                    ctx.arc(x, y, root.outerCircleRadii, 0, 2 * Math.PI)
                    ctx.stroke()
                }

                // inner circle
                ctx.moveTo(x, y + 5)
                ctx.lineWidth = 0.3
                ctx.strokeStyle = AppState.color?.text3
                ctx.lineTo(x, root.height - 30)
                ctx.stroke()

                // draw point label and bottom label
                ctx.fillStyle = AppState.color?.text1
                ctx.fillText(values[j] + root.valueSuffix, x + 5, y - 10)
                ctx.fillText(bottomLabels[j], x - 10, root.height - 10)

                // draw weather icons according to weather code
                // skip first point
                if (j != 0) {
                    AppState.tempWeatherCode = topLabelWeatherCodes[j] || 0
                    ctx.drawImage("../" + AppState.tempWeatherIcon, x, y - 45, 24, 24)
                }
            }
        }
    }
}