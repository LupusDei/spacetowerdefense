require File.expand_path(File.dirname(__FILE__) + "/spec_helper")
require "geometry/path.rb"

describe "A Path with two blocks next to each other" do
  #   (250,250) **********K
  #             *    * obs*  
  #   (250,290) O**********          
  before do
    @path = Path.new
    @block_top = 250
    @block_left = 250
    @obstacle_top = 250
    @obstacle_left = 290
    @O_x = @block_left - CREEP_RADIUS 
    @O_y = @block_top + Block::SIZE + CREEP_RADIUS 
    @K_x = @block_left + 2*Block::SIZE + CREEP_RADIUS

    @path.add(Block.new(@block_left,@block_top))
    @path.add(Block.new(@obstacle_left,@obstacle_top))
    @path.find_path
  end     

  it "should use point O in the path" do
    @path.nodes[1].value.should_not == nil
    @path.nodes[0].next_node.x.should == @O_x
    @path.nodes[0].next_node.y.should == @O_y
  end
   
  it "should find the fastest next move to its goal" do
    move = @path.find_best_move(@path.nodes[0])
    new_node = move.other_node(@path.nodes[0])
    new_node.x.should == @O_x
    new_node.y.should == @O_y
    new_node.x.should == @path.nodes[0].next_node.x
    new_node.y.should == @path.nodes[0].next_node.y
  end
   
  it "should find the fastest path as a series of nodes" do
    best_path = @path.find_best_path(@path.nodes[0], @path.nodes[1])
    best_path.length.should == 3
    best_path[1].x.should == @O_x
    best_path.last.x.should == 500
  end 
  
  it "should have creep that can find there way to the fastest path" do
    @path.add_creep_node(100, 50)
    @path.navigate_creep(@path.creep_nodes.last)
    @path.creep_nodes.last.next_node.x.should == @K_x
  end
end

