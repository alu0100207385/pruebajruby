class User
	include DataMapper::Resource

	property :id, Serial
	property :name, String
	property :rol, String
end