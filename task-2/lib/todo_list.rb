class TodoList

  # Initialize the TodoList with +items+ (empty by default).
  def initialize(items=[], args)
    if args[:db].nil?
      raise IllegalArgument
    end
   @db = args[:db]
   @network = args[:social_network]
  end
  
  def empty?
    @db.items_count.zero?
  end
  
  def size
    @db.items_count
  end

  def <<(item)
    if item.nil?
      nil
    elsif item.title == "" || item.title.size <= 3
      nil
    else 
      @db.add_todo_item(item)  
      @network.notify(item)  
    end
  end

  def first
    if self.empty?
      nil
    else
      @db.get_todo_item(0)
    end
  end

  def toggle_state(item)
    if item == nil
      raise IllegalArgument
    else   
      if @db.todo_item_completed?(item) == false
        @db.complete_todo_item(item, true)
      else
        @db.complete_todo_item(item, false)
      end
    end
  end

  def last
    if self.empty?
      nil
    else
      @db.get_todo_item(@db.items_count-1)
    end
  end
  def completed?(item)
    @db.todo_item_completed?(item)
    @network.notify(item)
  end

  
end