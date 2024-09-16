# frozen_string_literal: true

# Animal class
class Animal
  def speak = raise(NotImplementedError, 'You must implement the speak method')
  def kind = String(self.class).downcase
end
