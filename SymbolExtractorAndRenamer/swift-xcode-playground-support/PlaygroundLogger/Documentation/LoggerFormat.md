# Playground Logger Format

This document describes the format used by PlaygroundLogger to serialize
objects into a stream of bytes for the purpose of storage or transmission of such
objects.

It does not deal with validation of stored data, nor does it indicate the
preferred manner to display stored data, nor does it deal with the problem of
reconstructing object state from stored data.

## Primitive types

These are the basic storage types that will be used throughout this documentation:

* The `8bytes` type. A `8bytes` is an unsigned integer of 64 bits in size.

* The `number` type. A `number` is an unsigned integer of 64 bits in size.
  It can be stored in one of two forms:

    - short number. A number between 0 and 254 will be represented as itself
      on one byte of storage.
    - long number. A number 255 and larger will be represented as a byte with
      the value 255, plus the little-endian representation of the number in
      eight bytes.

  The underlying assumption is that the log will mostly trade in small integer
  values, which means that using one extra byte for long integers will be
  offset by the abundance of numbers that will instead fit in one byte.
  Practical experience may prove this wrong, in which case there are several
  other avenues worth pursuing for a compact representation of numbers.

* The `string` type. A `string` is a `number` length + that many bytes
  encoded as UTF8 text.

* The `utf8bytes` type. A `utf8bytes` is a sequence of bytes encoded as UTF8.
  This kind of data has no associated length, nor end-of-text marker. As such its
  main use case is being the payload of an IDERepr, in which the payload length
  serves the purpose of indicating the data size.

  UTF8 is a nice and compact encoding, which optimizes nicely in the presumably
  common case of ASCII-like strings.

* The `boolean` type. A `boolean` is a one-byte value where 0 means false and 1 means true.
  Other values are undefined and consumers should reject them.

* The `double` type. A `double` is an IEE-754 double precision binary floating point value.
   The data occupies 8 bytes.

* The `float` type. A `float` is an IEE-754 single precision binary floating point value.
   The data occupies 4 bytes.

## Header

A log always starts with a `number` which is the version number of the format
as used in this particular log entry. Different formats might add or remove
fields compared to what is described here.

The current value for the version number is 10.

Values of 0 and 1 are reserved.
Any value less than the current version number is deprecated.
Any value greater than the current version number is reserved.

This is followed by four `8bytes` values. These are meant to represent
two pairs:

* (starting line, starting column)

* (ending line, ending column)

For consumers that produce logging data by instrumenting source code, these
are the locations in the instrumented source code that are responsible for
generating the data being logged. No sanity checking of any kind is performed,
and consumers should be ready to receive any possible value combinations.

This is followed by a `number` field. This is the count of a set of
(`string`,`string`) pairs that provide status and configuration details
about the log being emitted. As of now, there is only one field that can
be emitted:

* "tid",a unique identifier for the thread that is emitting the log entry

Consumers should be ready and willing to accept any (or no) entries here and proceed.

Immediately following this header, there is a log entry for the logged object.

## Log Entry

A log entry starts with a `string` field giving the name of the object being
logged.
Consumers are required to accept any empty or non-empty string for this field.

This is immediately followed by a one-byte code which represents the type of
log entry. Values 0 and 255 are reserved, and should not be used. The values
currently in use are:

* 1, for `class`
* 2, for `struct`
* 3, for `tuple`
* 4, for `enum`
* 5, for `aggregate`
* 6, for `container`
* 7, for `iderepr`
* 8, for `gap`
* 9, for `scope_entry`
* 10, for `scope_exit`
* 11, for `error`
* 12, for `index_container`
* 13, for `key_container`
* 14, for `membership_container`

The values that follow this code depend on the type.

## Structured Entries

Entries of types:

* `class`
* `struct`
* `tuple`
* `enum`
* `aggregate`
* `container`
* `index_container`
* `key_container`
* `membership_container`

all follow the `structured` format.

A `structured` log entry is meant for objects that contain other objects.

A `structured` log entry contains:

* A `string` to be used as the type name.

  The exact contents depend on the individual object being logged, but in
  general this is going to be a typename.
  An empty string is allowed here.

* A `string` to be used as a summary.

  The exact contents depend on the individual object being logged, but in
  general this is expected to be a count of some sort, or a longer more
  detailed description of this object.
  An empty string is allowed here.

* A `number` that specifies the number of elements contained within the
  structured object (total-count).

  This count is non-recursive, meaning that a structured could contain other
  structured values within itself, and this will only be a first-level deep
  count rather than a total.

* A `number` that specifies the number of elements contained within the
  structured object **that are contained in the log** (stored-count).

  Due to the presence of gap elements, consumers are encouraged to avoid making deductions based on the relationship between `total-count` and `stored-count`.
  
  One exception is that the logger itself will, if the `total-count` field happens to be zero, not emit the `stored-count` field. It is then safe to assume that `total-count == 0 ==> stored-count == 0`. The rationale should be obvious.

