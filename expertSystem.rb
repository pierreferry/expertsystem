require_relative 'node'
require_relative 'graph'
require_relative 'checks'
require_relative 'magic'
require 'colorize'

def printQueries(queries)
	queries.each_char do |char|
		if char >= 'A' && char <= 'Z'
			if $graph.node(char)
				puts "#{char} is #{$graph.node(char).status.to_s.green}" if $graph.node(char).status
				puts "#{char} is #{$graph.node(char).status.to_s.red}" if !$graph.node(char).status
			end
		end
	end
end

def expertSystem(file)
	if File.exist?(file)
		buffer = File.read(file)
		rules = Array.new
		initialFacts = String.new
		queries = String.new
		comments = Array.new

		buffer.each_line do |line|
			if line[0] != "#" && line[0] != "=" && line[0] != "?"
				line = line.strip
				rules.push(line) unless line.empty?
			elsif line[0] == '='
				initialFacts = line.strip
			elsif line[0] == '?'
				queries = line.strip
			elsif line[0] == '#'
				comments.push(line.strip)
			end
		end
		checkRules(rules)
		checkInitialFacts(initialFacts)
		puts "Rules: #{rules}"
		puts "initialFacts: #{initialFacts.to_s}"
		puts comments
		createGraph(rules, initialFacts)
		checkQueries(queries)
		printQueries(queries)
	else
		puts "Error: #{file} file not found."
	end
end
