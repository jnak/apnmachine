module ApnMachine
  class Config

  	# Defines class instance variables (not shared by other classes)
    class << self
      attr_accessor :redis, :logger 
    end
  end
end