require File.expand_path(File.dirname(__FILE__) + "/spec_helper")
require "geometry/path.rb"
require "geometry/block.rb"

describe Block do
  before do
    @path = Path.new
  end
  
  it "should know if it is not connected to the top" do
    middle_block = Block.new(250,250)
    @path.add(middle_block)
    middle_block.should_not be_connected_to_top 
  end
  it "should know if it is not connected to the bottom" do
    middle_block = Block.new(250,250)
    @path.add(middle_block)
    middle_block.should_not be_connected_to_bottom
  end
  it "should know if it is not connected to right of left" do
    middle_block = Block.new(250,250)
    @path.add(middle_block)
    middle_block.should_not be_connected_to_right
    middle_block.should_not be_connected_to_left
  end
  
  it "should know that if added to the top it is connected to the top" do
    topBlock = Block.new(250,0)
    @path.add(topBlock)
    topBlock.should be_connected_to_top
  end
  it "should know that if added to the bottom it is connected to the bottom" do
    bottom_block = Block.new(250,460)
    @path.add(bottom_block)
    bottom_block.should be_connected_to_bottom
  end
  it "should know that if added to the right or left it is connected to the them" do
    right_block = Block.new(460,460)
    left_block = Block.new(0,250)
    @path.add(right_block)
    @path.add(left_block)
    right_block.should be_connected_to_right
    left_block.should be_connected_to_left
  end
  
  it "should know that if it is added to a block that is connected to the top then it is connected to the top" do
    top_block = Block.new(250,0)
    under_block = Block.new(250,40)
    @path.add(top_block)
    @path.add(under_block)
    under_block.should be_connected_to_top
  end
  it "should know that if it is added to a block that is connected to the bottom then it is connected to bottom" do
    bottom_block = Block.new(250,460)
    above_block = Block.new(250, 420)
    @path.add(bottom_block)
    @path.add(above_block)
    above_block.should be_connected_to_bottom
  end
  it "should know that if it is added to a block that is connected to the left/right then it is connected to left/right" do
    right_block = Block.new(460,250)
    left_block = Block.new(0,250)
    right_of_left_block = Block.new(40,250)
    left_of_right_block = Block.new(420,250)
    @path.add(right_block)
    @path.add(left_block)
    @path.add(right_of_left_block)
    @path.add(left_of_right_block)
    right_of_left_block.should be_connected_to_left
    left_of_right_block.should be_connected_to_right
  end
  
  it "should know that it if is added to top any block beneath is connected to top" do
    top_block = Block.new(250,0)
    under_block = Block.new(250,40)
    @path.add(under_block)
    @path.add(top_block)
    under_block.should be_connected_to_top
  end
  it "should know that if it is added to the bottom, any block above and connected is connected to bottom" do
    bottom_block = Block.new(250,460)
    above_block = Block.new(250,420)
    @path.add(above_block)
    @path.add(bottom_block)
    above_block.should be_connected_to_bottom
  end
  it "should know that if it is added to right/left, any block adjacent and connected is connected to right/left" do
    right_block = Block.new(460,250)
    left_block = Block.new(0,250)
    right_of_left_block = Block.new(40,250)
    left_of_right_block = Block.new(420,250)
    @path.add(right_of_left_block)
    @path.add(left_of_right_block)
    @path.add(right_block)
    @path.add(left_block)
    right_of_left_block.should be_connected_to_left
    left_of_right_block.should be_connected_to_right
  end
  
  it "should, if added at the top, propogate the top connection to all blocks below" do
    top_block = Block.new(250,0)
    under_block = Block.new(250,40)
    way_under_block = Block.new(250,80)
    @path.add(under_block)
    @path.add(way_under_block)
    @path.add(top_block)
    way_under_block.should be_connected_to_top  
  end
  it "should, if added at the bottom, propogate the bottom connection to all blocks above" do
    bottom_block = Block.new(250,460)
    above_block = Block.new(250,420)
    way_above_block = Block.new(250,380)
    @path.add(above_block)
    @path.add(way_above_block)
    @path.add(bottom_block)
    way_above_block.should be_connected_to_bottom
  end
  it "should, if added at to right/left, propogate the right/left connection to all adjacent blocks" do
    right_block = Block.new(460,250)
    left_block = Block.new(0,250)
    right_of_left_block = Block.new(40,250)
    left_of_right_block = Block.new(420,250)
    right_of_right_of_left_block = Block.new(80,250)
    left_of_left_of_right_block = Block.new(380,250)
    @path.add(right_of_left_block)
    @path.add(left_of_right_block)
    @path.add(right_of_right_of_left_block)
    @path.add(left_of_left_of_right_block)
    @path.add(right_block)
    @path.add(left_block)
    right_of_right_of_left_block.should be_connected_to_left
    left_of_left_of_right_block.should be_connected_to_right
  end
    
  it "should not propogate top connections to blocks that are too far left or right" do
    top_block = Block.new(250,0)
    under_block = Block.new(200,40)
    @path.add(top_block)
    @path.add(under_block)
    under_block.should_not be_connected_to_top
  end
  it "should not propogate bottom connections to blocks that are too far left or right" do
    bottom_block = Block.new(250,460)
    above_block = Block.new(200,420)
    @path.add(bottom_block)
    @path.add(above_block)
    above_block.should_not be_connected_to_bottom
  end
  it "should not propogate right/left connections to blocks that are too far above or below" do
    right_block = Block.new(460,250)
    left_block = Block.new(0,250)
    below_left_block = Block.new(40,300)
    above_right_block = Block.new(420,200)
    @path.add(below_left_block)
    @path.add(above_right_block)
    @path.add(right_block)
    @path.add(left_block)
    above_right_block.should_not be_connected_to_right
    below_left_block.should_not be_connected_to_left
  end
  
  it "should  propogate top connections to blocks that are just far enough left or right" do
    top_block = Block.new(250,0)
    left_corner_under_block = Block.new(210,40)
    right_corner_under_block = Block.new(290,40)
    @path.add(top_block)
    @path.add(left_corner_under_block)
    @path.add(right_corner_under_block)
    left_corner_under_block.should be_connected_to_top
    right_corner_under_block.should be_connected_to_top 
  end
  it "should  propogate bottom connections to blocks that are just far enough left or right" do
    bottom_block = Block.new(250,460)
    left_corner_above_block = Block.new(210,420)
    right_corner_above_block = Block.new(290,420)
    @path.add(bottom_block)
    @path.add(left_corner_above_block)
    @path.add(right_corner_above_block)
    left_corner_above_block.should be_connected_to_bottom
    right_corner_above_block.should be_connected_to_bottom
  end
  it "should propogate right/left connections to blocks that are just far enough above or below" do
    right_block = Block.new(460,250)
    left_block = Block.new(0,250)
    below_left_block = Block.new(40,290)
    above_right_block = Block.new(420,210)
    @path.add(below_left_block)
    @path.add(above_right_block)
    @path.add(right_block)
    @path.add(left_block)
    above_right_block.should be_connected_to_right
    below_left_block.should be_connected_to_left
  end
  
  it "should, if added to the left or right of a top connected block, be top connected" do
    top_block = Block.new(250,0)
    below_left_block = Block.new(210,20)
    below_right_block = Block.new(290,20)
    @path.add(top_block)
    @path.add(below_left_block)
    @path.add(below_right_block)
    below_left_block.should be_connected_to_top
    below_right_block.should be_connected_to_top
  end
  it "should, if added to the left or right of a bottom connected block, be bottom connected" do
    bottom_block = Block.new(250,460)
    above_left_block = Block.new(210,440)
    above_right_block = Block.new(290,440)
    @path.add(bottom_block)
    @path.add(above_left_block)
    @path.add(above_right_block)
    above_left_block.should be_connected_to_bottom
    above_right_block.should be_connected_to_bottom
  end
  it "should, if added right above or below a right/left connected block, be right/left connected" do
    right_block = Block.new(460,250)
    left_block = Block.new(0,250)
    below_left_block = Block.new(20,290)
    above_right_block = Block.new(440,210)
    @path.add(below_left_block)
    @path.add(above_right_block)
    @path.add(right_block)
    @path.add(left_block)
    above_right_block.should be_connected_to_right
    below_left_block.should be_connected_to_left
  end
  
  it "should know if it is connected to the right and left at the same time" do
    y = 40
    (0..440).step(40) {|x| @path.add(Block.new(x,y))}
    @path.add(Block.new(460,80))
    @path.obsticals.last.should be_connected_to_right
    @path.obsticals.last.should be_connected_to_left
  end
  
  it "should be able to disconnect towers from top bottom left or right" do
    block = Block.new(40,40)
    block.connect_to_top.should == true
    block.disconnect_from_top
    block.should_not be_connected_to_top
    block.connect_to_bottom.should == true
    block.disconnect_from_bottom
    block.should_not be_connected_to_top
    block.connect_to_left.should == true
    block.disconnect_from_left
    block.should_not be_connected_to_left
    block.connect_to_right.should == true
    block.disconnect_from_right
    block.should_not be_connected_to_right
  end
  
  it "should disconnect to the top bottom left or right if a connected tower is deleted" do
    y = 40
    (0..440).step(40) {|x| @path.add(Block.new(x,y))}
    @path.add(Block.new(460,80))
    @path.obsticals.last.should be_connected_to_right
    @path.delete_obstical(@path.obsticals.last)
    @path.obsticals.last.should_not be_connected_to_right
    @path.obsticals.last.should be_connected_to_left
  end
  
  
end