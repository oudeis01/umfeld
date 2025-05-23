/*
 * Umfeld
 *
 * This file is part of the *Umfeld* library (https://github.com/dennisppaul/umfeld).
 * Copyright (c) 2025 Dennis P Paul.
 *
 * This library is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3.
 *
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#pragma once

#include "PApplet.h"

namespace umfeld {
    static void draw_buffer(PApplet*     g,
                            const float* buffer,
                            const int    length,
                            const int    step,
                            const float  width,
                            const float  height) {
        for (int i = 0; i < length; i += step) {
            g->beginShape(LINES);
            const float x = PApplet::map(i,
                                         0, length,
                                         0, width);
            const float y = PApplet::map(buffer[i],
                                         -1.0f, 1.0f,
                                         -height / 2, height / 2);
            g->vertex(x, 0);
            g->vertex(x, y);
            // g->line(x, 0, x, y);
            g->endShape();
        }
    }
} // namespace umfeld
