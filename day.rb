class Day

	def date
		@date
	end

	def name_of_day
		@name_of_day		
	end

	def day_opening_time
		@day_opening_time		
	end

	def day_closing_time
		@day_closing_time		
	end

	def is_opened
		@is_opened		
	end

	def date=(value)
		@date=value
	end

	def name_of_day=(value)
		@name_of_day=value
	end

	def day_opening_time=(value)
		@day_opening_time=value
	end

	def day_closing_time=(value)
		@day_closing_time=value
	end

	def is_opened=(value)
		@is_opened=value
	end

	def to_s
		"Date : #{@date}\n
    	 	  Day : #{@name_of_day}\n
    	 	  Opening Time : #{@day_opening_time}\n
    	  	  Closing TIme : #{@day_closing_time}\n
    	 	  Opened : #{@is_opened}\n"
	end
end
