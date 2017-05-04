def checkRules(rules)
	rules.each do |rule|
		begin
			raise unless rule.include?("=>")
			rule.split("=>")[1].each_char do |chr|
				if (chr < 'A' || chr > 'Z') && chr != '+' && chr != ' '
					raise
				end
			end
		rescue
			puts "Rule: '#{rule}' contains syntax error but let's not make a big deal out of it and just remove it."
			rules.delete(rule)
		end
	end
	puts "Rules are empty..." if rules.empty?
end

def checkInitialFacts(str)
	begin
		raise "Initial Facts are empty" if str.empty?
	rescue
		puts "I found no string begginning with '=' so i assumed all facts are set to false"
	end
end

def checkQueries(str)
	str.each_char do |char|
		if char >= 'A' && char <= 'Z'
			begin
				if !$graph.node(char)
					raise "Query '#{char}' isn't listed in the rules."
				end
			rescue
				puts "Query '#{char}' isn't listed in the rules.. but let's not panic and make like we didn't see it."
				str.gsub!(char, '')
			end
		end
	end
		puts 'I found no valid query to make.' if str.empty? || !str[1]
end
