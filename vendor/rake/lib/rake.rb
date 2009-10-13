#!/usr/bin/env ruby

#--

# Copyright 2003, 2004, 2005, 2006, 2007, 2008, 2009 by Jim Weirich (jim.weirich@gmail.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.
#++

RAKEVERSION = '0.8.99.3'

require 'rbconfig'
require 'fileutils'
require 'singleton'
require 'monitor'
require 'optparse'
require 'ostruct'

require 'rake/ext/module'
require 'rake/ext/string'
require 'rake/ext/time'

require 'rake/win32'

require 'rake/task_argument_error'
require 'rake/rule_recursion_overflow_error'
require 'rake/rake_module'
require 'rake/psuedo_status'
require 'rake/task_arguments'
require 'rake/invocation_chain'
require 'rake/task'
require 'rake/file_task'
require 'rake/file_creation_task'
require 'rake/multi_task'
require 'rake/dsl'
require 'rake/rake_file_utils'
require 'rake/file_list'
require 'rake/default_loader'
require 'rake/early_time'
require 'rake/name_space'
require 'rake/task_manager'
require 'rake/application'
require 'rake/environment'

$trace = false

# Alias FileList to be available at the top level.
FileList = Rake::FileList

# Include the FileUtils file manipulation functions in the top level module,
# but mark them private so that they don't unintentionally define methods on
# other objects.

include RakeFileUtils
private(*FileUtils.instance_methods(false))
private(*RakeFileUtils.instance_methods(false))
