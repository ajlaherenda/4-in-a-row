Your implementation should draw the game board on the screen, in a console/terminal window. 
i.e. you do not need to make a graphical UI for it; console-based inputs and outputs are enough.
You should find a way to represent the entire board, including the player pieces. You can use special unicode symbols for fields, such as ◯, ⬤ for different states of the board.
The “designs” of the board and pieces are up to you.
When starting a new game, you should be able to choose the dimensions of the board or stick with the default (6 rows x 7 columns).
The minimum allowed dimension is 6x7. 
You may select different board dimensions (as long as they are >= minimum), but the number of rows and columns must not differ by more than 2 (e.g. 6x8, 9x9, 10x12 are fine, but 8x11 is not).
The game is played by 2 players who take turns.
You do not need to code an “AI” player; it is a human vs human game.
To play the game, a player selects a column for their piece to drop into. The piece falls into the first free slot into the column.
Example:
   1                     1
[      ]		[      ]
[      ]		[      ]
[      ]		[      ]
[      ]	  →	[ ⬤ ]
[ ⬤ ]		[ ⬤ ]
[ ◯ ]		[ ◯ ]

If the player selects column 1, their piece “falls into” the first free slot in the column.
Once the player selects their column and drops the piece, the other player’s turn begins.
The game should display a history of moves (chosen columns) for each player below the board.

        The game should be saveable and loadable. 
        At any point in the game, a player may choose to save the game. This should store all game info (piece positions, move history, …) into a file.
        When re-opening the game, there should be an option to load an existing “save file” and resume the game from the exact state it was left in.
        The game ends when one player manages to place four of their pieces in a row.
        The pieces can be connected horizontally, vertically and diagonally.
        You can display some nice victory screen afterwards, or just a simple “Victory” message. :)
        
If the entire board gets filled up without any player connecting 4 pieces, the game is a draw.
After the game ends, players should be prompted if they want to play again.

