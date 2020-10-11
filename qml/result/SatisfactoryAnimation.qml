import QtQuick.Particles 2.15
import QtQuick 2.15

ParticleSystem {
    id: particles
    anchors.fill: parent

    ImageParticle {
        system: particles
        colorVariation: 0.5
        alpha: 0

        source: "qrc:///ressources/images/glowdot.png"
    }

    Emitter {
        system: particles
        emitRate: 500
        lifeSpan: 2000

        y: root.height / 2 + Math.sin(t * 2) * root.height * 0.3
        x: root.width / 2 + Math.cos(t) * root.width * 0.3
        property real t

        NumberAnimation on t {
            from: 0
            to: Math.PI * 2
            duration: 10000
            loops: Animation.Infinite
        }

        velocityFromMovement: 20

        velocity: PointDirection {
            xVariation: 5
            yVariation: 5
        }
        acceleration: PointDirection {
            xVariation: 5
            yVariation: 5
        }

        size: 16
        endSize: 8
        sizeVariation: 8
    }
}
