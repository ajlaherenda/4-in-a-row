require_relative "rboard.rb"
require_relative "game.rb"
require_relative "player.rb"
class Board
  attr_accessor :board
  attr_accessor :rows #cerates both the reader and writer methods for the attr
  attr_accessor :row_size, :column_size
  attr_accessor :free_slots
  attr_accessor :printed_for_first_time
  attr_accessor :player_one_moves
  attr_accessor :player_two_moves
  attr_accessor :stored_moves
  attr_accessor :file 
  attr_accessor :type_constant


  def initialize #called the moment Board.new is executed
    @free_slots = []
    @player_one_moves = []
    @player_two_moves =[]
    @stored_moves = []
    @type_constant = "B"
    @file = [*'a'..'z', *0..9, *'A'..'Z'].shuffle[0..10].join 
    @printed_for_first_time = true
    trash = generate_board
    if type_constant == "RB"
      exit(false)
    else
      for i in (0..row_size.to_i)
        for j in (0..column_size.to_i)
          @free_slots[j] = i
        end
      end
    end
    
  end

  #check where is the first empty row in our chosen column
  #change color it should be a parameter
  def drop_checker(board, color, column_entered)

    if @free_slots[column_entered.to_i] == 0
      puts "Invalid move, since the column is full!"
      return false

    else 
      board.rows.reverse.each_with_index {|row, i|
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
           print_grid
           return true
          

      
        end
      }
 
    end

  end


  def generate_board

    #initialize the size variables
    row_size = 0
    column_size = 0
    init_counter = 0
   
    command = ""
    #looping until the user's input satisfies our minimum condition and max difference of between rows and columns being 2
    loop do
      occurence2 = 0
      occurence = 0
      loop do
        start_time = Time.now
        end_time = start_time + 5
        
        
        if init_counter == 0
          while start_time != end_time
            if occurence == 0
              puts "\e[H\e[2J"
              puts "WELCOME TO THE 4 IN A ROW GAME"
              puts
              puts "THE GAME CAN BE STOPPED BY PRESSING P AT COLUMN INSERTION"
              puts
              puts "FURTHERMORE TO RELOAD A GAME PRESS L"
              init_counter = 1
            end
            start_time = Time.now
            occurence = 1
          end
        end
        if occurence2 == 0
          puts "What do you want to do?"
          puts "G - TO PLAY THE GAME"
          puts "L - TO LOAD A GAME"
          occurence2 = 1
        end
        command = gets.chomp.to_s
        if command == "L"
          temp = []
          puts "Enter the file name you want to reload"
          file_name = gets.chomp.to_s
          File.open(file_name, "r") do |f|
            f.each_line do |line|
              temp.push(line.to_i)
            end
          end
          rboard = RBoard.new
          @type_constant = "RB"
          rboard.load_rboard(rboard, file_name, temp)
          puts(rboard.headers)
          player_one = Player.new(1, "🤡")
          player_two = Player.new(2, "🤖")
          game = Game.new(player_one, player_two, rboard)
          game.lets_play_loaded(rboard, temp )
          return 444
              
        else
          loop do
            if type_constant == "RB"
              break
            end
            puts "\e[H\e[2J"
            puts "Enter the row size of the board:"
            row_size = gets.chomp
            if row_size.to_i >= 6
              @row_size = row_size.to_i
              @stored_moves.push(row_size.to_i)
              break
            end
          end
        break
        end
        
      end
    
      loop do
        if type_constant == "RB"
          break
        end
        puts "Enter the column size of the board:"
        column_size = gets
          if column_size.to_i >= 7 and (column_size.to_i - row_size.to_i) <= 2
            @column_size = column_size.to_i
            @stored_moves.push(column_size.to_i)
            break
          end
      end
      
      if type_constant == "RB"
        break
      end
      if (column_size.to_i - row_size.to_i) <= 2
        break
      end

    end
    
    #now we create the structure using an array called rows, where each row will contain another array 
    rows = []
    row_size.to_i.times do
      rows << Array.new()
    end

    rows.each do |r|
      column_size.to_i.times do
        r << place_holder #method below
      end
    end

    #define the rows attribute, which is a part of the initialize method akka constructor
  
    @rows = rows
  end


  def place_holder

    return "|  |"
  end

  #method to get indexes for columns 
  def headers
    h = []
    for i in 0..@column_size - 1
        h << i
    end
    return h
  end

  def print_grid
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
    if printed_for_first_time == false
      puts 
      puts "First player's moves: " + @player_one_moves.to_s
      puts "Second player's moves: " + @player_two_moves.to_s
    end
    @printed_for_first_time = false
  end

   def fill_column(board, color, column)
     
      drop_checker(board, color, column)
   
   end

  def write()
    File.open(file, "w+") do |f|
      f.puts(stored_moves)
    end

  end
  
   #we check weather we have 4 in row horizontally, vertically and diagonally
   def game_won(board, column_chosen)
    return board.check_rows(board) || check_columns(board, column_chosen)  || check_upward_diagonals(board) || check_downward_diagonals(board)
   end

  def check_rows(board)
    board.rows.each do |row|
      (0..column_size.to_i - 4).each do |idx|
        won = row[idx..(idx + 3)].all? { |el| el == row[idx] && (el.include?("🤡") || el.include?("🤖")) }
        return true if won
      end
    end
    false
  end

  def check_columns(board, column_chosen)
      wonC = Array.new
      wonR = Array.new
      board.rows.reverse.each_with_index {|col, idx|

        wonC[idx] = col[column_chosen].include?("🤡") 
        wonR[idx] = col[column_chosen].include?("🤖")
      }
      (0..row_size.to_i - 1).each do |idx|
        won = wonC[idx..(idx + 3)].all? || wonR[idx..(idx + 3)].all?
        if won
          return true
        else 

          return false
        end
      end
  end

  def return_stored_moves()
    for i in 0..stored_moves.length()
      puts stored_moves[i]
    end
  end


  def  check_upward_diagonals(board)
    temp = upper_diagonals(board)
    return row_check_for_udiagonals(board, temp)
    
  end

  #creates an array of diagonals
  def upper_diagonals(board)
    (0..board.column_size - 4).map do |i|
      (0..board.row_size - 1 - i).map { |j| board.rows[i + j][j] }
    end.concat((1..board.column_size - 4).map do |j|
      (0..board.row_size - j - 1).map { |i| board.rows[i][j+i] }
    end)
  end
  
  #checks diagonals from top left to bottom right/similar to check_rows
  def row_check_for_udiagonals(board, temp)
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



  def downward_diagonals(arr)
    (0..arr.length - 2).map do |i|
      (0..arr.length - 1 - i).map { |j| arr[i + j][j] }
    end.concat((1..arr.length - 2).map do |j|
      (0..arr.length - j - 1).map { |i| arr[i][j + i] }
    end)
  end

  def rotate90_without0(board)
    ncols = board.column_size
    board.rows.each_index.with_object([]) do |i,a|
      a << (ncols - 1).times.map { |j| board.rows[j][ncols - 1 - i] }
    end
  end
  def rotate90_with0(board)
    ncols = board.row_size
    board.rows.each_index.with_object([]) do |i,a|
      a << ncols.times.map { |j| board.rows[j][ncols - 1 - i] }
    end
  end

  def check_downward_diagonals(board)
    arr = rotate90_without0(board)
    arr2 = rotate90_with0(board)
    temp = downward_diagonals(arr)
    temp2 = downward_diagonals(arr2)
    return check_Ddiagonals(board, temp) || check_Ddiagonals(board, temp2)
  end

  def check_Ddiagonals(board, temp)
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