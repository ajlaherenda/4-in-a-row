require_relative "game.rb"
require_relative "player.rb"
class RBoard 
    attr_accessor :rboard
    attr_accessor :rows #cerates both the reader and writer methods for the attr
    attr_accessor :row_size, :column_size
    attr_accessor :free_slots
    attr_accessor :player_one_moves
    attr_accessor :player_two_moves
    attr_accessor :stored_moves
    attr_accessor :printed_for_first_time
    attr_accessor :file 

    def initialize
        @rboard = rboard
        @free_slots = []
        @rows = []
        @player_one_moves = []
        @player_two_moves =[]
        @printed_for_first_time = true
        
    end

    def load_rboard(rboard, file_name, stored_moves)
      @file = file_name
      @row_size = stored_moves[0]
      @column_size = stored_moves[1]
      @stored_moves = stored_moves
      @player_one_moves = []
      @player_two_moves =[]

      for i in (0..row_size.to_i)
        for j in (0..column_size.to_i)
          @free_slots[j] = i
        end
      end

      @rows = []
      row_size.to_i.times do
      @rows << Array.new()
      end

      rows.each do |r|
        column_size.to_i.times do
          r << place_holder #method below
        end
      end

      #define the rows attribute, which is a part of the initialize method akka constructor
      #@rows = rows

      
        for i in 2..stored_moves.length - 1
          if i % 2 == 0  
            @player_one_moves.push(stored_moves[i])
            rboard.rows.reverse.each_with_index {|row, k|
              if row[stored_moves[i].to_i] == "|  |"  
                row[stored_moves[i].to_i][1, 2] =  "🤡"
                break
              end
            }

          else
            @player_two_moves.push(stored_moves[i])
            rboard.rows.reverse.each_with_index {|row, k|
              if row[stored_moves[i].to_i] == "|  |" 
                row[stored_moves[i].to_i][1, 2] = "🤖" 
                break
              end
            }
           end

        end
        
    
    print_grid_loaded
    end

    def place_holder  
        return "|  |"
    end


    def print_grid_loaded
        puts "\e[H\e[2J" #clears the screen
        headers.each do |h|
          print "  " + h.to_s + " "
        end
        print "\n"
        rows.each do |r|
          for i in 0..@column_size - 1
            print r[i]
          end
          print "\n"
        end
        if printed_for_first_time == true
          puts 
          puts "First player's moves: " + @player_one_moves.to_s
          puts "Second player's moves: " + @player_two_moves.to_s
        end
        @printed_for_first_time = false
    end

    def headers
      h = []
      for i in 0..@column_size.to_i - 1
          h << i
      end
      return h

    end


   #check where is the first empty row in our chosen column
  #change color it should be a parameter
  def loaded_drop_checker(rboard, color, column_entered)

    if @free_slots[column_entered.to_i] == 0
      puts "Invalid move, since the column is full!"
      return false

    else 
      rboard.rows.reverse.each_with_index {|row, i|
        if row[column_entered] == "|  |"         
           row[column_entered][1, 2] =  color 
           @free_slots[column_entered.to_i] = @free_slots[column_entered.to_i] - 1
           puts
           puts "The element " + color.to_s + "  has been placed in column: " + column_entered.to_s + "!"
           if color == "🤡"
              @player_one_moves.push(column_entered)
              @stored_moves.push(column_entered)
           else 
              @player_two_moves.push(column_entered)
              @stored_moves.push(column_entered)
           end
           print_grid_loaded
           return true
          

      
        end
      }
 
    end

  end

  def loaded_fill_column(rboard, color, column)
     
    loaded_drop_checker(rboard, color, column)
   
  end



  #we check weather we have 4 in row horizontally, vertically and diagonally
  def game_won(rboard, column_chosen)
    #print downward_diagonals(rotate90_with0(rboard))
    #puts
    #print downward_diagonals(rotate90_without0(rboard))
    return check_downward_diagonals(rboard) || rboard.check_rows(rboard) || check_columns(rboard, column_chosen) || check_upward_diagonals(rboard)
   end

  def check_rows(rboard)
    rboard.rows.each do |row|
      (0..column_size.to_i - 4).each do |idx|
        won = row[idx..(idx + 3)].all? { |el| el == row[idx] && (el.include?("🤡") || el.include?("🤖")) }
        return true if won
      end
    end
    false
  end

  def check_columns(rboard, column_chosen)
      wonC = Array.new
      wonR = Array.new
      rboard.rows.reverse.each_with_index {|col, idx|

        wonC[idx] = col[column_chosen].include?("🤡") 
        wonR[idx] = col[column_chosen].include?("🤖")
      }
 
      (0..row_size.to_i - 2).each do |idx|
        won = wonC[idx..(idx + 3)].all? || wonR[idx..(idx + 3)].all?
        return true if won
      end
     false
  end

  def write_loaded(rboard)
    File.open(rboard.file, "w+") do |f|
      f.puts(rboard.stored_moves)
    end
  end

   #ne uzima posljednju kolonu s desna tj 6.

   def  check_upward_diagonals(rboard)
    temp = upper_diagonals(rboard)
    return row_check_for_udiagonals(rboard, temp)
    
  end

  #creates an array of diagonals
  def upper_diagonals(rboard)
    (0..rboard.column_size - 4).map do |i|
      (0..rboard.row_size - 1 - i).map { |j| rboard.rows[i + j][j] }
    end.concat((1..rboard.column_size - 4).map do |j|
      (0..rboard.column_size - j - 1).map { |i| rboard.rows[i][j+i] }
    end)
  end
  
  #checks diagonals from top left to bottom right/similar to check_rows
  def row_check_for_udiagonals(rboard, temp)
    temp.each do |row|
      (0..row.length - 3).each do |idx|
       if row[idx] == row[idx + 1] && row[idx] == row[idx + 2] && row[idx] == row[idx + 3] && (row[idx].include?("🤡") || row[idx].include?("🤖"))
         won = true
         return true if won
       end
      end
    end
  end

  def downward_diagonals(arr)
    (0..arr.length - 2).map do |i|
      (0..arr.length - 1 - i).map { |j| arr[i + j][j] }
    end.concat((1..arr.length - 2).map do |j|
      (0..arr.length - j - 1).map { |i| arr[i][j + i] }
    end)
  end

  def rotate90_without0(rboard)
    
    if( rboard.column_size - rboard.row_size == 2)
      ncols = board.column_size
      board.rows.each_index.with_object([]) do |i,a|
      a << (ncols - 2).times.map { |j| board.rows[j][ncols - 1 - i] }
      end
    else
      ncols = rboard.column_size
      rboard.rows.each_index.with_object([]) do |i,a|
      a << (ncols - 1).times.map { |j| rboard.rows[j][ncols - 1 - i] }
      end
    end
  end

  def rotate90_with0(rboard)
    ncols = rboard.row_size
    rboard.rows.each_index.with_object([]) do |i,a|
      a << ncols.times.map { |j| rboard.rows[j][ncols - 1 - i] }
    end
  end

  def check_downward_diagonals(rboard)
    arr = rotate90_without0(rboard)
    arr2 = rotate90_with0(rboard)
    temp = downward_diagonals(arr)
    temp2 = downward_diagonals(arr2)
    return check_Ddiagonals(rboard, temp) || check_Ddiagonals(rboard, temp2)
  end

  def check_Ddiagonals(rboard, temp)
    temp.each do |row|
      (0..row.length - 3).each do |idx|
        if row[idx] == row[idx + 1] && row[idx] == row[idx + 2] && row[idx] == row[idx + 3] && (row[idx].include?("🤡") || row[idx].include?("🤖"))
          won = true
          return true if won
        end
      end
    end
    return false
  end


end 
