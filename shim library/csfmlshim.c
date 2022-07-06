#include <stdlib.h>
#include <stddef.h>
#include <stdio.h>
#include <SFML/Window.h>
#include <SFML/Graphics.h>

void sfContext_getSettingsA(const sfContext* context, sfContextSettings* settings)
{
    *settings = sfContext_getSettings(context);
}

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

void sfWindow_getSettingsA(const sfWindow* window, sfContextSettings* settings)
{
    *settings = sfWindow_getSettings(window);
}

void sfText_getLocalBoundsA(const sfText* text, sfFloatRect* rect)
{
    *rect = sfText_getLocalBounds(text);
}

void sfText_getGlobalBoundsA(const sfText* text, sfFloatRect* rect)
{
    *rect = sfText_getGlobalBounds(text);
}
