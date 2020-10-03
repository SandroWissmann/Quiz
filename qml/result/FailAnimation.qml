import QtQuick 2.15
import QtQuick.Particles 2.15

ParticleSystem {
    id: particles
    anchors.fill: parent

    ImageParticle {
        id: smoke
        system: particles
        anchors.fill: parent
        groups: ["FireballSmoke", "FireSmoke"]
        source: "qrc:///ressources/images/glowdot.png"
        colorVariation: 0
        color: "#00111111"
    }
    ImageParticle {
        id: flame
        anchors.fill: parent
        system: particles
        groups: ["Fire", "FireballFlame"]
        source: "qrc:///ressources/images/glowdot.png"
        colorVariation: 0.1
        color: "#00ff400f"
    }

    Emitter {
        id: fire
        system: particles
        group: "Fire"

        y: parent.height
        width: parent.width

        emitRate: 350
        lifeSpan: 3500

        acceleration: PointDirection { y: -17; xVariation: 3 }
        velocity: PointDirection {xVariation: 3}

        size: 24
        sizeVariation: 8
        endSize: 4
    }

    TrailEmitter {
        id: fireSmoke
        group: "FireSmoke"
        system: particles
        follow: "Fire"
        width: root.width
        height: root.height - 68

        emitRatePerParticle: 1
        lifeSpan: 2000

        velocity: PointDirection {y:-17*6; yVariation: -17; xVariation: 3}
        acceleration: PointDirection {xVariation: 3}

        size: 36
        sizeVariation: 8
        endSize: 16
    }

    TrailEmitter {
        id: fireballFlame
        anchors.fill: parent
        system: particles
        group: "FireballFlame"
        follow: "Balls"

        emitRatePerParticle: 120
        lifeSpan: 180
        emitWidth: TrailEmitter.ParticleSize
        emitHeight: TrailEmitter.ParticleSize
        emitShape: EllipseShape{}

        size: 16
        sizeVariation: 4
        endSize: 4
    }

    TrailEmitter {
        id: fireballSmoke
        anchors.fill: parent
        system: particles
        group: "FireballSmoke"
        follow: "Balls"

        emitRatePerParticle: 128
        lifeSpan: 2400
        emitWidth: TrailEmitter.ParticleSize
        emitHeight: TrailEmitter.ParticleSize
        emitShape: EllipseShape{}

        velocity: PointDirection {yVariation: 16; xVariation: 16}
        acceleration: PointDirection {y: -16}

        size: 24
        sizeVariation: 8
        endSize: 8
    }

    Emitter {
        id: balls
        system: particles
        group: "Balls"

        y: parent.height
        width: parent.width

        emitRate: 2
        lifeSpan: 10000

        velocity: PointDirection {y:-17*4*2; xVariation: 6*6}
        acceleration: PointDirection {y: 17*2; xVariation: 6*6}

        size: 8
        sizeVariation: 4
    }

    Turbulence { //A bit of turbulence makes the smoke look better
        anchors.fill: parent
        groups: ["FireballSmoke","FireSmoke"]
        strength: 32
        system: particles
    }
}
