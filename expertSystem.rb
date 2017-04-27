require_relative "fact"
require_relative "node"
require_relative "graph"

def getNodeList(rules)
	factsList = Array.new
	nodeList = Array.new

	rules.each do |rule|
		rule.each_char do |char|
			if char >= "A" && char <= "Z"
				factsList.push(char) unless factsList.include?(char)
			end
		end
	end
	factsList.each do |fact|
		nodeList.push(Node.new(name: fact))
	end
	return nodeList
end

def printQueries(queries, graph)
	queries.each_char do |char|
		if char >= "A" && char <= "Z"
			puts "#{char} is #{graph.node(char).status}"
		end
	end
end

def parseRules(graph, rules)
	rules.each do |rule|
		rule = rule.split("=>")
		implicate = rule[1].split("+")
		rule[0].each_char do |char|
			if char >= "A" && char <= "Z"
				implicate.each do |child|
					# Here i add the childs to the parent node
					graph.node(char).children.push(graph.node(child.strip)) unless graph.node(char).children.include?(child.strip)
				end
			end
		end
		# Adding the rule to the child node
		rule[0].split("+").each do |et|
			implicate.each do |child|
				graph.node(child.strip).addRule("and", graph.node(et.strip))
			end
		end
	end
	# Uncomment these lines to check child attribution
	# graph.nodes.each { |key, node|
	# 	puts "-------\nname : #{node.name}\nchilds: "
	# 	node.children.each { |child|
	# 		puts "#{child.name}"
	# 	}
	# }
end

def setupInitialFacts(graph, initialFacts)
	puts initialFacts
	initialFacts.each_char do |char|
		if char >= "A" && char <= "Z"
			graph.node(char).status = true
		end
	end
end

def expertSystem(file)
	if File.exist?(file)
		buffer = File.read(file)
		rules = Array.new
		initialFacts = String.new
		queries = String.new

		buffer.each_line do |line|
			if line[0] != "#" && line[0] != "=" && line[0] != "?"
				line = line.strip
				rules.push(line) unless line.empty?
			elsif line[0] == "="
				initialFacts = line.strip
			elsif line[0] == "?"
				queries = line.strip
			end
		end

		graph = Graph.new
		nodeList = getNodeList(rules)
		nodeList.each { |node| graph.add_node(node) }
		parseRules(graph, rules)
		setupInitialFacts(graph, initialFacts)
		graph.nodes.each do |key, node|
			node.changeStatus
		end
		puts "Rules: #{rules.to_s}"
		# puts "initialFacts: #{initialFacts.to_s}"
		# puts "Queries: #{queries.to_s}"
		# puts "nodeList:"
		# nodeList.each{|node| puts node.name}
		# graph.nodes.each { |key, node| puts node.status }

		# graph.nodes.each { |key, node|
		# 	puts "Name: #{node.name} \n Rules: "
		# 	node.rules.each do |keyy, rule|
		# 		puts "#{rule.name}"
		# 	end
		# }

		# graph.node("B").rules.each { |key, rule|
		# 	rule.each { |r| puts r.name }
		# }
		# graph.node("A").children.push graph.node("B")
		# graph.nodes.each { |key, node| puts "#{node.name} is #{node.status}"}

		# graph.node("B").changeStatus
		# graph.node("B").addRule(graph.node("A").status)


		# graph.nodes.each { |key, node| puts "#{node.name} is #{node.status}"}
		printQueries(queries, graph)
	else
		puts "Error: " << file << " not found."
	end
end
