require 'bundler/setup'
require 'rspec/expectations'
require_relative '../lib/todo_list'
require_relative '../lib/exceptions'

describe TodoList do
  subject(:list)            { TodoList.new(items) }
  let(:items)               { [] }
  let(:item_description)    { "Buy toilet paper" }

  it { should be_empty }

  it "should raise an exception when nil is passed to the constructor" do
    expect { TodoList.new(nil) }.to raise_error(IllegalArgument)
  end

  it "should have size of 0" do
    list.size.should == 0
  end

  it "should accept an item" do
    list << item_description
    list.should_not be_empty
  end

  it "should add the item to the end" do
    list << item_description
    list.last.to_s.should == item_description
  end

  it "should have the added item uncompleted" do
    list << item_description
    list.completed?(0).should be_false
  end

  context "with one item" do
    let(:items)             { [item_description] }

    it { should_not be_empty }

    it "should have size of 1" do
      list.size.should == 1
    end

    it "should have the first and the last item the same" do
      list.first.to_s.should == list.last.to_s
    end

    it "should not have the first item completed" do
      list.completed?(0).should be_false
    end

    it "should change the state of a completed item" do
      list.complete(0)
      list.completed?(0).should be_true
    end
  end

  context "with many items" do
    let(:second_item_description)    { "Iron Marek's shirts" }
    let(:third_item_description)     { "Annoy Marek" }
    let(:items) { [item_description, second_item_description] }

    it "should return completed items" do
      list.complete(0)
      list.complete(1)
      list.completed.size.should == items.size
      list.completed.map(&:to_s).should == items
    end

    it "should return uncompleted items" do
      list.uncompleted.should == items
    end

    it "should remove individual item" do
      n = list.size
      list.delete(0)
      list.size.should == n-1
      list.first.to_s.should == second_item_description
    end

    it "should remove all completed items" do
      list.complete(0)
      list.complete(1)
      list.remove_completed
      list.size.should == 0
    end

    it "should reverse order of all items" do
      list.reverse
      list.first.to_s.should == second_item_description
      list.last.to_s.should == item_description
    end

    it "should toggle the state of an item" do
      list.complete(1)
      list.toggle(0)
      list.toggle(1)
      list.completed?(0).should be_true
      list.completed?(1).should be_false
    end

    it "should set the state of the item to uncompleted" do
      list.uncomplete(0)
      list.completed?(0).should be_false
    end

    it "should change the description of an item" do
      list.change_description(0, "ania")
      list.first.to_s.should == "ania"
    end

    it "should sort the items by name" do
      list << third_item_description
      list.sort_by_name
      list.first.to_s.should == third_item_description
      list.last.to_s.should == second_item_description
      list[1].to_s.should == item_description

    end


  end
end
