import QtQuick 2.15
import QtQuick.Particles 2.15

ParticleSystem {
    id: particleSystem


    ImageParticle {
        source: "qrc:///ressources/images/glowdot.png"
        system: particleSystem
        color: "#FFD700"
        colorVariation: 0.2
        rotation: 0
        rotationVariation: 45
        rotationVelocityVariation: 15
        entryEffect: ImageParticle.Scale
    }

    Emitter {
        id: leftEmitter
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: 1; height: 20
        system: particleSystem
        emitRate: 20
        lifeSpan: 6400
        lifeSpanVariation: 400
        size: 32
        velocity: AngleDirection {
            angle: 0
            angleVariation: 15
            magnitude: 100
            magnitudeVariation: 50
        }
    }

    Emitter {
        id: rightEmitter
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: 1; height: 20
        system: particleSystem
        emitRate: 20
        lifeSpan: 6400
        lifeSpanVariation: 400
        size: 32
        velocity: AngleDirection {
            angle: 180
            angleVariation: 15
            magnitude: 100
            magnitudeVariation: 50
        }
    }

}
