require_relative './day'
require 'date'
require 'time'

class BusinessHours

	attr_accessor :opening_time, :closing_time, :days, :todays_date, :calendar, :deadline
	def initialize(default_opening_time,default_closing_time)
		@default_opening_time = default_opening_time
		@default_closing_time = default_closing_time
		@days = ["Mon","Tue","Wed","Thur","Fri","Sat","Sun"]
		@todays_date = Date.today
		@calendar = []
		@deadline = nil
	end

	def auto_generate_calendar
		@days.each do |day|
			calendar_day = Day.new
			calendar_day.date = date_of_next(day)
			calendar_day.name_of_day = day
			calendar_day.day_opening_time = @default_opening_time
			calendar_day.day_closing_time = @default_closing_time
			calendar_day.is_opened = "opened"
			@calendar.push(calendar_day)
		end
	end

	def update(update_day_date,update_opening_time, update_closing_time)
		@calendar.each do |cal|
			if update_day_date.match('[A-z]{3}\s\d{2}[,]\s\d{4}')
				if(cal.date == Date.parse(update_day_date))
					cal.day_opening_time = update_opening_time
					cal.day_closing_time = update_closing_time
			   	end
			else
				if(cal.date == date_of_next(update_day_date))
				 	cal.day_opening_time = update_opening_time
				 	cal.day_closing_time = update_closing_time
				end
			end
		end			
	end

	def closed(day_date)
		@calendar.each do |cal|
			if day_date.match('[A-z]{3}\s\d{2}[,]\s\d{4}')
				 if(cal.date == Date.parse(day_date))
				 	cal.is_opened = "closed"	
				 end 
			else
				 if(cal.date == date_of_next(day_date))
				 	cal.is_opened = "closed"
				 end 
			end	
		end
	end

	def calculate_deadline(time_interval, start_date_time)

		#HERE I AM FACING PROBLEM....
		start_time = start_date_time.split(' ')
		@calendar.each do |cal|
			if(cal.date == Date.parse(start_date_time))
				time_deff_in_seconds = timeDefference(start_time[3] + "" + start_time[4] , cal.day_closing_time)
				if time_interval > time_deff_in_seconds
					
					if cal.is_opened == "opened"
						@deadline = Time.parse(start_date_time) + time_deff_in_seconds
						# puts "deadline :"
						# puts @deadline
						 time_deff_in_seconds =  time_interval - time_deff_in_seconds

						# puts "time interval"
						# puts time_interval
						start_date_time  = (Date.parse(start_date_time) + 1).to_s
					end
				else
					@deadline = Time.parse(start_date_time) + time_interval 
				end

			end
		end
	end

	def date_of_next(day)
		date  = Date.parse(day)
		delta = date > @todays_date ? 0 : 7
		date + delta
	end

	def timeDefference(start_time, closing_time)
		(Time.parse(start_time) - Time.parse(closing_time)).abs.to_i
	end

	def show
		@calendar.each do |cal|
		 	puts cal
		end	
	end

end
