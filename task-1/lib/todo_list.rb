class TodoList

  class Item
    attr_accessor :name
    attr_reader :completed

    def initialize(name, completed = false)
      @name = name
      @completed = completed
    end

    def to_s
      @name.to_s
    end

    def complete
      @completed = true
    end

    def uncomplete
      @completed = false
    end

  end


  # Initialize the TodoList with +items+ (empty by default).
  def initialize(items=[])
    if items.nil?
      raise IllegalArgument
    end
    @items = []
    items.each{|item| @items << Item.new(item)}
  end

  def empty?
    @items.empty?
  end

  def size
    @items.size
  end

  def <<(item)
    @items << Item.new(item)
  end

  def last
    @items.last
  end

  def complete(item)
    @items[item].complete
  end

  def uncomplete(item)
    @items[item].uncomplete
  end

  # ukonczono?
  def completed?(item)
    @items[item].completed
  end

  def first
    @items.first
  end

  def completed
    @items.select {|item| item.completed == true}#.map(&:to_s)
  end

  def uncompleted
    @items.select {|item| item.completed == false}.map(&:to_s)
  end

  def delete(item)
    @items.delete_at(item)
  end

  def remove_completed
    @items.delete_if {|item| item.completed == true}
  end

  def reverse
    @items.reverse!
  end

  def toggle(item)
    item = @items[item]
    item.completed ? item.uncomplete : item.complete
  end

  def change_description(item, description)
    @items[item].name = description
  end

  def sort_by_name
    @items.sort_by! {|x| x.name}
  end

  def [](item)
    @items[item]
  end
  
  def add_sign(item)
    #@items.select {|item| item.completed == false}.map! {|i| "[ ]" + i.to_s }
    if @items[item].completed == true 
      @items[item] = "[x] " + @items[item].to_s
    else
      @items[item] = "[ ] " + @items[item].to_s
    end
  end

end
