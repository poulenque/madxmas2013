function assert_table(e)
	assert(type(e) == "table", "Expected table, got " .. type(e))
end

function assert_number(e)
	assert(type(e) == "number", "Expected number, got " .. type(e))
end

function assert_number_or_table(e)
	assert(type(e) == "number" or type(e) == "table",
		"Expected number or table, got " .. type(e))
end

function assert_userdata(e)
	assert(type(e) == "userdata", "Expected userdata, got " .. type(e))
end
