$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'apnmachine'
require 'redis'

ApnMachine::Config.redis = Redis.new
notif = ApnMachine::Notification.new
notif.device_token = "a48fd0b38e07410cb9a18d46e3c73b7c36cbb7c37c72e432796678910cd0cd26"
notif.alert = "Boom accepted your friend request!"
notif.custom = {'t' => 'f', 'n' => 'Julien Nakache', 'u' => '78' }
notif.sound = 'zapkast.aiff'
notif.push