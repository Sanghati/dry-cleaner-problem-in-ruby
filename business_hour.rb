require 'date'
require 'time'

class BusinessHours
	attr_accessor :opening_time, :closing_time, :days, :todays_date, :calendar, :deadline
	def initialize(default_opening_time,default_closing_time)
		@default_opening_time = default_opening_time
		@default_closing_time = default_closing_time
		@days = [:mon, :tue, :wed, :thu, :fri, :sat, :sun]
		@update_days = {}
		@closed_days = {}
		@time_open_close =[]
	end

	def update(update_day_date, opening_time, closing_time)
		day = update_day_date.is_a?(Symbol) ? update_day_date : Date.parse(update_day_date)	
		@update_days[day] = [opening_time, closing_time]
	end

	def closed(*day_date)
		day_date.each do |item|
			day = item.is_a?(Symbol) ? item : Date.parse(item).to_s
			@closed_days[day] = true
		end
	end

	def calculate_deadline(time_interval, start_date_time)
		start_time = Time.parse(start_date_time)
		start_date = Date.parse(start_date_time)
		if is_closed?(start_date)
			start_date = start_date.next
			opening_time , closing_time = change_schedule(start_date)
			calculate_deadline(time_interval,start_date.to_s + '  ' + opening_time.to_s)
		else
			calculate_time(start_date,start_time,time_interval)	
		end	
	end
 	
 	def change_schedule(date)
 		if @update_days[date]
		             opening_closing_time = @update_days[date]
		elsif @update_days[date.strftime("%a").downcase.to_sym]
			opening_closing_time = @update_days[date.strftime("%a").downcase.to_sym]
		else
			opening_closing_time = [ @default_opening_time, @default_closing_time ]
		end	
		opening_closing_time
 	end

 	def calculate_time(date,start_time,time_interval)
 		opening_time , closing_time = change_schedule(date)
 		if start_time.strftime("%R %p").between?(opening_time,closing_time) 
			
			time_deff_in_seconds = timeDefference(opening_time , closing_time)
		else

			time_deff_in_seconds = timeDefference(start_time.strftime("%R %p") , closing_time)
		end
		if time_interval > time_deff_in_seconds
			time_left = time_interval - time_deff_in_seconds
			calculate_deadline(time_left, date.next.next.to_s + '  ' + opening_time.to_s)
		else	
			resultant_time = (Time.parse(start_time.to_s) + time_interval).to_s.split(' ')
			"#{date.to_s}  #{resultant_time[1].to_s}"
		end	

	end

	def is_closed?(date)
		(@closed_days[date] || @closed_days[date.strftime("%a").downcase.to_sym])? true : false
	end
	
	def timeDefference(start_time, closing_time)
		 #start_time = start_time.strftime("%R %p")
		(Time.parse(start_time) - Time.parse(closing_time)).abs.to_i
	end
end
