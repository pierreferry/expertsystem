class Graph
	attr_accessor :nodes

	def initialize
		@nodes = Hash.new
	end

	def node(name)
		@nodes[name]
	end

	def add_node(node)
		raise "#{node.class} != Node" if node.class != Node
		@nodes[node.name] = node
	end
end
