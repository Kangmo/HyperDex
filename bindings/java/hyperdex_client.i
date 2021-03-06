/* Copyright (c) 2012-2013, Cornell University
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright notice,
 *       this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of HyperDex nor the names of its contributors may be
 *       used to endorse or promote products derived from this software without
 *       specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

%module hyperdex_client

%include "std_string.i"
%include "stdint.i"
%include "various.i"

%include "enums.swg"
%javaconst(1);

%{
#include <limits.h>
#include <cstdlib>
#include <hyperdex/client.h>
#include <hyperdex/client.hpp>
using namespace hyperdex;
typedef hyperdex_client_attribute* hyperdex_client_attribute_asterisk;
%}

typedef uint16_t in_port_t;
typedef hyperdex_client_attribute* hyperdex_client_attribute_asterisk;

%pragma(java) jniclasscode=
%{
    static
    {
        System.loadLibrary("hyperdex-client-java");
    }
%}

%include "cpointer.i"

// Using typedef hyperdex_client_attribute_asterisk instead of hyperdex_client_attribute*
// as the latter confuses SWIG when trying to define SWIG pointer handling macros
// on something that is already a pointer.
// hyperdex_client_attribute_asterisk - c++ typedef for hyperdex_client_attribute* type
// hyperdex_client_attribute_ptr - the java name I chose to represent the resulting:
//                             hyperdex_client_attribute_asterisk*
//                             = hyperdex_client_attribute** 
//                             To wit, in java hyperdex_client_attribute is already
//                             a pointer, so the name hyperdex_client_attribute_ptr is
//                             essentially a pointer to this java-transparent pointer.  
%pointer_functions(hyperdex_client_attribute_asterisk,hyperdex_client_attribute_ptr);

// A couple more c++ pointer handling macros I will need
//
%pointer_functions(size_t, size_t_ptr);
%pointer_functions(hyperdex_client_returncode, rc_ptr);
%pointer_functions(uint64_t, uint64_t_ptr);

%apply (char *BYTE) { (const char *description) }
%apply (char *BYTE) { (const char *space) }
%apply (char *BYTE) { (const char *sort_by) }
%apply (char *STRING, int LENGTH) { (const char *key, size_t key_sz) }
%apply (char *STRING, int LENGTH) { (const char *attr, size_t attr_sz) }
%apply (char *STRING, int LENGTH) { (char *name, size_t name_sz) }
%apply (char *STRING, int LENGTH) { (char *value, size_t value_sz) }
%apply (char *STRING, int LENGTH) { (const char *map_key, size_t map_key_sz) }
%apply (char *STRING, int LENGTH) { (const char *value, size_t value_sz) }


// Pertaining to the include of hyperdex.h and client/hyperdex_client.h below:

// Ignore everything
// %ignore "";

// Un-ignore a couple of enums
%rename("%s") "hyperdex_client_returncode";
%rename("%s") "hyperdatatype";
%rename("%s") "hyperpredicate";
%rename("%s", %$isenumitem) "";

// Un-ignore some classes I want to proxy in java
%rename("%s") "hyperdex_client_attribute";
%rename("%s") "hyperdex_client_map_attribute";
%rename("%s") "hyperdex_client_attribute_check";
%rename("%s",%$isvariable) "";

// Un-ignore the only needed C function
%rename("%s") "hyperdex_client_destroy_attrs";

%rename("%s", %$ismember) "";

%include "proxies/hyperdex_client_attribute.i"
%include "proxies/hyperdex_client_map_attribute.i"
%include "proxies/hyperdex_client_attribute_check.i"
%include "proxies/Client.i"

%include "include/hyperdex.h"
%include "include/hyperdex/client.h"
%include "include/hyperdex/client.hpp"
