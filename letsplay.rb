require_relative "board.rb"
require_relative "game.rb"
require_relative "player.rb"

#irb hello.rb > output.txt
#creates a file for read and write 
file_name = [*'a'..'z', *0..9, *'A'..'Z'].shuffle[0..10].join 
#File.open(file_name + ".txt", 'w+') {|f| f.write("write your stuff here") }
#File.new(file_name + ".txt", "w+")

board = Board.new
player_one = Player.new(1, "🤡")
player_two = Player.new(2, "🤖")
game = Game.new(player_one, player_two, board)
game.lets_play(board)


