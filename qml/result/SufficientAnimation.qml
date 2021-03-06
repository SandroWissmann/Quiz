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

        velocity: PointDirection {
            y: -17 * 4 * 3
            xVariation: 6 * 6
        }
        acceleration: PointDirection {
            y: 17 * 2
            xVariation: 6 * 6
        }

        size: 30
        sizeVariation: 4
    }
}
