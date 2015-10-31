class Mastermind

	CODE_SIZE = 4 #number of digits to guess
	CODE_RANGE = [1,6] #range of possible digits
	GAME_LENGTH = 12 #number of turns

	attr_reader :code
	attr_accessor :guess

	#init with a new code
	def initialize
		@code
		@guess

		input = ""
		until input=="codemaker" || input=="codebreaker" do
			puts "Are you the CODEMAKER or CODEBREAKER?"
			input = gets.chomp.downcase
		end

		if input == "codebreaker"
			@code = new_code
			human_play
		else
			puts "Enter a code for the computer to guess:"
			user_code = gets.chomp
			until is_valid?(user_code) do
				puts "Enter #{CODE_SIZE} numbers between #{CODE_RANGE.first} and #{CODE_RANGE.last}:"
				user_code = gets.chomp
			end
			@code = user_code.split(//)
			ai_play
		end
	end

	#creat a random code
	def new_code
		code = []
		CODE_SIZE.times do
			@code << rand(CODE_RANGE.first..CODE_RANGE.last).to_s
		end
		code
	end

	#is user generated code valid?
	def is_valid?(code)
		code.length == CODE_SIZE && code.split(//).all? { |c| c.to_i >= CODE_RANGE.first && c.to_i <= CODE_RANGE.last }
	end

	#does the guess match the code?
	def correct_guess?
		@guess == @code.join
	end

	def hint(guess)
		hint = []
		code_elements = @code.to_histogram
		guess_elements = guess.split(//).to_histogram
		guess.split(//).each_with_index do |g,i|
			#if element exists and is correctly placed
			if @code[i] == g
				hint << "O"
				code_elements[g] -= 1 #track correct elements
			#if element exists but not correctly placed
			elsif @code.include?(g) && guess_elements[g] <= code_elements[g] && guess_elements[g] > 0
				hint << "#"
			end
			guess_elements[g] -= 1 #track element checked
		end
		until hint.size == code.size do
			hint << "*"
		end
		hint.join
	end

	#play until the guess is correct or turns run out
	def human_play

		GAME_LENGTH.times do |turn|
			break if correct_guess?
			puts "Guess #{turn} of #{GAME_LENGTH}:"
			@guess = gets.chomp
			puts hint(@guess)
		end

		puts correct_guess? ? "You win!" : "Game over! The code was: #{@code.to_s}"
	end

	def ai_play
		GAME_LENGTH.times do |turn|
			break if correct_guess?
			guess = []
			CODE_SIZE.times do
				guess << rand(CODE_RANGE.first..CODE_RANGE.last).to_s
			end
			guess = guess.join
			puts "Guess #{turn} of #{GAME_LENGTH}:"
			puts guess
			puts hint(guess)
		end
		puts correct_guess? ? "I win!" : "I have failed :("
	end

end


class Array
	#helper function to find multiple indicies incase array contains duplicates
	def find_indicies(a)
		indicies = []
		self.each_with_index do |x,i|
			indicies << i if x == a
		end
		indicies
	end

	#helper function get frequency of elements in array
	def to_histogram
		histogram = {}
		self.each do |a|
			if !histogram[a]
				histogram[a] = 1
			else
				histogram[a] += 1
			end
		end
		histogram
	end
end