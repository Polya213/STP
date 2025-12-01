sum3 = ->(a, b, c) { a + b + c }

def curry3(proc)
  lambda do |*args_acc|
    #Внутрішня рекурсивна лямбда
    inner = lambda do |*args|
      all_args = args_acc + args
      if all_args.size > 3
        raise ArgumentError, "Too many arguments"
      elsif all_args.size == 3
        proc.call(*all_args)       #всі аргументи зібрано-повертаємо результат
      else
        curry3(->(*more) { proc.call(*(all_args + more)) }) #чекаємо решту
      end
    end
    inner
  end
end

#Тестування
cur = curry3(sum3)

puts cur.call(1).call(2).call(3).call rescue puts "Done"  #=> 6
puts cur.call(1,2).call(3)                                 #=> 6
puts cur.call(1).call(2,3)                                 #=> 6
puts cur.call(1,2,3)                                       #=> 6

#Інший приклад
f = ->(a,b,c) { "#{a}-#{b}-#{c}" }
cF = curry3(f)
puts cF.call('A').call('B','C')                             #=> "A-B-C"
