package FFI::Util;

use strict;
use warnings;
use FFI::Raw 0.18;
use FFI::Sweet;
use base qw( Exporter );

# ABSTRACT: The opposite of type casting
# VERSION

ffi_lib do {
  my($module, $modlibname) = ('FFI::Util', __FILE__);
  my @modparts = split(/::/,$module);
  my $modfname = $modparts[-1];
  my $modpname = join('/',@modparts);
  my $c = @modparts;
  $modlibname =~ s,[\\/][^\\/]+$,, while $c--;    # Q&D basename
  my $file = "$modlibname/auto/$modpname/$modfname.so";
  unless(-e $file)
  {
    $modlibname =~ s,[\\/][^\\/]+$,,;
    $file = "$modlibname/arch/auto/$modpname/$modfname.so"
  }
  \$file;
};

attach_function "deref_to_ptr",    [ _ptr ], _ptr;
attach_function "deref_to_int",    [ _ptr ], _int;
attach_function "deref_to_uint",   [ _ptr ], _uint;
attach_function "deref_to_short",  [ _ptr ], _short;
attach_function "deref_to_ushort", [ _ptr ], _ushort;
attach_function "deref_to_long",   [ _ptr ], _long;
attach_function "deref_to_ulong",  [ _ptr ], _ulong;
attach_function "deref_to_char",   [ _ptr ], _char;
attach_function "deref_to_uchar",  [ _ptr ], _uchar;
attach_function "deref_to_float",  [ _ptr ], _float;
attach_function "deref_to_double", [ _ptr ], _double;
attach_function "deref_to_int64",  [ _ptr ], _int64;
attach_function "deref_to_uint64", [ _ptr ], _uint64;

our @EXPORT_OK = map { "deref_to_$_" } qw( ptr int uint short ushort char uchar float double int64 uint64 );

sub scalar_to_buffer
{
  my $size = do { use bytes; length $_[0] };
  my $ptr = unpack 'L!', pack 'P', $_[0];
  ($ptr, $size)
}

sub buffer_to_scalar
{
  my($ptr, $size) = @_;
  unpack "P$size", pack 'L!', $ptr;
}

push @EXPORT_OK, qw( scalar_to_buffer buffer_to_scalar );

1;