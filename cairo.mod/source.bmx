' Copyright (c) 2006-2017 Bruce A Henderson
'
'  The contents of this file are subject to the Mozilla Public License
'  Version 1.1 (the "License"); you may not use this file except in
'  compliance with the License. You may obtain a copy of the License at
'  http://www.mozilla.org/MPL/
'  
'  Software distributed under the License is distributed on an "AS IS"
'  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
'  License for the specific language governing rights and limitations
'  under the License.
'  
'  The Original Code is BaH.Cairo.
'  
'  The Initial Developer of the Original Code is Duncan Cross.
'
SuperStrict

' this first to ensure we get *our* config.h
Import "src/*.h"

Import "../../pub.mod/zlib.mod/*.h"
Import "../../pub.mod/libpng.mod/*.h"
Import "../../pub.mod/freetype.mod/include/*.h"
Import "../pixman.mod/pixman/*.h"

' cairo
Import "src/cairo-analysis-surface.c"
Import "src/cairo-arc.c"
Import "src/cairo-array.c"
Import "src/cairo-atomic.c"
Import "src/cairo-base64-stream.c"
Import "src/cairo-base85-stream.c"
Import "src/cairo-bentley-ottmann.c"
Import "src/cairo-bentley-ottmann-rectangular.c"
Import "src/cairo-bentley-ottmann-rectilinear.c"
Import "src/cairo.c"
Import "src/cairo-boxes.c"
Import "src/cairo-boxes-intersect.c"
Import "src/cairo-cache.c"
Import "src/cairo-clip.c"
Import "src/cairo-clip-boxes.c"
Import "src/cairo-clip-polygon.c"
Import "src/cairo-clip-region.c"
Import "src/cairo-clip-surface.c"
Import "src/cairo-color.c"
Import "src/cairo-composite-rectangles.c"
Import "src/cairo-compositor.c"
Import "src/cairo-contour.c"
Import "src/cairo-damage.c"
Import "src/cairo-debug.c"
Import "src/cairo-default-context.c"
Import "src/cairo-device.c"
Import "src/cairo-error.c"
Import "src/cairo-fallback-compositor.c"
Import "src/cairo-fixed.c"
Import "src/cairo-font-face.c"
Import "src/cairo-font-face-twin.c"
Import "src/cairo-font-face-twin-data.c"
Import "src/cairo-font-options.c"
Import "src/cairo-freelist.c"
Import "src/cairo-gstate.c"
Import "src/cairo-hash.c"
Import "src/cairo-hull.c"
Import "src/cairo-image-compositor.c"
Import "src/cairo-image-info.c"
Import "src/cairo-image-source.c"
Import "src/cairo-image-surface.c"
Import "src/cairo-line.c"
Import "src/cairo-lzw.c"
Import "src/cairo-mask-compositor.c"
Import "src/cairo-matrix.c"
Import "src/cairo-mesh-pattern-rasterizer.c"
Import "src/cairo-misc.c"
Import "src/cairo-mono-scan-converter.c"
Import "src/cairo-mutex.c"
Import "src/cairo-no-compositor.c"
Import "src/cairo-output-stream.c"
Import "src/cairo-observer.c"
Import "src/cairo-paginated-surface.c"
Import "src/cairo-path-bounds.c"
Import "src/cairo-path.c"
Import "src/cairo-path-bounds.c"
Import "src/cairo-path-fill.c"
Import "src/cairo-path-fixed.c"
Import "src/cairo-path-in-fill.c"
Import "src/cairo-path-stroke.c"
Import "src/cairo-path-stroke-boxes.c"
Import "src/cairo-path-stroke-polygon.c"
Import "src/cairo-path-stroke-traps.c"
Import "src/cairo-pattern.c"
Import "src/cairo-pen.c"
Import "src/cairo-polygon.c"
Import "src/cairo-polygon-intersect.c"
Import "src/cairo-polygon-reduce.c"
Import "src/cairo-raster-source-pattern.c"
Import "src/cairo-rectangle.c"
Import "src/cairo-rectangular-scan-converter.c"
Import "src/cairo-recording-surface.c"
Import "src/cairo-region.c"
Import "src/cairo-rtree.c"
Import "src/cairo-scaled-font.c"
Import "src/cairo-shape-mask-compositor.c"
Import "src/cairo-slope.c"
Import "src/cairo-spans.c"
Import "src/cairo-spans-compositor.c"
Import "src/cairo-spline.c"
Import "src/cairo-stroke-style.c"
Import "src/cairo-stroke-dash.c"
Import "src/cairo-surface.c"
Import "src/cairo-surface-fallback.c"
Import "src/cairo-surface-clipper.c"
Import "src/cairo-surface-offset.c"
Import "src/cairo-surface-snapshot.c"
Import "src/cairo-surface-subsurface.c"
Import "src/cairo-surface-wrapper.c"
Import "src/cairo-tag-attributes.c"
Import "src/cairo-tag-stack.c"
Import "src/cairo-tor-scan-converter.c"
Import "src/cairo-tor22-scan-converter.c"
Import "src/cairo-toy-font-face.c"
Import "src/cairo-traps.c"
Import "src/cairo-traps-compositor.c"
Import "src/cairo-tristrip.c"
Import "src/cairo-unicode.c"
Import "src/cairo-user-font.c"
Import "src/cairo-version.c"
Import "src/cairo-wideint.c"


Import "src/cairo-cff-subset.c"
Import "src/cairo-scaled-font-subsets.c"
Import "src/cairo-truetype-subset.c"
Import "src/cairo-type1-fallback.c"
Import "src/cairo-type1-subset.c"
Import "src/cairo-type3-glyph-surface.c"


Import "src/cairo-pdf-interchange.c"
Import "src/cairo-pdf-operators.c"
Import "src/cairo-pdf-shading.c"
Import "src/cairo-pdf-surface.c"
Import "src/cairo-deflate-stream.c"

Import "src/cairo-png.c"

Import "src/cairo-ps-surface.c"

Import "src/cairo-ft-font.c"

Import "src/cairo-type1-glyph-names.c"
Import "src/cairo-type1-subset.c"

Import "src/cairo-script-surface.c"

Import "src/cairo-svg-surface.c"

Import "src/cairo-xml-surface.c"

