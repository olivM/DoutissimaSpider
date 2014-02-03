class Node
	include Mongoid::Document
	field :url, type: String
	field :type, type: String
	field :name, type: String
	field :id, type: String

end
