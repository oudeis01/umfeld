cmake_minimum_required(VERSION 3.20)

project(umfeld-lib)

message(STATUS "----------------------------------------")
message(STATUS "UMFELD_APP    : ${PROJECT_NAME}")

option(ENABLE_PORTAUDIO "Enable PortAudio output" ON)

##########################################################################################################
### CHECK FOR PACKAGE MANAGERS (macOS)                                                                ###
##########################################################################################################
find_program(BREW_FOUND brew)
if (APPLE)
    if (BREW_FOUND)
        execute_process(COMMAND brew --prefix
                OUTPUT_VARIABLE HOMEBREW_PREFIX
                OUTPUT_STRIP_TRAILING_WHITESPACE)
        set(HOMEBREW_LIB_PATH "${HOMEBREW_PREFIX}/lib")
        message(STATUS "Package Manager : Homebrew (${HOMEBREW_LIB_PATH})")
    else ()
        if(EXISTS "/opt/local/libexec/macports")
            set(MACPORTS_PREFIX "/opt/local")
            set(MACPORTS_LIB_PATH "${MACPORTS_PREFIX}/lib")
            message(STATUS "Package Manager : MacPorts (${MACPORTS_LIB_PATH})")
        endif()
    endif ()
endif (APPLE)

##########################################################################################################
### SUPPLEMENT LIBRARY SEARCH PATH                                                                     ###
##########################################################################################################
if (APPLE)
    if(HOMEBREW_LIB_PATH)
        link_directories(
            ${HOMEBREW_LIB_PATH}
            /usr/local/lib
            /opt/homebrew/lib
        )
    elseif(MACPORTS_LIB_PATH)
        link_directories(
            ${MACPORTS_LIB_PATH}
            /opt/local/lib
        )
    else()
        link_directories(
            /usr/local/lib
            /opt/local/lib
            /opt/homebrew/lib
        )
    endif()
    message(STATUS "Added macOS library search paths")
elseif (UNIX)
elseif (WIN32)
else ()
endif ()

