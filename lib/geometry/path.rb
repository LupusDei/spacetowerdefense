require File.dirname(__FILE__) + '/block'
CREEP_RADIUS = 8
class NoIntersectionException < Exception
  def initialize(message="")
    super message
  end
end

class Path  
  
  attr_accessor :x,:y,:obsticals,:nodes, :best_path, :creep_nodes, :valued
  
  def initialize
    @x = [0,500]
    @y = [0,500]
    @nodes = [Node.new(@x[0],@y[0]),Node.new(@x[1],@y[1])]
    @nodes.first.add(@nodes.last)
    @nodes.first.next_node = @nodes.last
    @creep_nodes = []
    @best_path = [@nodes[0]]
    @obsticals = []
    @valued = false
  end
  
  def add_creep_node(x,y)
    @creep_nodes << Node.new(x,y)
    return @creep_nodes.last
  end
  
  def remove_creep_node(node)
    @creep_nodes.delete(node) if @creep_nodes != nil and @creep_nodes.length != 0
  end
  
  def add_node(x,y)
    duplicate = false
    @nodes.each do |node|
      duplicate = true if node.x == x and node.y == y
    end
    @nodes << Node.new(x,y) if duplicate == false
    return !duplicate
  end
  
  def remove_node(node)
    @nodes.delete_if {|x| x == node}
    @nodes.each {|x| node.remove(x)}
  end
  
  def add(obstical)
    return if obstical.nil?
    @obsticals << obstical
    make_connections(obstical)
    propogate_connections(obstical)
    
  end
  
  def delete_obstical(obstical_to_be_deleted)
    index = 888888
    @obsticals.length.times {|i| index = i if @obsticals[i].top_left == obstical_to_be_deleted.top_left}
    if index != 888888
      @obsticals.delete_at(index)
    end
    reconnect_obsticals
  end
  
  def reconnect_obsticals
    @obsticals.each {|obstical| obstical.disconnect}
    @obsticals.each {|obstical| make_connections(obstical); propogate_connections(obstical)}
  end
  
  def unreachable?
    @obsticals.each do |obstical|
      return true if obstical.connected_to_right? and obstical.connected_to_left?
      return true if obstical.connected_to_top? and obstical.connected_to_bottom?
      return true if obstical.connected_to_top? and obstical.connected_to_left?
      return true if obstical.connected_to_bottom? and obstical.connected_to_right?
    end
    return false
  end
  
  def make_connections(block)
    x,y = block.top_left
    if y == 0
      block.connect_to_top
    end
    if y == 460
      block.connect_to_bottom
    end
    if x == 0
      block.connect_to_left
    end
    if x == 460
      block.connect_to_right
    end
  end
  
  def propogate_connections(block)
    connections = []
    propogate_remaining_connections(block, connections)
  end
  
  def propogate_remaining_connections(block, connections)
    return if (connections.include? block)
    connections << block
    @obsticals.each do |neighbor|
      if block.neighbor?(neighbor)
        block.connect_to neighbor
        propogate_remaining_connections(neighbor, connections)
      end
    end
  end
  
  def get_distance(x1,y1,x2,y2)
    return Math.sqrt((x1 - x2)**2 + (y1 - y2)**2)
  end
  
  def merge
    first = nil
    change = true
    while change == true
      change = false
      @obsticals.each do |obstical|
        first = obstical if first.nil?
        if obstical.top_right == first.top_left and obstical.bottom_right == first.bottom_left
          obstical = obstical.combine_right(first) 
          @obsticals.delete(first)
          first = nil
          change = true
        elsif obstical.top_left == first.top_right and obstical.bottom_left == first.bottom_right
          obstical = obstical.combine_left(first) 
          @obsticals.delete(first)
          first = nil
          change = true
        elsif obstical.bottom_left == first.top_left and obstical.bottom_right == first.top_right
          obstical = obstical.combine_bottom(first) 
          @obsticals.delete(first)
          first = nil
          change = true
        elsif obstical.top_left == first.bottom_left and obstical.top_right == first.bottom_right
          obstical = obstical.combine_top(first) 
          @obsticals.delete(first)
          first = nil
          change = true
        end
      end
    end
  end
  
  def navigate_creep(creep_node)
    i = @creep_nodes.index(creep_node)
    if i > 0 
      if creep_node.x < 20 and creep_node.y < 15 and creep_node.next_node.nil?
        if @creep_nodes[i - 1] != nil
          if @creep_nodes[i-1].next_node != nil and @creep_nodes[i-1].x < 30 and @creep_nodes[i-1].y < 30
            creep_node.next_node = @creep_nodes[i-1].next_node
            return
          end
        end
      end
    end
    if creep_node.next_node != nil
      x = (creep_node.x - creep_node.next_node.x)
      y = (creep_node.y - creep_node.next_node.y) 
      if (-2..2) === y and (-2..2) === x
        creep_node.next_node = creep_node.next_node.next_node
        return
      end
      return
    end
    @nodes.each do |other|
      creep_node.add(other) if is_clear_path?(creep_node, other)
    end
    if @valued
      move = nil
      loops = 0
      until move != nil do
        find_path if loops > 0
        move = find_best_move(creep_node) 
        loops += 1
      end
      creep_node.next_node = move.other_node(creep_node)
    else
      creep_node.next_node = @nodes[1]
    end
  end
      
  def find_path
    @creep_nodes.each {|node| node.next_node = nil}
    find_nodes
    find_edges
    find_values(@nodes[1])
    @valued = true
  end
  
  # def find_nodes()
  #    # merge
  #    dictionaryx = []
  #    dictionaryy = []
  #    @nodes = [Node.new(0,0), Node.new(500,500)]
  #    @obsticals.each do |obstical|
  #      x,y = obstical.top_right
  #      flag = false
  #      dictionaryx.length.times {|i| flag = true if dictionaryx[i] == x && dictionaryy[i] == y }
  #      add_node(x + CREEP_RADIUS,y - CREEP_RADIUS) if flag == false && x != 500 && y != 0
  #      dictionaryx << x
  #      dictionaryy << y
  #      x,y = obstical.top_left
  #      flag = false
  #      dictionaryx.length.times {|i| flag = true if dictionaryx[i] == x && dictionaryy[i] == y }
  #      add_node(x - CREEP_RADIUS,y - CREEP_RADIUS) if !flag && x != 0 && y != 0
  #      dictionaryx << x
  #      dictionaryy << y
  #      x,y = obstical.bottom_right
  #      flag = false
  #      dictionaryx.length.times {|i| flag = true if dictionaryx[i] == x && dictionaryy[i] == y }
  #      add_node(x + CREEP_RADIUS,y + CREEP_RADIUS) if !flag && x != 500 && y != 500
  #      dictionaryx << x
  #      dictionaryy << y
  #      x,y = obstical.bottom_left
  #      flag = false
  #      dictionaryx.length.times {|i| flag = true if dictionaryx[i] == x && dictionaryy[i] == y }
  #      add_node(x - CREEP_RADIUS,y + CREEP_RADIUS) if !flag && x != 0 && y != 500
  #      dictionaryx << x
  #      dictionaryy << y   
  #    end      
  #  end
  
  def find_nodes
    dictionary = {}
    corner_index = {}
    @nodes = [Node.new(0,0), Node.new(500,500)]
    @obsticals.each do |obstical|
      if dictionary[obstical.top_left].nil?
        dictionary[obstical.top_left] = 1
        corner_index[obstical.top_left] = "top_left"
      else
        dictionary[obstical.top_left] += 1
      end
      if dictionary[obstical.top_right].nil?
        dictionary[obstical.top_right] = 1
        corner_index[obstical.top_right] = "top_right"
      else
        dictionary[obstical.top_right] += 1
      end
      if dictionary[obstical.bottom_left].nil?
        dictionary[obstical.bottom_left] = 1
        corner_index[obstical.bottom_left] = "bottom_left"
      else
        dictionary[obstical.bottom_left] += 1
      end
      if dictionary[obstical.bottom_right].nil?
        dictionary[obstical.bottom_right] = 1
        corner_index[obstical.bottom_right] = "bottom_right"
      else
        dictionary[obstical.bottom_right] += 1
      end
    end
    to_be_deleted = []
    dictionary.each do |key, value|
      to_be_deleted << key if value > 1
      corner_index.delete(key) if value > 1
    end
    to_be_deleted.each {|key| dictionary.delete(key)}
    corner_index.each do |key, value|
      x,y = key
      add_node(x + CREEP_RADIUS,y - CREEP_RADIUS) if value == "top_right" && x != 500 && y != 0
      add_node(x - CREEP_RADIUS,y - CREEP_RADIUS) if value == "top_left" && x != 0 && y != 0
      add_node(x + CREEP_RADIUS,y + CREEP_RADIUS) if value == "bottom_right" && x != 500 && y != 500
      add_node(x - CREEP_RADIUS,y + CREEP_RADIUS) if value == "bottom_left" && x != 0 && y != 500
    end
  end   
  
  def find_edges(nodes = @nodes)
    (nodes.length - 1).times do |i|
      (i).upto(nodes.length - 1) do |j|
        nodes[i].add(nodes[j]) if is_clear_path?(nodes[i], nodes[j])
      end
    end
  end
  
  def find_values(destination = Node.new(500,500), changed_nodes_before = [])
    if destination.value != 0
      changed_nodes_before << destination
      destination.value = 0
    end
    changed_nodes = []
    changed_nodes_before.each do |node|
      node.edges.each do |edge|
        other = edge.other_node(node)
        value = node.value + edge.length
        if (other.value.nil? || other.value > value)
          other.value = value
          other.next_node = node
          changed_nodes << other if !changed_nodes.include?(other)
        end
      end
    end
    return if changed_nodes.length == 0
    find_values(destination,changed_nodes)
  end
  
  def find_best_move(start)
    return if @valued == false
    value_of_move = 0
    final_value = nil
    final_move = nil
    start.edges.each do |edge|
      if edge.other_node(start).value.nil? 
        next
      end
      value_of_move = edge.length + edge.other_node(start).value
      final_move = edge if final_move.nil? || value_of_move < final_value
      final_value = value_of_move if final_value.nil? || value_of_move < final_value
    end
    return final_move
  end
  
  def find_best_path(start, destination)
    best_path = [start]
    other_node = nil
    until other_node == destination do
         other_node = find_best_move(best_path.last).other_node(best_path.last)
         best_path << other_node
       end
    return best_path
  end
    
  
  def is_clear_path?(node1,node2)
    return if node1.x == node2.x and node1.y == node2.y
    @obsticals.each do |obstical|
      a,b,c = find_intersections(node1,node2,obstical)
      return false if(a.is_a?(Float) or a.is_a?(Fixnum))
    end
    return true
  end
  
  def get_obstical_of_intersection(node1,node2)
    @obsticals.each do |obstical|
      return obstical if find_intersections(node1,node2,obstical) != false
    end
    return false
  end
  
  def find_intersections(node1, node2, obstical)
    d = 0
    m = 0
    if node1.x == node2.x
      m = 1.0/0
      d = 999999
    else
      m = (node1.y - node2.y) / (node1.x - node2.x).to_f
      d = (m * (-1 * node1.x) + node1.y)
    end   #formula: mx - y = -d
    x,y,side = evaluate_intersections(m,d,node1,node2,obstical)
    return x,y, side
  end
  
  def evaluate_intersections(m,d,node1,node2,obstical)
    x1, y1 = obstical.top_left
    x2, y2 = obstical.bottom_right
    if node1.x == node2.x
      if node1.x >= x1 and node1.x <= x2 
        return node1.x, y1 if (node1.y <= y1 && node2.y >= y1) or (node2.y <= y1 && node1.y >= y1)
        return node1.x, y2 if (node1.y <= y2 && node2.y >= y2) or (node2.y <= y2 && node1.y >= y2)
      end
      return false,false,false
    end
    if node1.y == node2.y
      if node1.y >= y1 and node1.y <= y2
        return x1, node1.y if (node1.x <= x1 and node2.x >= x1) or (node2.x <= x1 and node1.x >= x1)
        return x2, node1.y if (node1.x <= x2 and node2.x >= x2) or (node1.x <= x2 and node2.x >= x2)
      end
      return false,false,false
    end
    greater_y = node1.y >= node2.y ? node1.y : node2.y
    lesser_y = node1.y <= node2.y ? node1.y : node2.y
    greater_x = node1.x >= node2.x ? node1.x : node2.x
    lesser_x = node1.x <= node2.x ? node1.x : node2.x
    x_top,y_top = solve_system(m,-1,-d,0,1,y1)
    if (y_top >= node1.y and y_top <= node2.y) or (y_top >= node2.y and y_top <= node1.y)
      return x_top,y_top, "top" if x_top >= x1 and x_top <= x2 and x_top >= lesser_x and x_top <= greater_x
    end
    x_bot, y_bot = solve_system(m,-1,-d,0,1,y2)
    if (y_bot >= node2.y and y_bot <= node1.y) or (y_bot <= node2.y and y_bot >= node1.y)
      return x_bot,y_bot, "bot" if x_bot >= x1 and x_bot <= x2 and x_bot >= lesser_x and x_bot <= greater_x
    end
    x_rt, y_rt = solve_system(m,-1,-d,1,0,x2)
    if (x_rt >= node2.x and x_rt <= node1.x) or (x_rt >= node1.x and x_rt <= node2.x)
      return x_rt,y_rt, "rt" if y_rt >= y1 and y_rt <= y2 and y_rt >= lesser_y and y_rt <= greater_y
    end
    x_lt, y_lt = solve_system(m,-1,-d,1,0,x1)
    if (x_lt >= node1.x and x_lt <= node2.x) or (x_lt >= node2.x and x_lt <= node1.x)
      return x_lt,y_lt, "lt" if y_lt >= y1 and y_lt <= y2 and y_lt >= lesser_y and y_lt <= greater_y
    end
    return false,false,false
  end
  
  def solve_system(a1,b1,d1,a2,b2,d2)
    x = (b2*d1 - b1*d2)/(a1*b2 - a2*b1)
    y = (a1*d2 - a2*d1)/(a1*b2 - a2*b1)
    return x,y
  end
  
  class Node
    attr_accessor :x,:y, :edges, :value, :next_node
    
    def initialize(x,y)
      @x = x
      @y = y
      @edges = []
      @value = nil
      @next_node = nil
    end
    
    def add(node)
      return false if node == self
      duplicate = false
      if @edges != nil
        @edges.each do |edge|
          duplicate = true if edge.other_node(self) == node
        end
      end    
      @edges << Path::Edge.new(self,node) if duplicate == false
      node.add(self) if duplicate == false
      return !duplicate
    end
    
    def remove(node)
      has_node = false
      this_edge = nil
      @edges.each do |edge|
        has_node = true and this_edge = edge if edge.other_node(self) == node
      end
      if has_node
        @edges.delete(this_edge)
        node.remove(self)
      end
      return has_node
    end
    
  end

  class Edge
    attr_accessor :node1,:node2
    
    def initialize(node1,node2)
      @node1 = node1
      @node2 = node2
    end
    
    def length
      return get_distance(node1.x,node1.y,node2.x,node2.y)
    end
    
    def get_distance(x1,y1,x2,y2)
      return Math.sqrt((x1 - x2)**2 + (y1 - y2)**2)
    end
    
    def other_node(node)
      return @node2 if node == @node1
      return @node1 if node == @node2
      return false
    end
    
  end
      
