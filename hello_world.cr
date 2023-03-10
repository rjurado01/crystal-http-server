[1,2,3,4].each do |i|
  puts i
end

puts "Hello World!"

## Typed method

def foo(x : Int32)
  x + 2
end

puts foo(2)

## Typed var

var : String = "asdf"

## CLASS

class Foo
  @x : Int64

  def initialize(x)
    @x = x
  end
end

p Foo.new(3)
