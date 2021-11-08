module Calculator

  def average(data_set)
    average = data_set.sum.to_f / data_set.length.to_f
    average.round(2)
  end

  def percentage(num1, num2)
    percentage = (num1.to_f / num2.to_f)
    percentage.round(2)
  end
end
