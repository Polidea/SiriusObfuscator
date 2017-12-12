#!/usr/bin/env python

# This source file is part of the Swift.org open source project
#
# Copyright (c) 2014 - 2015 Apple Inc. and the Swift project authors
# Licensed under Apache License v2.0 with Runtime Library Exception
#
# See http://swift.org/LICENSE.txt for license information
# See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

# This is the script that is in charge of building PlaygroundLogger on Linux

import sys
import os
import os.path
import subprocess
import argparse
import colorama
import errno
import glob
import shutil

PROJECT_NAME = 'PlaygroundLogger'
SOURCE_DIR = os.path.dirname(os.path.abspath(__file__))

def formatted_msg(color,msg):
    if color:
        print "%s-build: %s%s%s" % (PROJECT_NAME,color,msg,colorama.Fore.RESET)
    else:
        print "%s-build: %s" % (PROJECT_NAME,msg)

def warning(msg):
    formatted_msg(colorama.Fore.YELLOW,msg)

def error(msg):
    formatted_msg(colorama.Fore.RED,msg)

def note(msg):
    formatted_msg(None,msg)

class BuildError(BaseException):
    def __init__(self):
        pass
    
    def __nonzero__(self):
        return False
    
    def __str__(self):
        return 'unknown build error'

class UncaughtExceptionBuildError(BuildError):
    def __init__(self, err):
        self.err = err
    
    def __str__(self):
        return 'uncaught exception: %s' % (self.err)

class NonZeroExitBuildError(BuildError):
    def __init__(self, cmd, err):
        self.cmd = cmd
        self.err = err

    def __str__(self):
        return '"%s" did not exit cleanly\n  exit-code: %d\n  stdout:\n%s' % (self.cmd,self.err.returncode,self.err.output)

def shell_exec(command):
    formatted_msg(None, 'running %s' % command)
    try:
        output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT)
        note(output)
    except subprocess.CalledProcessError as fail:
        raise NonZeroExitBuildError(command,fail)

class BuildStyle(object):
    Debug = 1
    Release = 2

    @classmethod
    def fromString(cls, txt):
        if txt == 'release': return BuildStyle.Release
        if txt != 'debug': warning('selected build style %s is not debug or release - defaulting to debug' % txt)
        return BuildStyle.Debug

    @classmethod
    def toCommandLineOption(cls,self):
        if self == BuildStyle.Debug: return '-g -Onone'
        if self == BuildStyle.Release: return '-O'
        return None

class Settings(object):
    def __init__(self):
        pass
    
    def parse(self, args):
        self.buildStyle = BuildStyle.fromString(args.build_style)
        self.swiftCompiler = os.path.abspath(args.swiftc)
        if args.foundation:
            self.foundation = os.path.abspath(args.foundation)
        else:
            X = os.path.split(os.path.abspath(os.path.join(os.path.dirname(self.swiftCompiler),"..")))
            self.foundation = os.path.join(X[0],X[1].replace('swift-','foundation-'),'Foundation')
            note('foundation defaulted to "%s" based on compiler path' % self.foundation)
        if args.build_dir:
            self.buildDir = os.path.abspath(args.build_dir)
        else:
            self.buildDir = "/tmp"
            note('build-dir defaulted to /tmp')
        if args.swift_build_dir:
            self.swiftBuildDir = os.path.abspath(args.swift_build_dir)
        else:
            self.swiftBuildDir = os.path.abspath(os.path.join(os.path.dirname(self.swiftCompiler),'..'))
            note('swift-build-dir defaulted to "%s" based on compiler path' % self.swiftBuildDir)
        self.swiftAutolinkExtractPath = os.path.abspath(os.path.join(self.swiftBuildDir,'bin','swift-autolink-extract'))
        if args.module_path:
            self.moduleInstallPath = os.path.abspath(args.module_path)
        else:
            self.moduleInstallPath = None
        if args.lib_path:
            self.libraryInstallPath = os.path.abspath(args.lib_path)
        else:
            self.libraryInstallPath = None
        if not os.path.exists(self.swiftCompiler):
            error('%s not a valid compiler path' % self.swiftCompiler)
            sys.exit(1)
        if not os.path.exists(self.foundation):
            error('%s not a valid Foundation path' % self.foundation)
            sys.exit(1)
        if not os.path.exists(self.swiftBuildDir):
            error('%s not a valid swift build path' % self.swiftBuildDir)
            sys.exit(1)
        if (self.moduleInstallPath and not self.libraryInstallPath) or (self.libraryInstallPath and not self.moduleInstallPath):
            warning('both module and lib path required for installation - not installing')

    def __str__(self):
        s = ""
        for x in self.__dict__:
            s += "%s --> %s\n" % (x,self.__dict__[x])
        return s

SETTINGS = Settings()

