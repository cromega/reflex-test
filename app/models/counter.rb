class Counter < ApplicationRecord
  validates :name, uniqueness: true

  def increment
    update(value: value + 1)
  end

  def decrement
    update(value: value - 1)
  end
end