end


# 
# if side == "top"
#   node1.remove(node2)
#   node3 = Node.new(x,y)
#   if add_node(node3) #at intersection
#     node3.add(node1)
#     x,y = obstical.top_right
#     top_right_node = Node.new(x,y)
#     if add_node(top_right_node)
#       if is_clear_path?(node3,top_right_node)
#         top_right_node.add(node1) if is_clear_path?(top_right_node, node1)
#         top_right_node.add(node3)
#         top_right_node.add(node2) if draw_path(top_right_node,node2)
#       else
#         obst = get_obstical_of_intersection(top_right_node, node3)
#         remove_node(top_right_node)
#         x,y = obst.bottom_left
#         bot_left_node = Node.new(x,y)
#         draw_path(bot_left_node, node3) if add_node(bot_left_node)
#       end
#     end 
#     top_left_node = Node.new(obstical.top_left)   
#     if add_node(top_left_node)  
#       if is_clear_path?(top_left_node, node3)
#         top_left_node.add(node3)
#         top_left_node.add(node1) if is_clear_path?(top_left_node, node1)
#         bottom_left_node = Node.new(obstical.bottom_left)
#         if add_node(bottom_left_node)
#           if is_clear_path?(bottom_left_node, top_left_node)
#             top_left_node.add(bottom_left_node)
#             draw_path(bottom_left_node, node2)
#           else
#             remove(bottom_left_node)
#             obst = get_obstical_of_intersection
#             bot_right_node = Node.new(obst.bottom_right)
#             draw_path(bot_right_node,top_left_node)
#           end
#         else
#           remove(bottom_left_node)