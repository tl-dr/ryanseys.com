module ReadingTimeFilter
	def reading_time( input )
		words_per_minute = 180

		words = input.split.size;
		minutes = ( words / words_per_minute ).floor
		if minutes > 0
			"#{minutes} min read"
		else
			"1 min read"
		end
	end
end

Liquid::Template.register_filter(ReadingTimeFilter)
