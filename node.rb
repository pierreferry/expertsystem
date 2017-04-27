class Node
	attr_accessor :name, :parent, :children, :status, :rules

	def initialize(opts = {})
		@name = opts[:name]
		@status = false
		@parent = opts[:parent]
		@rules = Hash.new

		# add children if passed an array or initialize as an empty array
		@children = opts[:children].is_a?(Array) ? opts[:children] : []
	end

	def addRule(key, node)
		@rules[key] ||= Array.new
		@rules[key].push(node)
	end

	def evalRules
		@rules.each do |key, rule|
			if key == "and"
				rule.each do |r|
					return false unless r.status
				end
				return true
			end
		end

		return false
	end

	def changeStatus
		if self.evalRules
			@status = true
			@children.each do |child|
				child.changeStatus
			end
		end
	end
end
