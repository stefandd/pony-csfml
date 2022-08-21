#include <stdlib.h>
#include <stddef.h>
#include <stdio.h>
#include <SFML/Window.h>
#include <SFML/Graphics.h>

#define VEC2F(__x) (*(sfVector2f*)&__x)
#define COLOR(__x) (*(sfColor*)&__x)

// CONTEXT 

void sfContext_getSettingsA(const sfContext* context, sfContextSettings* settings)
{
    *settings = sfContext_getSettings(context);
}

// RENDER WINDOW

sfRenderWindow* sfRenderWindow_createA(unsigned int width, unsigned int height, unsigned int bitsPerPixel, const char* title, sfUint32  style, const sfContextSettings* settings)
{
    sfVideoMode mode = {width, height, bitsPerPixel};
    return sfRenderWindow_create(mode, title, style, settings);
}

sfRenderWindow* sfRenderWindow_createUnicodeA(unsigned int width, unsigned int height, unsigned int bitsPerPixel, const sfUint32* title, sfUint32 style, const sfContextSettings* settings)
{
    sfVideoMode mode = {width, height, bitsPerPixel};
    return sfRenderWindow_createUnicode(mode, title, style, settings);
}

void sfRenderWindow_getSettingsA(const sfRenderWindow* window, sfContextSettings* settings)
{
    *settings = sfRenderWindow_getSettings(window);
}

// WINDOW 

void sfWindow_getSettingsA(const sfWindow* window, sfContextSettings* settings)
{
    *settings = sfWindow_getSettings(window);
}

// TEXT

void sfText_getLocalBoundsA(const sfText* text, sfFloatRect* rect)
{
    *rect = sfText_getLocalBounds(text);
}

void sfText_getGlobalBoundsA(const sfText* text, sfFloatRect* rect)
{
    *rect = sfText_getGlobalBounds(text);
}

void sfText_setPositionA(sfText* text, sfUint64 pos)
{
    sfText_setPosition(text, VEC2F(pos));
}

void sfText_setScaleA(sfText* text, sfUint64 scales)
{
    sfText_setScale(text, VEC2F(scales));
}

void sfText_setOriginA(sfText* text, sfUint64 origin)
{
    sfText_setOrigin(text, VEC2F(origin));
}

// VERTEX ARRAY

void sfVertexArray_appendA(sfVertexArray* vertexArray, sfUint64 pos, sfUint32 color, sfUint64 tex)
{
    sfVertex v = { VEC2F(pos), COLOR(color), VEC2F(tex) };
    sfVertexArray_append(vertexArray, v);
}

void sfVertexArray_getBoundsA(sfVertexArray* vertexArray, sfFloatRect* rect)
{
    *rect = sfVertexArray_getBounds(vertexArray);
}

// CIRCLE SHAPE

void sfCircleShape_setPositionA(sfCircleShape* circle, sfUint64 pos)
{
    sfCircleShape_setPosition(circle, VEC2F(pos));
}

void sfCircleShape_setOriginA(sfCircleShape* circle, sfUint64 origin)
{
    sfCircleShape_setOrigin(circle, VEC2F(origin));
}

// RECTANGLE SHAPE

void sfRectangleShape_setSizeA(sfRectangleShape* rect, sfUint64 size)
{
    sfRectangleShape_setSize(rect, VEC2F(size));
}

void sfRectangleShape_setPositionA(sfRectangleShape* rect, sfUint64 pos)
{
    sfRectangleShape_setPosition(rect, VEC2F(pos));
}

void sfRectangleShape_setOriginA(sfRectangleShape* rect, sfUint64 origin)
{
    sfRectangleShape_setOrigin(rect, VEC2F(origin));
}

// VIEW

// There's no portable way for this function to take a U128 argument,
// so the parts of the rectangle will be individual args.
sfView* sfView_createFromRectA(float left, float top, float width, float height)
{
    sfFloatRect rect = {left, top, width, height};
    return sfView_createFromRect(rect);
}

// There's no portable way for this function to take a U128 argument,
// so the parts of the rectangle will be individual args.
void sfView_resetA(sfView* view, float left, float top, float width, float height)
{
    sfFloatRect rect = {left, top, width, height};
    sfView_reset(view, rect);
}

void sfView_setSizeA(sfView* view, sfUint64 size)
{
    sfView_setSize(view, VEC2F(size));
}