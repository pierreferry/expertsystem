class Node
	attr_accessor :name, :children, :status, :rules

	def initialize(opts = {})
		@name = opts[:name]
		@status = false
		@rules = Array.new
		@children = Array.new
	end

	def addRule(rule)
		@rules.push(rule)
	end

	def evalRules
		result = Array.new
		@rules.each do |rule|
			string = rule.dup
			('A'..'Z').each do |char|
				string.gsub!(char, $graph.node(char).status.to_s) if $graph.node(char)
			end
			string.gsub!('+', '&')
			begin
				result.push(eval(string))
			rescue SyntaxError
				abort "Syntax error: '#{rule}' rule caused the issue"
			end
		end
		if result.include?(true)
			return true
		else
			return false
		end
	end

	def changeStatus
		newstatus = self.evalRules
		if newstatus != @status
			@status = newstatus
			@children.each do |child|
				child.changeStatus
			end
		end
	end
end
