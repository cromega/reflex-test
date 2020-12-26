class CounterReflex < ApplicationReflex
  def decrement
    counter.decrement
  end

  def increment
    counter.increment
  end

  after_reflex do
    morph container_selector, render(partial: "counter", locals: {counter: counter})
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
