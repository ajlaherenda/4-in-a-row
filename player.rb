require_relative "board.rb"
require_relative "rboard.rb"


class Player
    attr_reader :player_id, :color
    attr_accessor :saved_state_decissions
    attr_accessor :number_of_decissions
  
    def initialize(player_id, color)
      @player_id = player_id
      @color = color
      @saved_state_decissions = []
      @number_of_decissions = 0
    end
   

    def play_turn(board, color)
      chosen_column = get_col(board)
      move_performed = board.fill_column(board, color, chosen_column)
      @number_of_decissions += 1
      return move_performed, chosen_column
    end

    def play_turn_loaded(rboard, color, stored_moves)
      chosen_column = get_col_loaded(rboard, stored_moves)
      move_performed = rboard.loaded_fill_column(rboard, color, chosen_column)
      @number_of_decissions += 1
      return move_performed, chosen_column
    end


    private 
    def get_col(board)
      chosen_column = 0
      command = ""
      loop do
        puts "Please select a column number between 0 and " + (board.column_size - 1).to_s
        command = gets.chomp
        chosen_column = command.to_i
        if command == "P"
          #board.return_stored_moves
          board.write
          exit(false)
        elsif command == "E"
          exit(false)
        elsif chosen_column > board.column_size - 1 or chosen_column < -1
          puts "Column not in range!"
        elsif chosen_column >= 0 and chosen_column <= board.column_size - 1
          saved_state_decissions[number_of_decissions] = chosen_column #to load from the steps
          break

        else
          puts "BAD INPUT"
          exit(false)
        end
      end
      return chosen_column
    end


    def get_col_loaded(rboard, stored_moves)
      chosen_column = 0
      command = ""
      loop do
        puts "Please select a column number between 0 and " + (stored_moves[1] - 1).to_s
        command = gets.chomp
        chosen_column = command.to_i
        if command == "P"
          rboard.write_loaded(rboard)
          exit(false)
        elsif command == "E"
          exit(false)
        elsif chosen_column > stored_moves[1] - 1 or chosen_column < -1
          puts "Column not in range!"
        elsif chosen_column >= 0 and chosen_column <= stored_moves[1] - 1
          saved_state_decissions[number_of_decissions] = chosen_column #to load from the steps
          break

        else
          puts "BAD INPUT"
          exit(false)
        end
      end
      return chosen_column
    end


end