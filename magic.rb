def getNodeList(rules)
	factsList = Array.new
	nodeList = Array.new

	rules.each do |rule|
		rule.each_char do |char|
			if char >= 'A' && char <= 'Z'
				factsList.push(char) unless factsList.include?(char)
			end
		end
	end
	factsList.each do |fact|
		nodeList.push(Node.new(name: fact))
	end
	return nodeList
end

def parseRules(rules)
	rules.each do |rule|
		rule = rule.split("=>")
		implicate = rule[1].split("+")
		rule[0].each_char do |char|
			if char >= 'A' && char <= 'Z'
				implicate.each do |child|
					# Here i add the childs to the parent node
					$graph.node(char).children.push($graph.node(child.strip)) unless $graph.node(char).children.include?(child.strip)
				end
			end
		end
		# Adding the rule to the childs nodes
		implicate.each do |child|
			$graph.node(child.strip).addRule(rule[0])
		end
	end
end

def setupInitialFacts(initialFacts)
	initialFacts.each_char do |char|
		if char >= 'A' && char <= 'Z'
			begin
				if !$graph.node(char)
					raise "Initials Fact '#{char}' isn't listed in the rules."
				end
			rescue
				puts "Initials Fact '#{char}' isn't listed in the rules.. but let's not panic and make like we didn't see it."
				initialFacts.gsub!(char, '')
			else
				$graph.node(char).status = true
			end
		end
	end
end

def createGraph(rules, initialFacts)
	$graph = Graph.new

	nodeList = getNodeList(rules)
	nodeList.each { |node| $graph.add_node(node) }
	parseRules(rules)
	setupInitialFacts(initialFacts)
	initialFacts.each_char do |char|
		if char >= 'A' && char <= 'Z'
			$graph.node(char).children.each do |child|
				child.changeStatus
			end
		end
	end
end
