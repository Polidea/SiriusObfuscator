# The PlaygroundLogger API

This document briefly describes the API vended by PlaygroundLogger.

It should be noted that the logger is free to implement more than whatever
is specified in this document - but consumers should **not** rely on anything
to be available for their use except what is accounted for in this document.

## `playground_logger_initialize`

Whenever you want to use PlaygroundLogger in a new process, it is your duty
to initialize the logger. To do so call `func playground_logger_initialize()`

This function sets up whatever state is required for the logger to operate safely
and is a prerequisite for using any other logger call

## `playground_log`

The main API call provided by the logger is, quite obviously, the log call.
Its signature is:

`func playground_log<T>(_ object: T,
                       _ name: String,
                       _ ID: Int,
                       _ startline: Int,
                       _ endline: Int,
                       _ startcolumn: Int,
                       _ endcolumn: Int) -> NSData`

It is a generic function over an unspecified T, which means any Swift object
can be passed as an argument. The arguments are as follows:

* object. This is the object to be stored by the logger. This call generates
an NSData whose contents are in the format specified in the format document.

* name. This is the name of the object. It does not need to be syntactically
correct, it is mostly useful for visualization purposes. Anything, including
an empty string is valid here. No checks are performed on this argument.

* ID. This is the unique identifier of the log call site. It is only required
to be unique across a logging session, and no meaning should be attached to
the specific value. It is also not an object identifier, so much as an identifier
for the location in code in which the log call is being executed.

* startline, endline, startcolumn, endcolumn. This is the range of source code text that produces the object being logged.

It should be noted that this, and other log functions, explicitly do not follow proper Swift API guidelines (e.g. argument labels) in order to make it easier to insert calls to them via computer-generated instrumentation. The details of how these calls would be inserted are outside the scope of this document.

## `playground_log_postprint`

The logger has the ability - in sync with the Swift standard library - to store
the last thing that has been print()-ed (or debugPrint()-ed) and return it on request

The function that does that is `func playground_log_postprint (_ startline: Int,
                               _ endline: Int,
                               _ startcolumn: Int,
                               _ endcolumn: Int) -> NSData`

This API promises to return an NSData that contains the same output as-if playground_log
were called passing the printed string as the object to log.

It is to be noted that there is no explicit provision in the logger for wrapping print(), so
in order for playground_log_postprint to do anything useful, it is the duty of the user to make
it so that the logger has access to the printed content.

The way this works is an implementation detail between the logger and the standard library and should not
be considered a part of the contract.