class Target(object):
    def __init__(self, settings):
        self.settings = settings
    
    def description(self):
        return 'You should never see this'
    
    def build(self):
        return True

class CreateBuildDirectory(Target):
    def __init__(self, settings):
        Target.__init__(self, settings)
    
    def description(self):
        return 'create the destination path'
    
    @classmethod
    def mkdirp(cls,path):
        try:
            os.makedirs(path)
        except OSError as exc:
            if exc.errno == errno.EEXIST and os.path.isdir(path):
                pass
            else:
                raise
    
    def build(self):
        CreateBuildDirectory.mkdirp(self.settings.buildDir)
        return True

class GenerateBOM(Target):
    def __init__(self, settings):
        Target.__init__(self, settings)
    
    def description(self):
        return 'ingest PlaygroundLogger.bom'
    
    @classmethod
    def platform(cls):
        if sys.platform.startswith('linux'): return "linux"
        return sys.platform
    
    @classmethod
    def processLine(cls, line):
        if line.startswith('#'): return ''
        return line.strip()
    
    def build(self):
        self.settings.BOMFilePath = os.path.join(SOURCE_DIR,PROJECT_NAME,"%s-%s.bom" % (PROJECT_NAME,GenerateBOM.platform()))
        if os.path.exists(self.settings.BOMFilePath):
            self.settings.bom = set([GenerateBOM.processLine(line) for line in open(self.settings.BOMFilePath)])
        else:
            self.settings.bom = set()

class BuildObjectFile(Target):
    def __init__(self, settings):
        Target.__init__(self, settings)
    
    def description(self):
        return 'compile PlaygroundLogger.o'
    
    def build(self):
        self.settings.objectFilePath = "%s.o" % (os.path.join(self.settings.buildDir,PROJECT_NAME))
        self.settings.moduleFilePath = "%s.swiftmodule" % (os.path.join(self.settings.buildDir,PROJECT_NAME))
        sources = glob.glob(os.path.join(SOURCE_DIR,PROJECT_NAME,"*.swift"))
        command = '"%s" %s -I "%s" -I "%s" -L "%s" -Xlinker -rpath -Xlinker "%s" -parse-as-library -emit-object -module-name %s -o "%s" -force-single-frontend-invocation -module-link-name %s -emit-module-path "%s" ' % \
                                               (self.settings.swiftCompiler,
                                                BuildStyle.toCommandLineOption(self.settings.buildStyle),
                                                self.settings.foundation,
                                                os.path.join(self.settings.foundation,'usr','lib','swift'),
                                                self.settings.foundation,
                                                self.settings.foundation,
                                                PROJECT_NAME,
                                                self.settings.objectFilePath,
                                                PROJECT_NAME,
                                                self.settings.moduleFilePath)
        for source in sources:
            if os.path.basename(source) in self.settings.bom:
                warning('"%s" skipped due to being present in the BOM file' % source)
            else:
                command += "%s " % source
        
        shell_exec(command)

class CreateAutolinkExtractFile(Target):
    def __init__(self, settings):
        Target.__init__(self, settings)
    
    def description(self):
        return 'compile PlaygroundLogger.autolink'

    def build(self):
        self.settings.autolinkFilePath = "%s.autolink" % (os.path.join(self.settings.buildDir,PROJECT_NAME))
        command = '"%s" "%s" -o "%s"' % (self.settings.swiftAutolinkExtractPath,
                                         self.settings.objectFilePath,
                                         self.settings.autolinkFilePath)
        shell_exec(command)

class CreateModulewrapObjectFile(Target):
    def __init__(self, settings):
        Target.__init__(self, settings)
    
    def description(self):
        return 'modulewrap into PlaygroundLoggerMV.o'
        
    def build(self):
        self.settings.modulewrapFilePath = "%sMV.o" % (os.path.join(self.settings.buildDir,PROJECT_NAME))
        command = '"%s" -modulewrap "%s" -o "%s"' % (self.settings.swiftCompiler,
                                                     self.settings.moduleFilePath,
                                                     self.settings.modulewrapFilePath)
        shell_exec(command)

class LinkDynamicLibrary(Target):
    def __init__(self, settings):
        Target.__init__(self, settings)
    
    def description(self):
        return 'link libPlaygroundLogger.so'
    
    def build(self):
        self.settings.dylibPath = os.path.join(self.settings.buildDir,"lib%s.so" % PROJECT_NAME)
        command = 'clang "%s" "%s" -shared @"%s" -o "%s" -L "%s" -Wl,--no-undefined -Wl-soname,lib%s.so -L "%s" -lswiftCore -lFoundation -lswiftStdlibUnittest -lswiftGlibc -Xlinker -T "%s"' % \
                            (self.settings.objectFilePath,
                             self.settings.modulewrapFilePath,
                             self.settings.autolinkFilePath,
                             self.settings.dylibPath,
                             self.settings.foundation,
                             PROJECT_NAME,
                             os.path.join(self.settings.swiftBuildDir,'lib','swift','linux'),
                             os.path.join(self.settings.swiftBuildDir,'lib','swift','linux','x86_64','swift.ld'))

        shell_exec(command)

