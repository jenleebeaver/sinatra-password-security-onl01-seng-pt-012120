class User < ActiveRecord::Base
	has_secure_password
	#this also authenticates our password
end
