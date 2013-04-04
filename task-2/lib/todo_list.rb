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
    unless item.nil? || item.title == "" || item.title.size <= 3
      notify_network("I am going to " + item.title)
      @db.add_todo_item(item)
    end
  end
 
  def first
    empty? ? nil : @db.get_todo_item(0)
  end
 
  def last
    empty? ? nil : @db.get_todo_item(@db.items_count - 1)
  end
 
  def toggle_state(index)
    item = @db.get_todo_item(index)
    raise IllegalArgument if item.nil?
 
    if @db.todo_item_completed?(index)
      @db.complete_todo_item(index, false)
    else
      @db.complete_todo_item(index, true)
      notify_network(item.title + " is done")
    end
  end
 
  def completed?(item)
    @db.todo_item_completed?(item)
    @network.notify(item)
  end
 
  def notify_network(message)
    message = message[0, 255] if message.length > 255
    @network.notify(message) if @network
  end
 
end
