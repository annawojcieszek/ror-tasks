require_relative 'spec_helper'
require_relative '../lib/todo_list'
require_relative '../lib/exceptions'
 
describe TodoList do
  subject(:list)            { TodoList.new(db: database) }
  let(:database)            { stub }
  let(:item)                { Struct.new(:title,:description).new(title,description) }
  let(:title)               { "Shopping" }
  let(:description)         { "Go to the shop and buy toilet paper and toothbrush" }
 
  it "should raise an exception if the database layer is not provided" do
    expect{ TodoList.new(db: nil) }.to raise_error(IllegalArgument)
  end
 
  it "should be empty if there are no items in the DB" do
    stub(database).items_count { 0 }
    list.should be_empty
  end
 
  it "should not be empty if there are some items in the DB" do
    stub(database).items_count { 1 }
    list.should_not be_empty
  end
 
  it "should return its size" do
    stub(database).items_count { 6 }
    list.size.should == 6
  end
 
  it "should persist the added item" do
    stub(database).items_count {1}
    mock(database).add_todo_item(item) { true }
    mock(database).get_todo_item(0) { item }
 
    list << item
    list.first.should == item
  end
 
  it "should persist the state of the item" do
    mock(database).todo_item_completed?(0) { false }
    mock(database).complete_todo_item(0, true) { true }
    mock(database).get_todo_item(0) { item }
 
    mock(database).todo_item_completed?(0) { true }
    mock(database).complete_todo_item(0, false) { true }
    mock(database).get_todo_item(0) { item }
 
    list.toggle_state(0)
    list.toggle_state(0)
  end
 
  it "should fetch the first item from the DB" do
    stub(database).items_count {1}
    mock(database).get_todo_item(0) { item }
    list.first.should == item
 
    mock(database).get_todo_item(0) { nil }
    list.first.should == nil
  end
 
  it "should fetch the last item from the DB" do
    stub(database).items_count { 6 }
 
    mock(database).get_todo_item(5) { item }
    list.last.should == item
 
    mock(database).get_todo_item(5) { nil }
    list.last.should == nil
  end
 
  context "with empty title of the item" do
    let(:title)   { "" }
 
    it "should not add the item to the DB" do
      dont_allow(database).add_todo_item(item)
 
      list << item
    end
 
    it "should not notify the social network if the title of the item is missing" do
    end
  end
 
  it "should return nil for the first and the last item if the DB is empty" do
    stub(database).items_count { 0 }
 
    list.first.should == nil
    list.last.should == nil
  end
 
  context "nil item" do
    let(:item)  { nil }
 
    it "should raise an exception when changing the item state if the item is nil" do
      mock(database).get_todo_item(4) { item }
      expect{list.toggle_state(4)}.to raise_error(IllegalArgument)
    end
 
    it "should not accept a nil item" do
      stub(database).items_count {0}
 
      list << item
      list.size.should == 0
    end
  end
 
  context "with too short title of the item" do
    let(:title)  { "to" }
 
    it "should not accept an item with too short (but not empty) title" do
    stub(database).items_count {0}
 
    list << item
    list.size.should == 0
    end
  end
 
  context "with missing description" do
    let(:description) { nil }
 
    it "should accept of an item with missing description" do
      stub(database).items_count {0}
      mock(database).add_todo_item(item) { true }
 
      (list << item).should be_true
    end
 
  end
 
  context "social networks" do
    subject(:list)            { TodoList.new(db: database, social_network: network) }
    let(:add_prefix)          { "I am going to " }
    let(:complete_suffix)     { " is done" }
    let(:network)             { mock }
 
    it "should notify a social network if an item is added to the list (you have to provide the social network proxy in the constructor)" do
      mock(database).add_todo_item(item) { true }
      mock(network).notify(add_prefix + title)
      list << item
    end
 
    it "should notify a social network if an item is completed" do
      mock(database).todo_item_completed?(0) { false }
      mock(database).get_todo_item(0) { item }
      mock(database).complete_todo_item(0, true) { true }
      mock(network).notify(title + complete_suffix)
 
      list.toggle_state(0)
    end
 
    it "should notify the social network if the body of the item is missing" do
      mock(database).add_todo_item(item) { true }
      mock(network).notify(add_prefix + title) { true }
 
      list << item
    end
 
    context "title is longer than 255 chars" do
      let(:title)               { "W sklepie Cubus startuja nowe promocje na wszystkich dzialach. Przymierzajac spodnie LC7507 i wypelniajac krotka ankiete, otrzymasz bon o wartosci  50 PLN* na zakup dowolnej pary spodni!  Zapraszamy i zachecamy do podzielenia sie z nami Twoja sugestia! Flagowa oferta jest oferta 3 w cenie 2 na cala kolekcje dziecieca i meska." }
 
      it "should cut title of the item when notifying the SN" do
        mock(database).add_todo_item(item) { true }
        mock(network).notify((add_prefix + title)[0, 255])
        
        list << item
        
        mock(database).todo_item_completed?(0) { false }
        mock(database).get_todo_item(0) { item }
        mock(database).complete_todo_item(0, true) { true }
        mock(network).notify((title + complete_suffix)[0, 255])

        list.toggle_state(0)
      end
    end
 
  end
 
end