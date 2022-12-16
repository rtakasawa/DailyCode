# フィナボッチ数列
result = [1,1]

2000.times do |i|
  sum_integer = result.last(2).sum
  break if sum_integer > 2000
  result.push(sum_integer)
end

puts result