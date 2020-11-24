/* Quiz
 * Copyright (C) 2020  Sandro Wißmann
 *
 * Quiz is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Quiz is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Quiz If not, see <http://www.gnu.org/licenses/>.
 *
 * Web-Site: https://github.com/SandroWissmann/Quiz
 */
import QtQuick 2.0
import QtQuick.Particles 2.0

ParticleSystem {
    anchors.fill: parent
    id: syssy

    ImageParticle {
        groups: ["fire"]
        source: "qrc:///ressources/images/glowdot.png"
        entryEffect: ImageParticle.Scale
    }

    ImageParticle {
        groups: ["explode", "works"]
        source: "qrc:///ressources/images/glowdot.png"
        entryEffect: ImageParticle.Scale
        colorVariation: 1.0
    }

    ParticleGroup {
        name: "fire"
        duration: 4000
        durationVariation: 1000
        to: {
            "explode": 1
        }
        TrailEmitter {
            group: "works"
            emitRatePerParticle: 100
            lifeSpan: 1000
            maximumEmitted: 1200
            size: 8
            velocity: AngleDirection {
                angle: 270
                angleVariation: 45
                magnitude: 20
                magnitudeVariation: 20
            }
            acceleration: PointDirection {
                y: 100
                yVariation: 20
            }
        }
    }
    ParticleGroup {
        name: "explode"
        duration: 400
        to: {
            "dead": 1
        }
    }
    ParticleGroup {
        name: "dead"
        duration: 1000
        Affector {
            once: true
            onAffected: worksEmitter.burst(400, x, y)
        }
    }

    Timer {
        interval: 6000
        running: true
        triggeredOnStart: true
        repeat: true
        onTriggered: startingEmitter.pulse(100)
    }
    Emitter {
        id: startingEmitter
        group: "fire"
        width: parent.width
        y: parent.height
        enabled: false
        emitRate: 320
        lifeSpan: 6000
        acceleration: PointDirection {
            xVariation: 20
            yVariation: 30
        }
        velocity: PointDirection {
            y: -100
        }
        size: 32
    }

    Emitter {
        id: worksEmitter
        group: "works"
        enabled: false
        emitRate: 100
        lifeSpan: 1600
        maximumEmitted: 6400
        size: 8
        velocity: CumulativeDirection {
            PointDirection {
                y: -100
            }
            AngleDirection {
                angleVariation: 360
                magnitudeVariation: 80
            }
        }
        acceleration: PointDirection {
            y: 100
            yVariation: 20
        }
    }
}
