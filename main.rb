require 'set'

class Graph
  attr_accessor :nodes, :edges

  def initialize
    @nodes = {}
    @edges = {}
  end

  def add_node(name)
    @nodes[name] = Node.new(name)
  end

  def add_edge(from_node, to_node, weight)
    @edges[from_node] ||= {}
    @edges[from_node][to_node] = weight
  end

  def dijkstra(start_node)
    distances = {}
    previous = {}
    unvisited = Set.new

    @nodes.each do |name, _|
      distances[name] = Float::INFINITY
      previous[name] = nil
      unvisited.add(name)
    end

    distances[start_node] = 0

    until unvisited.empty?
      current = unvisited.min_by { |node| distances[node] }
      unvisited.delete(current)

      break if distances[current] == Float::INFINITY

      @edges[current]&.each do |neighbor, weight|
        alt = distances[current] + weight
        if alt < distances[neighbor]
          distances[neighbor] = alt
          previous[neighbor] = current
        end
      end
    end

    return distances, previous
  end
end

class Node
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

# Example usage:
graph = Graph.new

# Add nodes
graph.add_node('A')
graph.add_node('B')
graph.add_node('C')
graph.add_node('D')
graph.add_node('E')

# Add edges
graph.add_edge('A', 'B', 4)
graph.add_edge('A', 'C', 2)
graph.add_edge('B', 'C', 5)
graph.add_edge('B', 'D', 10)
graph.add_edge('C', 'D', 3)
graph.add_edge('C', 'E', 8)
graph.add_edge('D', 'E', 7)

start_node = 'A'
distances, previous = graph.dijkstra(start_node)

puts "Shortest distances from #{start_node}:"
distances.each { |node, distance| puts "#{node}: #{distance}" }

puts "\nShortest paths:"
previous.each do |node, prev_node|
  path = []
  while prev_node
    path.unshift(prev_node)
    prev_node = previous[prev_node]
  end
  puts "#{start_node} -> #{node}: #{path.join(' -> ')}"
end
