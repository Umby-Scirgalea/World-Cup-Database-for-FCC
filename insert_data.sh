#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# TRUNCATE EVERYTHING
echo "$($PSQL "TRUNCATE games, teams")"
echo "$($PSQL "ALTER SEQUENCE teams_team_id_seq RESTART WITH 1")"
echo "$($PSQL "ALTER SEQUENCE games_game_id_seq RESTART WITH 1")"


# INSERTING DATA  


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # TEAMS NAME
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  if [[ -z $TEAM_ID ]]
    then
    if [[ $OPPONENT != 'opponent'  ]]
    then
      INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM_NAME == "INSERT 0 1" ]]
        then echo "Inserted team $OPPONENT"
      fi
    fi
  fi

  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

  if [[ -z $TEAM_ID ]]
    then
    if [[ $WINNER != 'winner'  ]]
    then
      INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM_NAME == "INSERT 0 1" ]]
        then echo "Inserted team $WINNER."
      fi
    fi
  fi
  # TEAMS NAME
done


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # GAME
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  if [[ $YEAR != "year" ]]
  then
      INSERT_GAME=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
      if [[ $INSERT_GAME == "INSERT 0 1" ]]
        then 
        echo "Inserted Game of Year $YEAR: $WINNER vs $OPPONENT."
      fi
  fi
  #GAME

done
