require 'date'
require 'time'
require 'pp'

class BusinessHours

	attr_accessor :opening_time, :closing_time, :days, :todays_date, :calendar, :deadline
	def initialize(default_opening_time,default_closing_time)
		@default_opening_time = default_opening_time
		@default_closing_time = default_closing_time
		@days = [:mon, :tue, :wed, :thu, :fri, :sat, :sun]
		@update_days = {}
		@closed_days = {}
		@deadline = nil
		@time_left = nil
	end

	def update(update_day_date, opening_time, closing_time)
		
		day = update_day_date.is_a?(Symbol) ? update_day_date : Date.parse(update_day_date) 	
		
		@update_days[day] = [opening_time, closing_time]
	end

	def closed(*day_date)
		day_date.each do |item|
			day = item.is_a?(Symbol) ? item : Date.parse(item) 	
			@closed_days[day] = true
		end
	end

	def calculate_deadline(time_interval, start_date_time)
		start_time = Time.parse(start_date_time)
		start_date = Date.parse(start_date_time)
		if @closed_days[start_date]
			new_date = start_date.next
			update_time(start_time,new_date,time_interval)
		elsif @closed_days[start_time.strftime("%a").downcase.to_sym]
			new_date = start_date.next
			update_time(start_time,new_date,time_interval)
		else
			update_time(start_time,start_date,time_interval)	
		end
	end
 	
 	def update_time(time,date,time_interval)
 		#new_date = date.next
 		if @update_days[date]
			opening_time, closing_time = @update_days[date]

			time_deff_in_seconds = timeDefference(time.strftime("%R %p") , closing_time)
			if time_interval > time_deff_in_seconds
				puts "I AM HERE...."
				@time_left = time_interval - time_deff_in_seconds
				calculate_deadline(@time_left, date.to_s + ' ' + opening_time.to_s)
			else
				Time.parse(opening_time) + time_interval
			end	
		elsif @update_days[time.strftime("%a").downcase.to_sym]
			opening_time, closing_time = @update_days[time.strftime("%a").downcase.to_sym]
			time_deff_in_seconds = timeDefference(time.strftime("%R %p") , closing_time)
			if time_interval > time_deff_in_seconds
				puts "I AM HERE TOOO...."
				@time_left = time_interval - time_deff_in_seconds
				calculate_deadline(@time_left,date.to_s + ' ' + opening_time.to_s)
			else
				Time.parse(opening_time) + time_interval
			end			
		else
			opening_time, closing_time = @default_opening_time, @default_closing_time
			time_deff_in_seconds = timeDefference(time.strftime("%R %p") , closing_time)
			if time_interval > time_deff_in_seconds

				puts "I AM HERE 420"
				@time_left = time_interval - time_deff_in_seconds
				calculate_deadline(@time_left, date.to_s + ' ' + opening_time.to_s)
			else
				Time.parse(opening_time) + time_interval
			end	
		end	

 	end
	
	def timeDefference(start_time, closing_time)
		(Time.parse(start_time) - Time.parse(closing_time)).abs.to_i
	end

	def show
	#	pp @update_days
	puts @deadline
	end

end
