// **********************************************************************
//
// Copyright (c) 2002
// MutableRealms, Inc.
// Huntsville, AL, USA
//
// All Rights Reserved
//
// **********************************************************************

#ifndef ICE_CONFIG_H
#define ICE_CONFIG_H

#ifdef WIN32

// ... identifier was truncated to '255' characters in the debug information
#   pragma warning( disable : 4786 )
// 'this' : used in base member initializer list
#   pragma warning( disable : 4355 )
// class ... needs to have dll-interface to be used by clients of class ...
#   pragma warning( disable : 4251 )
// ... : inherits ... via dominance
#   pragma warning( disable : 4250 )
// non dll-interface class ... used as base for dll-interface class ...
#   pragma warning( disable : 4275 )

#   ifdef ICE_EXPORTS
#       define ICE_API __declspec(dllexport)
#   else
#       define ICE_API __declspec(dllimport)
#   endif

#else // !WIN32

#   define ICE_API /**/

#endif

//
// Some include files we need almost everywhere
//
#include <cerrno>
#include <cassert>
#include <cstdio>
#include <cstring>
#include <iostream>
#include <string>
#include <vector>
#include <list>

//
// Ice uses JThreads/C++
//
#include <JTC/JTC.h>

//
// Define Ice and _Ice namespace, for those files which do not include
// any files which use these namespaces. This way we can use uniform
// "using" statements everywhere.
//
namespace Ice { }
namespace _Ice { }

#endif
