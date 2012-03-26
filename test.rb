require 'uglifier'

puts Uglifier.compile(File.read("test.js"), :toplevel => true, :toplevel => true, :beautify => false)

