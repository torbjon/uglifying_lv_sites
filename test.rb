require 'uglifier'

u = Uglifier.compile(File.read("test.js"), :toplevel => true, :toplevel => true, :beautify => false)

puts u