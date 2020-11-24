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
