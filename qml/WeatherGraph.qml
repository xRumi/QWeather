import QtQuick
import xRumi.QWeather

Flickable {
    // default experimental valules
    property var yS: [25, 26, 28, 27, 25, 23]
    property var xS: ["NOW", "2pm", "3pm", "4pm", "5pm", "6pm"]
    property var weatherCodes: []
    property string ySuffix: "°"
    property int perXWidth: 60
    property int minYsCount: 10
    property int outerCircleMaxRadii: 7

    property int outerCircleRadii: 0
    property int ySCount: Math.min(yS.length, Math.max(root.minYsCount, root.width / root.perXWidth))

    // this animation causes like 0.5% cpu constantly
    property bool outerCircleAnimation: Qt.platform.os === "android" ? false : true
    NumberAnimation on outerCircleRadii {
        from: 0
        to: root.outerCircleMaxRadii
        duration: 1500
        loops: Animation.Infinite
        running: root.outerCircleAnimation
    }
    onOuterCircleRadiiChanged: canvas.requestPaint()
    onYSChanged: canvas.requestPaint()

    id: root
    contentWidth: canvas.width // required for making Canvas Flickable
    clip: true

    Canvas {
        id: canvas
        antialiasing: true
        height: root.height
        width: root.ySCount * root.perXWidth + 30

        onPaint: function() {
            if (!root.yS?.length) return

            const ctx = getContext("2d")
            ctx.clearRect(0, 0, root.width, root.height)
            ctx.reset()

            let minPoint = root.yS[0], maxPoint = root.yS[0];
            root.yS.forEach(function(v) {
                minPoint = Math.min(minPoint, v)
                maxPoint = Math.max(maxPoint, v)
            })

            if (minPoint === maxPoint) minPoint++;

            const minHeight = 100
            let perPointHeight = (root.height - minHeight) / (maxPoint - minPoint)

            // dashed line
            ctx.setLineDash([10, 3, 3, 3])
            ctx.strokeStyle = AppState.color?.text3
            ctx.lineWidth = 2

            let getX = (i) => 30 + i * root.perXWidth
            let getY = (i) => 45 + (root.height - minHeight) - (root.yS[i] - minPoint) * perPointHeight

            ctx.beginPath()
            ctx.moveTo(getX(0), getY(0))
            for (let i = 1; i < root.ySCount; i++) {
                let x = getX(i), y = getY(i)
                let px = getX(i - 1), py = getY(i - 1)
                ctx.bezierCurveTo((px + x) / 2, py, (px + x) / 2, y, x, y)
            }
            ctx.stroke()

            // dots
            ctx.setLineDash([])
            ctx.font = "16px sans-serif"
            for (let j = 0; j < root.ySCount; j++) {
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
                ctx.fillText(parseFloat(root.yS[j].toFixed(1)) + root.ySuffix, x + 5, y - 10)
                ctx.fillText(root.xS[j], x - 10, root.height - 10)

                // draw weather icons according to weather code
                // skip first point
                if (j != 0 && root.weatherCodes.length > 0) {
                    AppState.tempWeatherCode = root.weatherCodes[j] || 0
                    ctx.drawImage("../" + AppState.tempWeatherIcon, x, y - 45, 24, 24)
                }
            }
        }
    }
}