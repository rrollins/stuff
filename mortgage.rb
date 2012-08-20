#!/usr/bin/ruby 


def self.number_to_currency(number)
  "$#{M.number_with_precision(number)}"
end

class M

  def self.how_much_loan_can_i_get(monthly_payment, rate, years, money_down = 0)
   if rate <= 0    
     initial_loan =  monthly_payment * years * 12
   else
     initial_loan =   ( monthly_payment *(((1 + (rate/12))**(years*12)) - 1) ) / ((rate/12)*((1 + (rate/12))**(years*12)))
   end
   if money_down > 0
     return initial_loan + money_down   
   else
     return initial_loan
   end 
  end

  def self.how_much_will_i_pay_monthly(initial_loan, rate, years, money_down = 0)
    #L[c(1 + c)n]/[(1 + c)n - 1]
    money_down = 0 if money_down < 0 
    initial_loan = initial_loan - money_down
    rate = rate/12
    months_to_finish  = years * 12
   
    if rate <= 0
      initial_loan / months_to_finish 
    else
      (initial_loan * ( rate * (1 + rate)**months_to_finish)) / ((1 + rate)**months_to_finish - 1)
    end
  end

  def self.how_much_will_i_pay_total(monthly_payment, rate, years, money_down  = 0)
   monthly_payment * years * 12
   #money_down = 0 if money_down < 0
   #P = L[c(1 + c)n]/[(1 + c)n - 1]   
   #     initial_loan( (rate/12)**(years*12))
   # (monthly_payment - money_down) * ((1 + (rate/12))**(years*12))
  end

  def self.number_with_precision(number)
    precision = 2
    rounded_number = (Float(number) * (10 ** precision)).round.to_f / 10 ** precision
  end 

end


own = false
if ARGV[0] && ARGV[0].downcase == "true"
  own = true
end


puts own


puts "% down"
money_down = Float(STDIN.gets)

puts "money for repairs"
repair_money = Float(STDIN.gets)

puts "Whats the rate"
rate =  Float(STDIN.gets)
if rate <= 0.0
  rate = 0.0
else
 rate = rate / 100
end

puts "Years"
years = Integer(STDIN.gets)
interest = rate*100


monthly_payment = 2500
puts "home price: "
a =  STDIN.gets.to_i
initial_loan = a
#initial_loan = M.how_much_loan_can_i_get(monthly_payment, rate, years, money_down)
#monthly_payment =  M.how_much_will_i_pay_monthly(initial_loan, rate, years)


money_down = a * (money_down/100)
puts "Put #{number_to_currency(money_down)} down"

out_of_pocket = money_down + repair_money

puts "How much do you expect to make monthly: "
profit =  STDIN.gets.to_i

water_bill = 50
electricity = 35
lawn = 50
fixes = 30 
property_management = profit * 0.080


if own
  other_fees = water_bill + electricity + lawn + fixes
else
  other_fees = water_bill + electricity + lawn + fixes + property_management
end



insurance = 125
property_taxes = ( initial_loan * 0.0225) / 12
puts "What is the HOA fees"
hoa = Float(STDIN.gets)

pmi = 0.00
ownership = (money_down*1.00)/(initial_loan*1.00)
if ownership < 0.2
  pmi = (initial_loan * 0.0078) / 12
end


puts "\n\n\n"

#puts "Loan with a monthly payment of #{number_to_currency(monthly_payment)} at #{interest}% is:  #{number_to_currency(M.how_much_loan_can_i_get(monthly_payment, rate, years))}\n"

#puts "Monthly Payment with #{money_down} down #{M.what_is_loan(2500.00, 0.06, 30, 30000)}"
#puts "You will pay: #{number_to_currency(M.how_much_will_i_pay_total(monthly_payment, rate, years))} after #{years} years"

amount_i_pay = M.how_much_will_i_pay_monthly(initial_loan, rate, years, money_down)


monthly_bill = amount_i_pay + insurance + property_taxes + hoa + pmi + other_fees

puts "Monthly Payment on #{number_to_currency(initial_loan - money_down)} at #{interest}% is: #{number_to_currency(amount_i_pay)} for #{years} years " + 
     "but after you add #{number_to_currency(property_taxes)} in property taxes and #{number_to_currency(insurance)} in " +
     "insurance and #{number_to_currency(pmi)} in private mortgage insurance and  #{number_to_currency(hoa)} in HOA and #{number_to_currency(other_fees)} in property_management and other fees the price becomes #{number_to_currency(amount_i_pay + insurance + property_taxes + hoa + pmi + other_fees)}\n\n"

puts "you came out of pocket #{number_to_currency(out_of_pocket)}\n\n"


puts "You'll make #{number_to_currency(profit - monthly_bill)} profit each month and #{number_to_currency(profit*12 - monthly_bill*12)} each year\n\n"
puts "it's a #{100*((profit*12 - monthly_bill*12) /out_of_pocket)}% yield\n\n"


real_profit = (profit - monthly_bill)


#puts "How much a loan can I get with #{number_to_currency(money_down)} down and a monthly payment of #{number_to_currency(monthly_payment)} at #{interest}% interest? #{number_to_currency(M.how_much_loan_can_i_get(monthly_payment, rate, years, money_down))}"



profit_after_paid_off =  profit - (insurance + property_taxes + hoa + other_fees)

puts "After paid off you'll make #{number_to_currency(profit_after_paid_off)}\n"

# if it takes less than the total amount of years to pay this thing off figure it out


if ( out_of_pocket / real_profit) < (years*12)
  total_months_to_make_money_back = out_of_pocket / real_profit
else
  left_to_pay = out_of_pocket - (real_profit * years * 12)
  months_to_pay_the_rest = left_to_pay / profit_after_paid_off
  total_months_to_make_money_back  = months_to_pay_the_rest + (years*12)
end

puts "it will take #{((total_months_to_make_money_back) / 12).abs} years to make back original investment"
puts "\n\n\n"

