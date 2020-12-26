class CounterReflex < ApplicationReflex
  def decrement
    session[:counter] -= 1
  end

  def increment
    session[:counter] += 1
  end

  after_reflex do
    morph "#counter", render(partial: "counter", locals: {counter: session[:counter]})
  end
end
