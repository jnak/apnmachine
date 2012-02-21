module ApnMachine
  class Config
    class << self
      attr_accessor :redis, :logger 
    end
  end
end