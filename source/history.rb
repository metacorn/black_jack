class History
  attr_reader :list

  def initialize
    @list = []
  end

  def clear
    @list = []
  end

  def write(action)
    @list << action
  end

  def not_empty?
    !@list.empty?
  end
end
