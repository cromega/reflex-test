class CounterReflex < ApplicationReflex
  def decrement
    counter.decrement
    morph container_selector, render(CounterComponent.new(counter))
  end

  def increment
    counter.increment
    morph container_selector, render(CounterComponent.new(counter))
  end

  private

  def container_selector
    #"#counters > .container[data-counter-id=\"#{counter.id}\"]"
    ".container[data-counter-id=\"#{counter.id}\"]"
  end

  def counter
    @counter ||= Counter.find element.dataset["counter-id"]
  end
end
