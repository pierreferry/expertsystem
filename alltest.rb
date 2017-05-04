#!/Users/pferry/.rvm/rubies/ruby-2.3.3/bin/ruby

require_relative 'expertSystem'
require 'colorize'

def main
	dir = Dir.entries("./tests")

	dir.each do |file|
		if file[0] != '.'
			puts file.cyan
			expertSystem './tests/' << file
			puts "\n"
		end
	end
end

main
