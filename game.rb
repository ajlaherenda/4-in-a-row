require_relative "board.rb"
require_relative "player.rb"
#require_relative "letsplay.rb"



class Game
    attr_reader :players, :board
    attr_accessor :win_achieved
    


    def initialize(player_one, player_two, board)
      @board = board
      @current_player_id = "first"
      puts "Game initalized. Let's play!"
      
      @players = {
        first: player_one,
        second: player_two
      }

    end

    def lets_play_loaded(rboard, stored_moves)
      rboard.print_grid_loaded
      turns = stored_moves.length - 2
      data_returned = Array.new
      move_performed = true
      loop do
        max_turns = stored_moves[0].to_i * stored_moves[1].to_i
        @current_players_id = (turns % 2 == 0) ? :first : :second #first and second player

        loop do 
          puts
          puts @current_players_id.to_s.capitalize + " player it is your turn..."
          puts
          turns += 1
          
          data_returned = @players[@current_players_id].play_turn_loaded(rboard, @players[@current_players_id].color, stored_moves)
          move_performed = data_returned[0]
          column_chosen = data_returned[1]

          if move_performed == true
            @win_achieved = rboard.game_won(rboard, column_chosen)
            break
          end
        end
        #if condition da nije pobjeda i nisu max turns 
        if turns == max_turns || win_achieved == true 
          puts 
          #puts "\e[H\e[2J" #if we want to clear screen after win/draw
          if turns == max_turns
            start_time = Time.now
            end_time = start_time + 5
            occurence = 0
            while start_time != end_time
              if occurence == 0
                 puts "IT'S A DRAW"
              end
              occurence = 1
            end
          elsif win_achieved == true
            start_time = Time.now
            end_time = start_time + 5
            occurence = 0
            while start_time != end_time
              if occurence == 0
                 puts "WE HAVE A WINNER!"
                 puts
                 puts @current_players_id.to_s.capitalize + " player has won!"
              end
              start_time = Time.now
              occurence = 1
            end
            
          else
            puts "UNADDRESSED ERROR"
          end
          puts "\e[H\e[2J"
          puts "Do you wany to play again?"
          puts
          puts "1 - YES"
          puts "2 - NO"
          answer = gets.chomp
          if answer == "1"
            load("./letsplay.rb")
          else
            puts "\e[H\e[2J"
            exit(false)
          end
        end
      end

    end

    def lets_play(board)
      board.print_grid
      turns = 0
      data_returned = Array.new
      move_performed = true
      loop do
        max_turns = @board.row_size * @board.column_size
        @current_players_id = (turns % 2 == 0) ? :first : :second #first and second player

        loop do 
          puts
          puts @current_players_id.to_s.capitalize + " player it is your turn..."
          puts
          turns += 1
          
          data_returned = @players[@current_players_id].play_turn(@board, @players[@current_players_id].color)
          move_performed = data_returned[0]
          column_chosen = data_returned[1]

          if move_performed == true
            @win_achieved = board.game_won(board, column_chosen)
            break
          end
        end

         
        #if condition da nije pobjeda i nisu max turns 
        if turns == max_turns || win_achieved == true 
          puts 
          #puts "\e[H\e[2J" #if we want to clear screen after win/draw
          if turns == max_turns
            start_time = Time.now
            end_time = start_time + 5
            occurence = 0
            while start_time != end_time
              if occurence == 0
                 puts "IT'S A DRAW"
              end
              occurence = 1
            end
          elsif win_achieved == true
            start_time = Time.now
            end_time = start_time + 5
            occurence = 0
            while start_time != end_time
              if occurence == 0
                 puts "WE HAVE A WINNER!"
                 puts
                 puts @current_players_id.to_s.capitalize + " player has won!"
              end
              start_time = Time.now
              occurence = 1
            end
            
          else
            puts "UNADDRESSED ERROR"
          end
          puts "\e[H\e[2J"
          puts "Do you wany to play again?"
          puts
          puts "1 - YES"
          puts "2 - NO"
          answer = gets.chomp
          if answer == "1"
            load("./letsplay.rb")
          else
            puts "\e[H\e[2J"
            exit(false)
          end
        end
      end
    end

end

  
