require 'rubygems'
require 'spec'

require "ffi"
include FFI

module TestLibrary
  FIXTURE_DIR = File.expand_path("../fixtures", __FILE__)
  PATH = File.join(FIXTURE_DIR, "build/libtest/libtest.#{FFI::Platform::LIBSUFFIX}")
  
  def self.need_to_compile_fixtures?
    !File.exist?(PATH) or Dir.glob(File.join(FIXTURE_DIR, "*")).any? { |f| File.mtime(f) > File.mtime(PATH) }
  end
  
  if need_to_compile_fixtures?
    puts "[!] Compiling Ruby-FFI fixtures"
    unless system("make -f #{File.join(FIXTURE_DIR, 'GNUmakefile')}")
      raise "Failed to compile Ruby-FFI fixtures"
    end
  end
end

module LibTest
  extend FFI::Library
  ffi_lib TestLibrary::PATH
end