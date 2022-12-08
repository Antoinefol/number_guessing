#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

#generate a number
SECRET_NUMBER=$((RANDOM % 1000 + 1))
#variables initialisation
echo "Enter your username:"
read USERNAME
PLAYER_NAME=$($PSQL "SELECT player_name FROM players_info WHERE player_name='$USERNAME'")
GAMES_PLAYED=$($PSQL "SELECT games_played FROM players_info WHERE player_name='$USERNAME'")
BEST_GAME=$($PSQL "SELECT best_game FROM players_info WHERE player_name='$USERNAME'")
NUMBER_OF_GUESSES="1"
#take username input

if [[ $USERNAME = $PLAYER_NAME ]]
then 
echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
else
echo "Welcome, $USERNAME! It looks like this is your first time here."
INSERT_NAME=$($PSQL "INSERT INTO players_info(player_name,games_played) VALUES('$USERNAME',0) ")
fi
#the game start 
echo "Guess the secret number between 1 and 1000:"
read GUESS

  
while [[ $GUESS != $SECRET_NUMBER ]]
do
  # Increment the number of guesses
  ((NUMBER_OF_GUESSES+=1))

  # Check if the guess is not an integer
  if  ! [[ $GUESS =~ ^[0-9]+$ ]] 
  then
    echo "That is not an integer, guess again:"
    read GUESS 
  else
    # Check if the guess is less than the secret number
    if [[ $GUESS < $SECRET_NUMBER ]]
    then
      echo "It's higher than that, guess again:"
      read GUESS
    else
      # Check if the guess is greater than the secret number
      if [[ $GUESS > $SECRET_NUMBER ]]
      then
        echo "It's lower than that, guess again:"
        read GUESS  
      fi   
    fi
  fi 
done
if [[ $GUESS = $SECRET_NUMBER ]]
then
echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
fi
  ((GAMES_PLAYED +=1))
  UPDATE_PLAYED=$($PSQL "UPDATE players_info SET games_played='$GAMES_PLAYED' WHERE player_name='$USERNAME' ")
if [[ -z $BEST_GAME  ]]
then
UPDATE_GUESS=$($PSQL "UPDATE players_info SET best_game='$NUMBER_OF_GUESSES' WHERE player_name='$USERNAME' ")
else if [[ $BEST_GAME > $NUMBER_OF_GUESSES ]]
then
UPDATE_GUESS=$($PSQL "UPDATE players_info SET best_game='$NUMBER_OF_GUESSES' WHERE player_name='$USERNAME' ")
fi
fi