describe Path do
  
  before do
    @path = Path.new
  end
  
  it "should initialize with a possible path with 2 points, start and end" do
        @path.x.first.should == 0
        @path.x.last.should == 500
        @path.y.first.should == 0
        @path.y.last.should == 500
      end
      
      it "should be able to make a block" do
        block = Block.new(250,250)
        point = 250,250
        block.top_left.should == point
        point = 290, 290
        block.bottom_right.should == point
      end
      
      it "should be able to add obsticals" do
        block = Block.new(250,250)
        @path.add(block)
        @path.obsticals.last.should == block
      end
      
      it "should be able to delete obsticals" do
        block = Block.new(250,250)
        @path.add(block)
        @path.obsticals.length.should == 1
        @path.delete_obstical(block)
        @path.obsticals.length.should == 0
      end
      
      it "should be able to merge blocks to horizonaly only" do
        @path.add(Block.new(250,250))
        @path.add(Block.new(290,250))
        @path.add(Block.new(210,250))
        @path.add(Block.new(330,250))
        @path.obsticals.length.should == 4
        points = 290,250
        @path.obsticals[0].top_right.should == points
        @path.merge
        @path.obsticals.length.should == 1
        points = 370,250
        @path.obsticals[0].top_right.should == points
      end
    
      it "should be able to check for intersections with blocks" do
        @path.add(Block.new(250, 250))
        intersection = 250,250, "top"
        @path.find_intersections(@path.nodes[0],@path.nodes[1],Block.new(250, 250)).should == intersection
      end
      
      it "should find intersections from below" do
        a,b,c = @path.find_intersections(@path.nodes[1],@path.nodes[0],Block.new(250,250))
        a.should_not == false
      end
      
      it "should be able to add nodes and return if the node already exists" do
        @path.add_node(20,20).should == true
        @path.add_node(40,40).should == true
        @path.add_node(40,40).should == false
        @path.add_node(20,20).should == false
      end
      
      it "should be able to remove nodes" do
        @path.add_node(20,20).should == true
        @path.add_node(40,40).should == true
        @path.remove_node(@path.nodes.last)
        @path.nodes.length.should == 3
        @path.nodes[2].edges.length.should == 0
      end
      
      it "should have nodes with an x,y" do
        node = Path::Node.new(1,1)
        node.x.should == 1
        node.y.should == 1
      end
      it "should have edges with a start node, end node, and length" do
        node1 = Path::Node.new(1,1)
        node2 = Path::Node.new(1,2)
        edge = Path::Edge.new(node1,node2)
        edge.node1.should == node1
        edge.node2.should == node2
        edge.length.should == 1
      end
      
      it "should have a list of all the nodes" do
        @path.nodes.length.should == 2
        @path.nodes[0].x.should == 0
        @path.nodes[0].edges[0].other_node(@path.nodes[0]).x.should == 500 #great test :)
      end
      
      it "should generate a node for all corners of blocks" do
        @path.add(Block.new(250, 250))
        @path.find_nodes()
        @path.nodes.length.should == 6
      end
     
     it "should make edges between all possibly connectable nodes" do
       @path.add(Block.new(250,250))
       @path.find_nodes
       @path.find_edges
       @path.nodes.length.should > 3
       @path.nodes[0].edges.length.should == 3
       @path.nodes[1].edges.length.should == 3
       @path.nodes[2].edges.length.should >= 3
     end
     
   it "should find the fastest path in a complex maze" do
       @path.add(Block.new(60,20))
       @path.add(Block.new(100,20))
       x = 160
       (0..120).step(40) {|y| @path.add(Block.new(x,y))}
       @path.add(Block.new(120,100))
       @path.add(Block.new(80,100))
       x = 20
       (20..460).step(40) {|y| @path.add(Block.new(x,y))}
       @path.find_path
       best_path = @path.find_best_path(@path.nodes[0], @path.nodes[1])
       best_path.length.should == 6
     end
   
   it "should know register when obsticals are added" do
      @path.add(Block.new(60,20))
      @path.obsticals.length.should > 0
    end
     
     it "should detect intersections when starting on obstical" do
       node1 = Path::Node.new(20,141)
       node2 = Path::Node.new(61, 141)
       a,b,c = @path.find_intersections(node1,node2, Block.new(20,140))
       a.should_not == false
     end
       
     it "should detect an intersection through obsticals" do
       @path.add(Block.new(40,40))
       @path.add(Block.new(40,80))
       node1 = Path::Node.new(39,81)
       node2 = Path::Node.new(500,500)
       a,b,c = @path.find_intersections(node1,node2,@path.obsticals[1])
       a.should_not == false
     end
    
    it "should detect diagonal intersections" do
      @path.add(Block.new(60,80))
      @path.add(Block.new(100,40))
      node1 = Path::Node.new(95, 75)
      node2 = Path::Node.new(120, 85)
      a,b,c = @path.find_intersections(node1,node2,@path.obsticals[0])
    
      d,e,f = @path.find_intersections(node1,node2,@path.obsticals[1])
      a.should == false
      e.should_not == false
    end
    
    it "should detect more diagonal intersections" do
      @path.add(Block.new(20,100))
      node1 = Path::Node.new(21,101)
      node2 = Path::Node.new(52, 148)
      a,b,c = @path.find_intersections(node1,node2, @path.obsticals.last)
      a.should_not == false
    end
    
    it "should be able to detect a sneaky entry from to right to left" do
      @path.add(Block.new(20,100))
      node2 = Path::Node.new(12,148)
      node1 = Path::Node.new(60, 110)
      a,b,c = @path.find_intersections(node1,node2, @path.obsticals.last)
      a.should_not == false
    end
    
    
    it "should solve systems correctly" do
     #y-y1 = m(x-x1)
     #mx - y = d
     x,y = @path.solve_system(1,-1,4,1,1,0)
     x.should == 2
     y.should == -2
   end
   
     it "should not have repeated nodes" do 
         @path.add(Block.new(40,40))
         @path.add(Block.new(80,40))
         @path.find_nodes
         @path.nodes.length.should == 6
       end
       
       it "should know if it is unreachable when there is a left to right connection" do
         y = 40
         (0..440).step(40) {|x| @path.add(Block.new(x,y))}
         @path.should_not be_unreachable
         @path.add(Block.new(460,80))
         @path.should be_unreachable
       end
       
       it "should know if it is unreachable when there is a top to bottom connection" do
         x = 40
         (0..440).step(40) {|y| @path.add(Block.new(x,y))}
         @path.should_not be_unreachable
         @path.add(Block.new(80,460))
         @path.should be_unreachable
       end
       
       it "should know if it is unreachable when there is a top left connection" do
         @path.add(Block.new(40,0))
         @path.add(Block.new(0,40))
         @path.add(Block.new(40,40))
         @path.should be_unreachable
       end
       
       it "should know if it is unreachable when there is a bottom right connection" do
         @path.add(Block.new(460,460))
         @path.add(Block.new(500,460))
         @path.add(Block.new(460,500))
         @path.should be_unreachable
       end
     end
     
     describe Path::Node do
       
       it "should be able to add edges" do
         node = Path::Node.new(1,1)
         node2 = Path::Node.new(1,3)
         node.add(node2)
         node.edges.last.length.should == 2
       end
       
       it "should be able to have multiple edges with connections to other nodes" do
         node = Path::Node.new(1,1)
         node2 = Path::Node.new(1,3)
         node3 = Path::Node.new(3,1)
         node.add(node2)
         node.add(node3)
         node.edges[0].other_node(node).should == node2
         node.edges[1].other_node(node).should == node3
       end
       
       it "should have connections that go both ways between nodes" do
         node = Path::Node.new(1,1)
         node2 = Path::Node.new(1,3)
         node.add(node2)
         node.edges.last.other_node(node).should == node2
         node2.edges.last.other_node(node2).should == node 
       end
       
       it "should not be able to duplicate connections" do
         node = Path::Node.new(1,1)
         node2 = Path::Node.new(1,3)
         node.add(node2).should == true
         node2.add(node).should == false
         node.add(node2).should == false
         node.edges.length.should == 1
       end
       
       it "should be able to break connections on either side for both sides" do
         node = Path::Node.new(1,1)
         node2 = Path::Node.new(1,3)
         node.add(node2)
         node2.remove(node)
         node2.edges.length.should == 0
         node.edges.length.should == 0
       end
       
       it "should have a value, starting with nil" do
         node = Path::Node.new(1,1)
         node.value.should == nil
       end
       
       it "should know the next best node to go to" do
         node = Path::Node.new(1,1)
         node2 = Path::Node.new(3,3)
         node.next_node = node2
         node.next_node.should == node2
       end
     end
     
     describe Path::Edge do
       
       it "should be able to return the other node" do
         node = Path::Node.new(1,1)
         node2 = Path::Node.new(1,1)
         node.add(node2)
         node.edges.last.other_node(node).should == node2
       end
       
end