##########################################################################################################
### ADD SOURCE + HEADER FILES                                                                          ###
##########################################################################################################
if (APPLE)
    file(GLOB UMFELD_SOURCE_FILES
            ${CMAKE_CURRENT_SOURCE_DIR}/src/*.mm
            ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/*.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/*.c
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/libtess2/*.c
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/clipper/*.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/ip/*.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/ip/posix/*.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/osc/*.cpp
    )
elseif (UNIX)
    file(GLOB UMFELD_SOURCE_FILES
            ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/*.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/*.c
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/libtess2/*.c
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/clipper/*.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/ip/*.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/ip/posix/*.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/osc/*.cpp
    )
elseif (WIN32)
    file(GLOB UMFELD_SOURCE_FILES
            ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/*.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/*.c
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/libtess2/*.c
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/clipper/*.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/ip/*.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/ip/win32/*.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/osc/*.cpp
    )
else ()
    file(GLOB UMFELD_SOURCE_FILES
            ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/*.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/*.c
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/libtess2/*.c
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/clipper/*.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/ip/*.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/ip/posix/*.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/libraries/osc/*.cpp
    )
endif ()

if (NOT TARGET umfeld-lib)
    add_library(umfeld-lib ${UMFELD_SOURCE_FILES})
endif ()

target_include_directories(umfeld-lib PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
        ${CMAKE_CURRENT_SOURCE_DIR}/include/shaders
        ${CMAKE_CURRENT_SOURCE_DIR}/include/libraries
        ${CMAKE_CURRENT_SOURCE_DIR}/include/libraries/dr_libs
        ${CMAKE_CURRENT_SOURCE_DIR}/include/libraries/ip
        ${CMAKE_CURRENT_SOURCE_DIR}/include/libraries/libtess2
        ${CMAKE_CURRENT_SOURCE_DIR}/include/libraries/osc
)

##########################################################################################################
### EN/DISABLE LIBRARIES                                                                               ###
##########################################################################################################
if (NOT TARGET umfeld-lib-interface)
    add_library(umfeld-lib-interface INTERFACE)
endif ()

target_compile_definitions(${PROJECT_NAME} PUBLIC GLM_ENABLE_EXPERIMENTAL)

if (NOT DISABLE_MAIN)
    target_compile_definitions(${PROJECT_NAME} PUBLIC SDL_MAIN_USE_CALLBACKS)
else ()
    message(STATUS "DISABLE_MAIN  : no `main` function entry point. must be defined in project.")
endif ()

if (DISABLE_GRAPHICS)
    target_compile_definitions(umfeld-lib-interface INTERFACE DISABLE_GRAPHICS)
    target_compile_definitions(${PROJECT_NAME} PUBLIC DISABLE_GRAPHICS)
    message(STATUS "DISABLING     : graphics")
endif ()

if (DISABLE_AUDIO)
    target_compile_definitions(umfeld-lib-interface INTERFACE DISABLE_AUDIO)
    target_compile_definitions(${PROJECT_NAME} PUBLIC DISABLE_AUDIO)
    message(STATUS "DISABLING     : audio")
endif ()

if (DISABLE_VIDEO)
    target_compile_definitions(umfeld-lib-interface INTERFACE DISABLE_VIDEO)
    target_compile_definitions(${PROJECT_NAME} PUBLIC DISABLE_VIDEO)
    message(STATUS "DISABLING     : video")
endif ()

if (ENABLE_PORTAUDIO)
    target_compile_definitions(umfeld-lib-interface INTERFACE ENABLE_PORTAUDIO)
    target_compile_definitions(${PROJECT_NAME} PUBLIC ENABLE_PORTAUDIO)
    message(STATUS "ENABLING      : PortAudio Driver")
endif ()

if (ENABLE_CAPTURE)
    target_compile_definitions(umfeld-lib-interface INTERFACE ENABLE_CAPTURE)
    target_compile_definitions(${PROJECT_NAME} PUBLIC ENABLE_CAPTURE)
    message(STATUS "ENABLING      : Capture")
endif ()

##########################################################################################################
### CREATE EXECUTABLE                                                                                  ###
##########################################################################################################
target_sources(${PROJECT_NAME}
        PUBLIC
        ${UMFELD_SOURCE_FILES}
)

##########################################################################################################
### CHECK SYSTEM TYPE                                                                                  ###
##########################################################################################################
if (APPLE)
    message(STATUS "SYSTEM        : macOS")
    target_compile_definitions(umfeld-lib-interface INTERFACE SYSTEM_MACOS)
    target_compile_definitions(${PROJECT_NAME} PUBLIC SYSTEM_MACOS)
elseif (UNIX)
    message(STATUS "SYSTEM        : UNIX ( including RPI )")
    target_compile_definitions(umfeld-lib-interface INTERFACE SYSTEM_UNIX)
    target_compile_definitions(${PROJECT_NAME} PUBLIC SYSTEM_UNIX)
elseif (WIN32)
    message(STATUS "SYSTEM        : Windows")
    target_compile_definitions(umfeld-lib-interface INTERFACE SYSTEM_WIN32)
    target_compile_definitions(${PROJECT_NAME} PUBLIC SYSTEM_WIN32)
else ()
    message(STATUS "SYSTEM        : Undefined, Good Luck!")
    target_compile_definitions(umfeld-lib-interface INTERFACE SYSTEM_UNDEFINED)
    target_compile_definitions(${PROJECT_NAME} PUBLIC SYSTEM_UNDEFINED)
endif ()

if (APPLE)
    set(CMAKE_SUPPRESS_DEVELOPER_WARNINGS ON)
endif ()

##########################################################################################################
### FIND PACKAGES + LIBRARIES                                                                          ###
##########################################################################################################
find_package(PkgConfig REQUIRED)
if (WIN32)
elseif (APPLE)
    list(APPEND CMAKE_PREFIX_PATH
        ${HOMEBREW_PREFIX}
        ${MACPORTS_PREFIX}
        /usr/local
        /opt/local
    )
elseif (UNIX)
    find_package(Threads REQUIRED)
endif ()

# GRAPHICS + VIDEO
if (NOT DISABLE_GRAPHICS)
    pkg_search_module(GLEW REQUIRED glew)
    find_package(glm REQUIRED CONFIG)
    find_package(OpenGL REQUIRED)
    find_package(SDL3 CONFIG REQUIRED)
    pkg_search_module(HARFBUZZ REQUIRED harfbuzz)
    pkg_check_modules(FREETYPE REQUIRED freetype2)

    if (NOT DISABLE_VIDEO)
        pkg_check_modules(FFMPEG REQUIRED
            libavcodec
            libavformat
            libavutil
            libswscale
            libswresample
            libavdevice
        )
    endif ()
endif ()

# AUDIO
if (NOT DISABLE_AUDIO)
    if (ENABLE_PORTAUDIO)
        pkg_search_module(PORTAUDIO REQUIRED portaudio-2.0)
    else ()
        find_package(SDL3 CONFIG REQUIRED)
    endif ()
endif ()

# MIDI
if (NOT DISABLE_MIDI)
    pkg_search_module(RTMIDI REQUIRED rtmidi)
endif ()

##########################################################################################################
### INCLUDE + LINK LIBRARIES                                                                           ###
##########################################################################################################
if (HOMEBREW_LIB_PATH)
    target_link_directories(${PROJECT_NAME} PUBLIC ${HOMEBREW_LIB_PATH})
endif ()

if (WIN32)
    target_link_libraries(${PROJECT_NAME} PUBLIC wsock32 ws2_32 winmm)
elseif (APPLE)
    if(HOMEBREW_LIB_PATH OR MACPORTS_LIB_PATH)
        target_link_directories(${PROJECT_NAME} PUBLIC
            ${HOMEBREW_LIB_PATH}
            ${MACPORTS_LIB_PATH}
        )
    endif()
    target_link_libraries(${PROJECT_NAME} PUBLIC
        "-framework AVFoundation"
        "-framework Foundation"
        "-framework CoreMedia"
        "-framework CoreVideo"
        "-framework OpenGL"
    )
elseif (UNIX)
    target_link_libraries(${PROJECT_NAME} PUBLIC Threads::Threads)
endif ()

if (NOT DISABLE_AUDIO)
    target_link_libraries(${PROJECT_NAME} PUBLIC ${PORTAUDIO_LIBRARIES})
    target_include_directories(${PROJECT_NAME} PUBLIC ${PORTAUDIO_INCLUDE_DIRS})
endif ()

if (NOT DISABLE_GRAPHICS OR NOT DISABLE_AUDIO)
    target_link_libraries(${PROJECT_NAME} PUBLIC ${HARFBUZZ_LIBRARIES})
    target_include_directories(${PROJECT_NAME} PUBLIC ${HARFBUZZ_INCLUDE_DIRS})
    target_link_libraries(${PROJECT_NAME} PUBLIC ${FREETYPE_LIBRARIES})
    target_include_directories(${PROJECT_NAME} PUBLIC ${FREETYPE_INCLUDE_DIRS})
    target_link_libraries(${PROJECT_NAME} PUBLIC SDL3::SDL3)
    target_include_directories(${PROJECT_NAME} PUBLIC ${SDL3_INCLUDE_DIRS})
endif ()

if (NOT DISABLE_GRAPHICS)
    target_link_libraries(${PROJECT_NAME} PUBLIC ${OPENGL_LIBRARIES})
    target_include_directories(${PROJECT_NAME} PUBLIC ${OPENGL_INCLUDE_DIRS})
    target_link_libraries(${PROJECT_NAME} PUBLIC ${GLEW_LIBRARIES})
    target_include_directories(${PROJECT_NAME} PUBLIC ${GLEW_INCLUDE_DIRS})
    target_link_libraries(${PROJECT_NAME} PUBLIC glm::glm)

    if (NOT DISABLE_VIDEO)
        target_include_directories(${PROJECT_NAME} PUBLIC ${FFMPEG_INCLUDE_DIRS})
        target_link_libraries(${PROJECT_NAME} PUBLIC ${FFMPEG_LIBRARIES})
    endif ()
endif ()

if (NOT DISABLE_MIDI)
    target_link_libraries(${PROJECT_NAME} PUBLIC ${RTMIDI_LIBRARIES})
    target_include_directories(${PROJECT_NAME} PUBLIC ${RTMIDI_INCLUDE_DIRS})
endif ()

##########################################################################################################
### COMPILER FLAGS                                                                                     ###
##########################################################################################################
function(add_umfeld_libs)
    if (NOT TARGET umfeld-lib-interface)
        message(FATAL_ERROR "umfeld-lib-interface target not found.")
    endif ()
    if (NOT TARGET umfeld-lib)
        message(FATAL_ERROR "umfeld-lib target not found.")
    endif ()
    set_target_properties(${PROJECT_NAME} PROPERTIES POSITION_INDEPENDENT_CODE ON)
    target_link_libraries(${PROJECT_NAME} PRIVATE umfeld-lib-interface)
    target_link_libraries(${PROJECT_NAME} PRIVATE umfeld-lib)
endfunction()

##########################################################################################################
### TEST                                                                                               ###
##########################################################################################################
option(BUILD_TESTING "Enable tests" OFF)
if (BUILD_TESTING)
    message(STATUS "TESTING       : enabled")
    enable_testing()
    set(CMAKE_CXX_STANDARD 17)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
    add_executable(umfeld-tests test/umfeld_test.cpp)
    target_link_libraries(umfeld-tests umfeld-lib umfeld-lib-interface)
    add_test(NAME UmfeldTest COMMAND umfeld-tests)
endif ()

message(STATUS "----------------------------------------")