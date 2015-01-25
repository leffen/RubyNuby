def legg_sammen( a, b)
  a + b   # det siste uttrykket returneres
end
puts legg_sammen( 9, 6 ) #=> 15

# fibonacci
def fib( i )
  if i <= 1
    return 1   # vi kan returnere eksplisitt
  end
  return fib( i-1 ) + fib( i-2 )
end
puts fib( 3 ) #=>  3
puts fib( 5 ) #=>  8
