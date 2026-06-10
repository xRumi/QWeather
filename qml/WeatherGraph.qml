import QtQuick
import QtQuick.Layouts

Canvas {
    // default experimental values
    property var points: [25, 26, 28, 27, 25, 23]
    property string pointSuffix: "°"
    property int pointSpace: 60
    property int pointMinHeight: 100
    property var pointTopWeatherCodes: []
    property var pointBottomLabels: ["NOW", "2pm", "3pm", "4pm", "5pm", "6pm"]
    property int pointOuterCircleRadii: 7
    property bool pointerOuterCircleAnimation: true

    // this animation causes like 0.5% cpu constantly, use pointerOuterCircleAnimation to enable/disable
    NumberAnimation on pointOuterCircleRadii {
        from: 0
        to: 7
        duration: 1500
        loops: Animation.Infinite
        running: root.pointerOuterCircleAnimation
    }
    onPointOuterCircleRadiiChanged: requestPaint()

    id: root
    antialiasing: true

    onPaint: function() {
        if (!points?.length) return

        const ctx = getContext("2d")
        ctx.clearRect(0, 0, root.width, root.height)
        ctx.reset()

        let minPoint = points[0], maxPoint = points[0];
        points.forEach(function(v) {
            minPoint = Math.min(minPoint, v)
            maxPoint = Math.max(maxPoint, v)
        })

        let perPointHeight = (root.height - pointMinHeight) / (maxPoint - minPoint)
        let n = Math.min(Math.max(width / pointSpace + 1, 0), points.length)

        // dashed line
        ctx.setLineDash([10, 3, 3, 3])
        ctx.strokeStyle = AppTheme.color?.text3
        ctx.lineWidth = 2

        let getX = (i) => 10 + i * pointSpace
        let getY = (i) => 45 + (root.height - pointMinHeight) - (points[i] - minPoint) * perPointHeight

        ctx.beginPath()
        ctx.moveTo(getX(0), getY(0))
        for (let i = 1; i < n; i++) {
            let x = getX(i), y = getY(i)
            let px = getX(i - 1), py = getY(i - 1)
            ctx.bezierCurveTo((px + x) / 2, py, (px + x) / 2, y, x, y)
        }
        ctx.stroke()

        // dots
        ctx.setLineDash([])
        ctx.font = "16px sans-serif"
        for (let j = 0; j < n; j++) {
            let x = getX(j), y = getY(j)

            ctx.beginPath()
            ctx.arc(x, y, 2.8, 0, 2 * Math.PI)
            ctx.fillStyle = AppTheme.color?.text2
            ctx.fill()

            // outer circle
            if (j == 0) {
                ctx.strokeStyle = AppTheme.color?.text1
                ctx.beginPath()
                ctx.arc(x, y, root.pointOuterCircleRadii, 0, 2 * Math.PI)
                ctx.stroke()
            }

            // inner circle
            ctx.moveTo(x, y + 5)
            ctx.lineWidth = 0.3
            ctx.strokeStyle = AppTheme.color?.text3
            ctx.lineTo(x, root.height - 30)
            ctx.stroke()

            // draw point label and bottom label
            ctx.fillStyle = AppTheme.color?.text1
            ctx.fillText(points[j] + root.pointSuffix, x + 5, y - 10)
            ctx.fillText(pointBottomLabels[j], x - 10, root.height - 10)

            // draw weather icons according to weather code
            // skip first point
            if (j != 0 && (AppTheme.tempWeatherCode = pointTopWeatherCodes[j] || 0) > 1)
                ctx.drawImage("../" + AppTheme.tempWeatherIcon, x, y - 45, 24, 24)
        }
    }
}