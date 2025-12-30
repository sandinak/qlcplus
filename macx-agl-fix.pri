# Fix for modern macOS: AGL framework is deprecated and removed
# This file should be included AFTER Qt modules are loaded
# to override the AGL framework reference

macx {
    # Remove AGL from OpenGL libs - it's deprecated on modern macOS
    QMAKE_LIBS_OPENGL = -framework OpenGL
    
    # Also remove from LIBS in case it was added there
    LIBS -= -framework AGL
}

