require_relative './business_hour'

hours = BusinessHours.new("9:00 AM", "3:00 PM")
hours.auto_generate_calendar
hours.update("tue","8:00 AM", "1:00 PM")
hours.closed("Apr 23, 2014")
hours.closed("Apr 24, 2014")
#for this I am getting the correct output...
hours.calculate_deadline(2*60*60, "Apr 22, 2014 9:10 AM") 
#for this I am not getting the correct output...
hours.calculate_deadline(7*60*60, "Apr 22, 2014 9:10 AM") 
puts hours.deadline
hours.show
