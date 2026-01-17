class TicTacToe
    def initialize
        @board = Array.new(9, ' ')
        @current_player = 'X'
        @human_player = 'X'
        @ai_player = 'O'
    end

    def play
        loop do
            display_board
            
            if game_over?
                display_result
                break
            end

            if @current_player == @human_player
                player_move
            else
                ai_move
            end
            switch_player
        end
    end

    private

    def display_board
        puts "\n"
        3.times do |row|
            start_idx = row * 3
            puts " #{@board[start_idx]} | #{@board[start_idx + 1]} | #{@board[start_idx + 2]} "
            puts "-----------" if row < 2
        end
        puts "\n"
    end

    def player_move
        loop do
            puts "Player #{@current_player}, enter position (1-9):"
            input = gets.chomp.to_i
            
            if input.between?(1, 9) && @board[input - 1] == ' '
                @board[input - 1] = @current_player
                break
            else
                puts "Invalid move! Try again."
            end
        end
    end

    def switch_player
        @current_player = @current_player == 'X' ? 'O' : 'X'
    end

    def ai_move
        # Priority 1: Win if possible
        winning_move = find_winning_move(@ai_player)
        return make_move(winning_move) if winning_move

        # Priority 2: Block opponent from winning
        blocking_move = find_winning_move(@human_player)
        return make_move(blocking_move) if blocking_move

        # Priority 3: Take center if available
        return make_move(4) if @board[4] == ' '

        # Priority 4: Take a corner
        corners = [0, 2, 6, 8]
        available_corner = corners.find { |pos| @board[pos] == ' ' }
        return make_move(available_corner) if available_corner

        # Priority 5: Take any available space
        available_moves = @board.each_index.select { |i| @board[i] == ' ' }
        make_move(available_moves.sample) if available_moves.any?
    end

    def find_winning_move(player)
        winning_combos = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],
            [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [2, 4, 6]
        ]
        
        winning_combos.each do |combo|
            positions = combo.map { |i| @board[i] }
            player_count = positions.count(player)
            empty_count = positions.count(' ')
            
            if player_count == 2 && empty_count == 1
                empty_index = combo[positions.index(' ')]
                return empty_index
            end
        end
        
        nil
    end

    def make_move(position)
        @board[position] = @current_player
        puts "AI plays position #{position + 1}"
    end


    def game_over?
        winner? || board_full?
    end

    def winner?
        winning_combos = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],
            [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [2, 4, 6]
        ]
        
        winning_combos.any? { |combo| @board[combo[0]] == @board[combo[1]] && @board[combo[1]] == @board[combo[2]] && @board[combo[0]] != ' ' }
    end

    def board_full?
        @board.none? { |cell| cell == ' ' }
    end

    def display_result
        winning_player = get_winner
        if winning_player
            puts "Player #{winning_player} wins!"
        else
            puts "It's a draw!"
        end
    end

    def get_winner
        winning_combos = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],
            [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [2, 4, 6]
        ]
        
        winning_combos.each do |combo|
            if @board[combo[0]] == @board[combo[1]] && @board[combo[1]] == @board[combo[2]] && @board[combo[0]] != ' '
                return @board[combo[0]]
            end
        end
        
        nil
    end
end

game = TicTacToe.new
game.play