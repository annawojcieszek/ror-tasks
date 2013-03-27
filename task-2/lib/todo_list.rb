class TodoList
  
  class Item
    def initialize(title, description)
      @title = title
      @description = description
    end
  end


  # Initialize the TodoList with +items+ (empty by default).
  def initialize(items=[], args)
    if args[:db].nil?
      raise IllegalArgument
    end
    @items_count = args[:db].items_count
  end
  
  def empty?
    @items_count.zero?
  end
  
  def size
    @items_count
  end
end
