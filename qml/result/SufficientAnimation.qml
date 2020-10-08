import QtQuick 2.15
import QtQuick.Particles 2.15

ParticleSystem {
    id: particles
    anchors.fill: parent

    ImageParticle {
        id: flame
        anchors.fill: parent
        system: particles
        source: "qrc:///ressources/images/glowdot.png"
        colorVariation: 1.0
        color: "#00ff400f"
    }


    Emitter {
        id: balls
        system: particles

        y: parent.height
        width: parent.width

        emitRate: 100
        lifeSpan: 10000

        velocity: PointDirection {y:-17*4*3; xVariation: 6*6}
        acceleration: PointDirection {y: 17*2; xVariation: 6*6}

        size: 30
        sizeVariation: 4
    }
}

