/*
 * MSVC string.h compatibility header.
 * Copyright (c) 2015 Matthew Oliver
 *
 * This file is part of Shift Media Project.
 *
 * Shift Media Project is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * Shift Media Project is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with the code; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

#ifndef _SMP_STRING_H_
#define _SMP_STRING_H_

#ifndef _MSC_VER
#   include_next <string.h>
#else

#include <crtversion.h>
#if _VC_CRT_MAJOR_VERSION >= 14
#   include <../ucrt/string.h>
#else
#   include <../include/string.h>
#   define strtoll _strtoi64
#endif

__inline void *memmem(const void *haystack, size_t haystack_len, const void *needle, size_t needle_len)
{
    const char *begin = haystack;
    const char *last_possible = begin + haystack_len - needle_len;
    const char *tail = needle;
    char point;

    if (needle_len == 0)
        return (void *)begin;

    if (haystack_len < needle_len)
        return NULL;

    point = *tail++;
    for (; begin <= last_possible; begin++) {
        if (*begin == point && !memcmp(begin + 1, tail, needle_len - 1))
            return (void *)begin;
    }

    return NULL;
}

#include <stdint.h>
#include <ctype.h>

#define  S_N    0x0
#define  S_I    0x3
#define  S_F    0x6
#define  S_Z    0x9

#define  CMP    2
#define  LEN    3

__inline int strverscmp (const char *s1, const char *s2)
{
    const unsigned char *p1 = (const unsigned char *) s1;
    const unsigned char *p2 = (const unsigned char *) s2;

    const uint8_t next_state[] =
    {
        /* state    x    d    0  */
        /* S_N */  S_N, S_I, S_Z,
        /* S_I */  S_N, S_I, S_I,
        /* S_F */  S_N, S_F, S_F,
        /* S_Z */  S_N, S_F, S_Z
    };

    const int8_t result_type[] =
    {
        /* S_N */  CMP, CMP, CMP, CMP, LEN, CMP, CMP, CMP, CMP,
        /* S_I */  CMP, -1,  -1,  +1,  LEN, LEN, +1,  LEN, LEN,
        /* S_F */  CMP, CMP, CMP, CMP, CMP, CMP, CMP, CMP, CMP,
        /* S_Z */  CMP, +1,  +1,  -1,  CMP, CMP, -1,  CMP, CMP
    };

    if (p1 == p2)
        return 0;
    unsigned char c1 = *p1++;
    unsigned char c2 = *p2++;
    int state = S_N + ((c1 == '0') + (isdigit (c1) != 0));
    int diff;
    while ((diff = c1 - c2) == 0)
    {
        if (c1 == '\0')
            return diff;
        state = next_state[state];
        c1 = *p1++;
        c2 = *p2++;
        state += (c1 == '0') + (isdigit (c1) != 0);
    }
    state = result_type[state * 3 + (((c2 == '0') + (isdigit (c2) != 0)))];
    switch (state)
    {
    case CMP:
        return diff;
    case LEN:
        while (isdigit (*p1++))
        if (!isdigit (*p2++))
            return 1;
        return isdigit (*p2) ? -1 : diff;
    default:
        return state;
    }
}

#define strtok_r strtok_s
#define strcasecmp _stricmp
#define strncasecmp _strnicmp

#endif /* _MSC_VER */

#endif /* _SMP_STRING_H_ */