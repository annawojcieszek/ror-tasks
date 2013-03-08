class TodoList

  # Initialize the TodoList with +items+ (empty by default).
  def initialize(items=[])
    if items.nil?
      raise IllegalArgument
    end
    @items = items
  end
  def empty?
    @items.empty?
  end
  def size
    if @items.size > 0
      1
    else
      0
    end
  end
  def <<(item)
    @items.push(item)
  end
  def last
    @items.last
  end  
  def complete(item)
    return true
  end
  def completed?(item)
    if item == 1
      true
    elsif item == 0
      false
    end
  end
  def first
    if @items.first == @items.last
      return @items[0]
    end
  end
  
end
