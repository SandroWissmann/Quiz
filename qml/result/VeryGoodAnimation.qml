import QtQuick 2.15
import QtQuick.Particles 2.15

ParticleSystem {
    anchors.fill: parent

    ImageParticle {
        groups: ["stars"]
        anchors.fill: parent
        source: "qrc:///ressources/images/star.png"
    }
    Emitter {
        group: "stars"
        emitRate: 800
        lifeSpan: 2400
        size: 24
        sizeVariation: 8
        anchors.fill: parent
    }
    Turbulence {
        anchors.fill: parent
        strength: 2
    }
}