Following this specification, there are as many log entries as specified to be
contained in the log. Each of them follows the general format of a log entry,
meaning they will each have a type marker, and they might well be themselves
`structured` entries.

## IDE Representation

An `iderepr` log entry is intended as a leaf, i.e. an object that does not
contain other objects. The exact interpretation of any given `iderepr` however
is largely up to the decoder, and beyond the scope of this discussion.

An `iderepr` log entry contains:

* A `boolean` that indicates whether the summary is the preferred sidebar display.

  The interpretation of this flag is left to consumers, but as a general guideline
  if this value is true, consumers should prefer showing the brief summary as the
  compact representation of data.

* A `string` to be used as the type name.

  The exact contents depend on the individual object being logged, but in
  general this is going to be a typename.
  An empty string is allowed here.

* A `string` to be used as a summary.

  The exact contents depend on the individual object being logged, but in
  general this is expected to be a count of some sort, or a longer more
  detailed description of this object.
  An empty string is allowed here.

* A `string` describing the semantics of the stored data.

  For instance, this field could say "HTML" to mean the data should be
  displayed as an HTML page, or "PNG" to mean the data should be displayed
  as a PNG format image.

  Encoders and decoders have to be in sync for this mechanism to work, of
  course, but it is assumed that this is a more extensible scheme than having
  a specification of a small set of representations forcing producers and
  consumer to all have to make do with those instead of having the freedom to
  invent new formats at will.

* A `number` giving the size in bytes of the actual logged data.

  This count does not include any of the format overhead, and should merely
  be considered the number of bytes to read to obtain the encoded object.

  The exact meaning of the bytes is dependent on the `string` field.
  This is a (potentially incomplete and not authoritative) list of formats:

    - STRN: A `utf8bytes` field.
    - SINT: A signed number (of 64 bits in size) represented as a `utf8bytes`
    - UINT: An unsigned number (of 64 bits in size) represented as a `utf8bytes`
    - FLOT: A single precision floating-point number represented as a `float`
    - DOBL: A single precision floating-point number represented as a `double`
    - IMAG: An image.
    - VIEW: A pictorial representation of a view.
    - SKIT: A pictorial representation of a software sprite.
    - COLR: An NSColor represented as the output of an NSKeyedArchiver
      with two objects inside of it:
      `IDEColorSpaceKey`: the name of color space as an NSString
      `IDEColorComponentsKey`: an NSArray of CGFloat NSNumbers that
      represent the components of the color in the given color space
    - BEZP: An NSKeyedArchiver-encoded NSBezierPath under the key "root"
    - ASTR: An NSKeyedArchiver-encoded NSAttributedString under the key "root"
    - PONT: A Point represented as an NSArchiver-encoded pair of double values
      under the keys "x" and "y"
    - SIZE: A Size represented as an NSArchiver-encoded pair of double values
      under the keys "w" and "h"
    - RECT: A Rectangle represented as an NSArchiver-encoded set of double values
      under the keys "x", "y", "w" and "h"
    - RANG: A Range represented as an NSArchiver-encoded pair of unsigned 64-bit
      integer values under the keys "loc" and "len"
    - BOOL: A boolean represented as a one-byte value, where
      1 == true
      anything else == false
    - URL: A `utf8bytes` field representing a Uniform Resource Locator.

## Gap

A `gap` log entry is intended as a placeholder for things that are missing
from the log as a result of a policy decision on how many elements to log.

A `gap` entry contains no data. Upon reading the marker, consumers are done
decoding the entire content of the entry.

It is up to consumers to decide how to visualize a `gap` entry.

It should be noted that the `name` field won't mean a lot for a `gap` entry.
However, consumers should be capable of decoding a string there - including an
empty one.

## Scope Entry

A `scope` entry (`scope_entry`, `scope_exit`) is intended to let the consumer
know when a certain scope has been "entered" or "exited". The concepts of
scope, entry and exit are left for the language to define, and it is assumed
the reader of this document is familiar enough with the language to have an
understanding of such concepts.

A `scope` entry contains no data. Upon reading the marker, consumers are done
decoding the entire content of the entry. The underlying assumption is that
some other layer of communication is providing location or addressing information
to enable the consumer to follow through the flow of entry and exit log entries.

It is up to consumers to decide how to visualize a `scope` entry.

It should be noted that the `name` field won't mean a lot for a `scope` entry.
However, consumers should be capable of decoding a string there - including an
empty one.

## Error

An `error` log entry is intended as a placeholder for things that are missing
from the log as a result of an internal logger issue with producing data.

An `error` entry is followed by `string` data, possibly an empty `string`.
This is meant to provide an explanation for the issue - and will most likely
be empty when the logger doesn't have an explanation (e.g. runtime errors).

It is up to consumers to decide how to visualize an `error` entry.