class BuildTestDriver(Target):
    def __init__(self, settings):
        Target.__init__(self, settings)
    
    def description(self):
        return 'build PlaygroundLogger_TestDriver'
    
    def build(self):
        self.settings.testDriverPath = os.path.join(self.settings.buildDir,"%s_TestDriver" % PROJECT_NAME)
        sources = glob.glob(os.path.join(SOURCE_DIR,"%s_TestDriver" % PROJECT_NAME,"*.swift"))
        command = '"%s" %s -o "%s" -I "%s" -L "%s" -I "%s" -L "%s" -I "%s" -lFoundation -lPlaygroundLogger -Xlinker -rpath -Xlinker "%s" -Xlinker -rpath -Xlinker "%s" ' % \
                    (self.settings.swiftCompiler,
                     BuildStyle.toCommandLineOption(self.settings.buildStyle),
                     self.settings.testDriverPath,
                     self.settings.buildDir,
                     self.settings.buildDir,
                     self.settings.foundation,
                     self.settings.foundation,
                     os.path.join(self.settings.foundation,'usr','lib','swift'),
                     self.settings.foundation,
                     self.settings.buildDir)

        for source in sources:
            command += "%s " % source

        shell_exec(command)

class RunTestDriver(Target):
    def __init__(self, settings):
        Target.__init__(self, settings)
    
    def description(self):
        return 'run PlaygroundLogger_TestDriver'
    
    def build(self):
        shell_exec(self.settings.testDriverPath)

class Install(Target):
    def __init__(self, settings):
        Target.__init__(self, settings)
    
    def description(self):
        return 'install PlaygroundLogger'
    
    def build(self):
        if self.settings.moduleInstallPath and self.settings.libraryInstallPath:
            shutil.copy(self.settings.dylibPath,self.settings.libraryInstallPath)
            shutil.copy(self.settings.moduleFilePath,self.settings.moduleInstallPath)
        else:
            note('skipping installation')

TARGETS = []

def main():
    colorama.init()
    parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter,
                                     description="Build %s" % PROJECT_NAME)
    parser.add_argument("--swiftc",
                        help="path to the swift compiler",
                        metavar="PATH",
                        action="store",
                        dest="swiftc",
                        required=True,
                        default=None)
    parser.add_argument("--foundation",
                        help="path to the Foundation build",
                        metavar="PATH",
                        action="store",
                        dest="foundation",
                        required=False,
                        default=None)
    parser.add_argument("--build-dir",
                        help="path to the output build directory",
                        metavar="PATH",
                        action="store",
                        dest="build_dir",
                        required=False,
                        default=None)
    parser.add_argument("--swift-build-dir",
                        help="path to the swift build directory",
                        metavar="PATH",
                        action="store",
                        dest="swift_build_dir",
                        required=False,
                        default=None)
    parser.add_argument("--module-install-path",
                        help="location to install module files",
                        metavar="PATH",
                        action="store",
                        dest="module_path",
                        default=None)
    parser.add_argument("--library-install-path",
                        help="location to install shared library files",
                        metavar="PATH",
                        action="store",
                        dest="lib_path",
                        default=None)
    parser.add_argument("--debug",
                        help="builds for debug (the default)",
                        action="store_const",
                        dest="build_style",
                        const="debug",
                        default="debug")
    parser.add_argument("--release",
                        help="builds for release",
                        action="store_const",
                        dest="build_style",
                        const="release",
                        default="debug")
    args = parser.parse_args()

    SETTINGS.parse(args)
    print SETTINGS
    
    TARGETS.append(CreateBuildDirectory)
    TARGETS.append(GenerateBOM)
    TARGETS.append(BuildObjectFile)
    TARGETS.append(CreateAutolinkExtractFile)
    TARGETS.append(CreateModulewrapObjectFile)
    TARGETS.append(LinkDynamicLibrary)
    TARGETS.append(BuildTestDriver)
    TARGETS.append(RunTestDriver)
    TARGETS.append(Install)

    for ctarget in TARGETS:
        target = ctarget(SETTINGS)
        note("building '%s'" % target.description())
        try:
            status = target.build()
        except BuildError as b:
            status = b
        except Exception as e:
            status = UncaughtExceptionBuildError(e)
        if status or (status is None):
            note('built successfully')
        else:
            error('build error: %s' % status)
            sys.exit(1)

if __name__ == '__main__':
    main()
